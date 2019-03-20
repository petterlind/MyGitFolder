from math import *
import gc
import math
import numpy as np
import os
from numpy import linalg as nLA
import pickle
# import pickle
from scipy import optimize
from scipy import linalg as sLA
import time
# from multiProcesser import multiProcesser
import multiprocessing
import matplotlib.pyplot as plt
import subprocess
import pdb

def geomfile(geometry):
	''' Function that writes the geom-specs into a file'''
	os.chdir(r"C:\Users\pettlind\Dropbox\KTH\PhD\Article2\abaqus\model")
	cwd = os.getcwd()
	
	# model()
	# W = geometry[0]
	# Lext = geometry[1]
	# Lh = geometry[2]
	# Wt = geometry[3]
	# T = geometry[4]
	# R = geometry[5]
	# theta = geometry[6]
	# E = geometry[7]
	# load_steps = geometry[8]

	# file_path = cwd+'\DogboneTensileTestGeom.dat'
	# f = open(file_path, 'w')
	# 
	# f.write('#W, Lext, Lh, Wt, T, R, theta, E-mod\n')
	# f.write(str(W)+' '+str(Lext)+' '+str(Lh)+' '+str(Wt)+' '+str(T)+' '+str(R)+' '+str(theta)+' '+str(E)+' '+str(load_steps))
	# 
	# f.close()

def run_win_cmd(cmd):
	''' Runs the cmd-commands for the script file'''
	
	result = []
	process = subprocess.Popen(cmd, shell=True,
								stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	for line in process.stdout:
		result.append(line)
	errcode = process.returncode
	for line in result:
		print(line)
	if errcode is not None:
		raise Exception('cmd %s failed, see above for details', cmd)


# ------------------------------ START OF PROGRAM -----------------------------------------

cwd = os.getcwd()
num_cpus = 4
# ------ PARAMETERS ------
# Define in list for more parameters

file_n = 'model'
h1 = 4 * 1e-2
h2 = 4 * 1e-2
h3 = 4 * 1e-2
w1 = 4 * 1e-2
w1 = 4 * 1e-2
w3 = 4 * 1e-2
l1 = 1 * 1e-2
l2 = 2 * 1e-2
l3 = 3 * 1e-2

#  For loop here?

# Define what parameters that needs to be changed, write in a "geomfile"
geometry = [h1, h2, h3, w1, w1, w3, l1, l2, l3]
geomfile(geometry)

# Run the program
stop_flag = 0
k = 1
error_flag = 'none'
while stop_flag == 0 and k < 10:   # this loop is to ensure that the program does not crash if there is a license error.
	try:
		# Run the code
		run_win_cmd('abaqus cae noGUI=' + file_n + '.py')
		# run_win_cmd('abaqus cae noGUI=odbPostProcTensile.py')
	
		# Run the Odb-reader
		run_win_cmd('abaqus python odbread.py')
		
		os.remove(cwd + r'\model.com')
		os.remove(cwd + r'\model.dat')
		os.remove(cwd + r'\model.log')
		os.remove(cwd + r'\model.msg')
		os.remove(cwd + r'\model.odb')
		os.remove(cwd + r'\model.prt')
		os.remove(cwd + r'\model.sim')
		os.remove(cwd + r'\model.sta')
		

	
	except:
		error_flag = 'Abaqus'

	if error_flag is not 'none':  # some error!
		print('Abaqus error! It is likely that it is a license issue.')
		print('Error: ' + error_flag)
		print('Retrying.')
		print('')
		if k >= 5:
				print('----- Have done' + str(k) + 'tries -----')
				print('')
		time.sleep(1)  # waits 1 sec before trying again.
		k += 1
	else:
		print(error_flag)
		stop_flag = 1
		

print('-----------------------------------------------------------------------')
print('Done!')
print('Print something of importance!')
print('Number of cpus: ', num_cpus)
