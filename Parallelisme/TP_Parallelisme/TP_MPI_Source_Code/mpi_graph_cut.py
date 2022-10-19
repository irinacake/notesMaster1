#! /usr/bin/python3
# usage : mpirun -n 4 python3 ./mpi_graph_cut.py

# Copyright 2022 by Elana Courtines, student at Université Paul Sabatier.
# All rights reserved.
# This file is part of the public notes sharing project,
# and is released under the "MIT License Agreement".



from hashlib import new
from matplotlib import pyplot as plt
import networkx as nx
import time
from mpi4py import MPI
import math

# warnings suppression 
import warnings
def fxn(): # this function's sole purpose is to supress 'deprecated' warnings
    warnings.warn("deprecated", DeprecationWarning)

def split(x, qt): # provided in a previous exercice
	n = math.ceil(len(x) / qt)
	return [x[n*i:n*(i+1)] for i in range(qt-1)]+[x[n*(qt-1):len(x)]]

def plot_graph(graph, save=False, display=True): # provided
    g1=graph
    plt.tight_layout()
    nx.draw_networkx(g1, arrows=True)
    if save:
        plt.savefig("graph.png", format="PNG")
    if display:
        plt.show(block=True)

# warning suppresion context
with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    fxn()

    comm = MPI.COMM_WORLD
    rank = comm.Get_rank()
    size = comm.Get_size()

    if rank == 0: # only processus 0 initiates the graph
        graph = nx.gnr_graph(10000, .01).reverse()
    else :
        graph = None
    # every processes require the graph to compute
    graph = comm.bcast(graph,root=0)

    new_elements = [0] # We start at the root (node = 0)
    old_elements = []  # We initialize the already seen nodes

    comm.barrier() # time accuracy
    start_time = time.time()

    while len(new_elements) != 0: # as long as we have new node
        if rank == 0: # nodes to be computed have to be dynamically assigned every iteration
            splitted_elements = split(new_elements,size)
        else:
            splitted_elements = None
        # each process has its own set of nodes to compute
        my_elements = comm.scatter(splitted_elements, root=0)

        tmp = []
        if (len(my_elements) != 0 ):
            for node_src in my_elements: # we take all these nodes
                for node in graph.neighbors(node_src): # we take all their descendents
                    if not node in old_elements and not node in my_elements and not node in tmp:
                        # If the descendent is not already seen, we keep it
                        tmp.append(node)

        # have all processes update the old elements because they all need it anyway
        old_elements += new_elements

        new_elements = [] # we are appending to an empty list
        all_tmp = comm.allgather(tmp) # every processes MUST have the updated loop condition
        for i in range(len(all_tmp)): # so have them all do this operation
            if all_tmp[i] not in new_elements: # avoid duplicates !!
                new_elements += all_tmp[i] # these are the new node, we will see them on the next iteration
        # with graphs becoming excessively big (>10^10?), it could be interesting to parallelize this loop

    end_time = time.time()

    if rank == 0:
        print("[", rank, "] Result :", len(old_elements) == len(graph), " in ", end_time-start_time, 'seconds')
        # don't try to plot a graph with thousands of nodes (:
        #plot_graph(graph, save=True, display=True)