#! /usr/bin/python3
# usage : mpirun -n 4 python3 ./mpi_stretching.py

# Copyright 2022 by Elana Courtines, student at Université Paul Sabatier.
# All rights reserved.
# This file is part of the public notes sharing project,
# and is released under the "MIT License Agreement".



from mpi4py import MPI
import math
import time
import numpy as np
import matplotlib.image as mpimg
import matplotlib.pyplot as plt 
import matplotlib.cm as cm

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()

M = 255

# First method for stretching contrast
def f_one(x,n):
	if x==0:
		return 0
	return int(M**(1-n) * (x**n))

# Second method for stretching contrast
def f_two(x,n):
	if x==0:
		return 0
	return int((M**((n-1)/n)) * (x**(1/n)))

# Converts an image to grayscale
def rgb2gray(rgb):
    return np.dot(rgb[...,:3], [0.299, 0.587, 0.114])

# splits a vector "x" in "size" part. In case it does not divide well, the last one receives one less than others
def split(x, qt):
	n = math.ceil(len(x) / qt)
	return [x[n*i:n*(i+1)] for i in range(qt-1)]+[x[n*(qt-1):len(x)]]

# unsplits a list x composed of n lists of t elements
def unsplit(x):
	y = []
	n = len(x)
	t = len(x[0])
	for i in range(n):
		for j in range(len(x[i])):
			y.append(x[i][j])
	return y, n, t

# Loads an image on disk named "image.png" and convert it to greyscale, and shows it
def readImage():
	img = mpimg.imread('image.png')
	#print(img.shape)
	plt.imshow(img)
	plt.show()
	grey = rgb2gray(img)
	plt.imshow(grey, cmap = cm.Greys_r)
	pixels, nblines, nbcolumns = unsplit(grey)
	for i in range(0, len(pixels)):
		pixels[i] = int(pixels[i]*255)
	return pixels, nblines, nbcolumns

# Saves the image in "image-grey2-stretched.png" and shows it
def saveImage(newP, nblines, nbcolumns):
	newi = split(newP, nblines)
	newimg = np.zeros((nblines, nbcolumns))
	for rownum in range(nblines):
		for colnum in range(nbcolumns):
			newimg[rownum][colnum] = newi[rownum][colnum]
	plt.imshow(newimg, cmap = cm.Greys_r)
	plt.show()
	mpimg.imsave('image-grey2-stretched.png', newimg, cmap = cm.Greys_r )

if __name__ == '__main__':
	# load the image
	if rank == 0:
		print("Starting stretching...")
		pixels, nblines, nbcolumns = readImage()
		splitedPixels = split(pixels,size)
	else:
		splitedPixels, pixels = None,None

	comm.barrier()
	start_time = time.time()
	localPixels = comm.scatter(splitedPixels, root=0)

	# compute min and max of pixels
	local_pix_min = min(localPixels)
	local_pix_max = max(localPixels)
	pix_min = comm.allreduce(local_pix_min, op=MPI.MIN)
	pix_max = comm.allreduce(local_pix_max, op=MPI.MAX)
	# compute alpha, the parameter for f_* functions
	alpha = 1+(pix_max - pix_min) / M

	# stretch contrast for all pixels. f_one and f_two are the two different methods
	if rank%2 == 0:
		for i in range(0,len(localPixels)):
			localPixels[i] = f_one(localPixels[i], alpha)
	else:
		for i in range(0,len(localPixels)):
			localPixels[i] = f_two(localPixels[i], alpha)
	pixels = comm.gather(localPixels, root=0)
	end_time = time.time()
	# save the image
	if rank == 0:
		newPixels = []
		for i in range(size):
			newPixels = newPixels+pixels[i]

		saveImage(newPixels, nblines, nbcolumns)
		print("Stretching done in ", end_time-start_time, 'seconds')




