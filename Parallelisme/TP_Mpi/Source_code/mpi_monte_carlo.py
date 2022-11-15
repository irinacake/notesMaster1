#! /usr/bin/python3
# usage : mpirun -n 2 python3 ./mpi_monte_carlo.py

# Copyright 2022 by Elana Courtines, student at Université Paul Sabatier.
# All rights reserved.
# This file is part of the public notes sharing project,
# and is released under the "MIT License Agreement".



import time
import random
from mpi4py import MPI

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()

if __name__ == '__main__':
    nb = 15000000
    inside = 0
    random.seed(rank) #use the rank as the seed so they don't all do the same thing

    comm.barrier()
    start_time = time.time()
    for _ in range(nb//size): #reduce the amount of calculation depending on the amount of processes
        x = random.random()
        y = random.random()
        if x*x + y*y <= 1:
            inside +=1
    end_time = time.time()

    if rank == 0: #make sure that pi is initialized for every processes
        pi = 0
    else:
        pi = None

    pi = comm.reduce(inside, op=MPI.SUM, root=0)  #p0 retrieves everything in a reduce-sum

    if rank == 0:
        print("[",rank,"] Pi =", 4 * pi/nb, "in ", end_time-start_time, 'seconds')
