#! /usr/bin/python3
# usage : mpirun -n 4 python3 ./mpi_primes2.py

# Copyright 2022 by Elana Courtines, student at Université Paul Sabatier.
# All rights reserved.
# This file is part of the public notes sharing project,
# and is released under the "MIT License Agreement".



import sys
import time
from mpi4py import MPI

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()

def nb_primes(n):
    result = 0
    for i in range(1, n+1):
        if n%i == 0:
            result += 1
    return result

if __name__ == '__main__':
    upper_bound = int(sys.argv[1])

    current_max = 0

    comm.barrier()
    start_time = time.time()

    val = rank+1
    while val < upper_bound+1:
        #print("[",rank,"] val :",val)
        tmp = nb_primes(val)
        current_max = max(current_max, tmp)
        val = val + size

    global_max = comm.reduce(current_max, op = MPI.MAX, root=0)

    end_time = time.time()

    if rank == 0:
        print("[", rank, "] global max :", global_max, " in ", end_time-start_time, 'seconds')


