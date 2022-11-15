#! /usr/bin/python3
# usage : mpirun -n 4 python3 ./mpi_heat_cut.py

# Copyright 2022 by Elana Courtines, student at Université Paul Sabatier.
# All rights reserved.
# This file is part of the public notes sharing project,
# and is released under the "MIT License Agreement".



import time
import random
import functools
import matplotlib.pyplot as plt
from mpi4py import MPI

# warnings suppression 
import warnings
def fxn():
    warnings.warn("deprecated", DeprecationWarning)

def init_matrix(size_x, size_y):
    result = []
    for _ in range(size_x):
        result.append([0]*size_y)
    return result

def print_matrix(matrix):
    size_x = len(matrix)
    size_y = len(matrix[0])
    for y in range(size_y):
        for x in range(size_y):
            print(matrix[x][y], end=' ')
        print()

def add_hot_spots(matrix, number):
    size_x = len(matrix)
    size_y = len(matrix[0])

    for i in range(number):
        x = random.randrange(1, size_x-1)
        y = random.randrange(1, size_y-1)
        matrix[x][y] = random.randint(500, 1000)


def get_val(matrix, x, y):
    tmp = matrix[x][y] + matrix[x-1][y] + matrix[x+1][y] + matrix[x][y-1] + matrix[x][y+1]
    return tmp // 5


def get_signature(matrix):
    return functools.reduce(lambda a,b: a^b, [sum(col) for col in matrix])



# warning suppresion context
with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    fxn()

    comm = MPI.COMM_WORLD
    rank = comm.Get_rank()
    size = comm.Get_size()

    random.seed(7)
    n = 1000
    
    if rank == 0: # only process 0 initiate the matrix
        matrix = init_matrix(n, n)
        add_hot_spots(matrix, 400)
    else:
        matrix = None

    debut = rank * (n // size)      # every process calculates what part of the matrix
    fin = (rank+1) * (n // size)    # it has to compute

    tmp_matrix = init_matrix(n, n)  # every process need its own tmp_matrix
    matrix = comm.bcast(matrix,root=0) # but they all need the base matrix
    
    init_time = time.time()
    for _ in range(20): # difference cases based on world size a process number
        if size == 1:               # if there is only 1 process
            for x in range(debut+1, fin-1): # skip rows 0 and n-1
                for y in range(1, n-1):     # skip columns 0 and n-1
                    tmp_matrix[x][y] = get_val(matrix, x, y) # compute
        elif rank == size - 1:      # if it is the last process
            for x in range(debut, fin-1):   # skip row n-1
                for y in range(1, n-1):     # skip columns 0 and n-1
                    tmp_matrix[x][y] = get_val(matrix, x, y) # compute
        elif rank == 0:             # if it is the first process
            for x in range(debut+1, fin):   # skip row 0
                for y in range(1, n-1):     # skip columns 0 and n-1
                    tmp_matrix[x][y] = get_val(matrix, x, y) # compute
        else:                       # every other processes
            for x in range(debut, fin):     # don't skip any row
                for y in range(1, n-1):     # skip columns 0 and n-1
                    tmp_matrix[x][y] = get_val(matrix, x, y) # compute
        # every processes Must receive the updated matrix
        matrix = comm.allreduce(tmp_matrix[debut:fin])
    
    final_time = time.time()
    if rank == 0:
        print('Total time:', final_time-init_time, 's')
        print('Signature:', get_signature(matrix))
        plt.imshow(matrix, cmap='hot', interpolation='nearest')
        plt.colorbar()
        plt.savefig('heat.pdf')  
        plt.show(block=True)
