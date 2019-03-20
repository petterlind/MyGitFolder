#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Wed Apr  5 11:45:37 2017

@author: petter
"""

import odbAccess
from abaqusConstants import * 
import numpy as np

# try:
    # open the .odb
name = 'result'
odbObj = odbAccess.openOdb(path='Job-1.odb')

LastFrame = odbObj.steps['Step-1'].frames[-1]
# choose data

Stress = LastFrame.fieldOutputs['S'].getSubset(position=ELEMENT_NODAL, region=odbObj.rootAssembly.instances['DRAGLINK-1'].elementSets['SET-1'])
vm_stress = Stress.getScalarField(invariant=MISES)
#            fieldStressPla = i.fieldOutputs['S'].getSubset(position=ELEMENT_NODAL, region=odbObj.rootAssembly.instances['Draglink-1'].elementSets['MEASURE2'])
Disp = LastFrame.fieldOutputs['U']

e_vol = LastFrame.fieldOutputs['EVOL']
# Loop through stress and disp and print down the largest values.
vm_max = 0
d_max = 0

# Loop over elements
e_tot = 0
for ev in e_vol.values:
    e_tot += ev.data

# Loop over GP!
for vm in vm_stress.values:
    vm_max = max(vm_max, vm.data)
    
# Loop over nodes
for d in Disp.values:
    d_max = max(d_max, np.linalg.norm(d.data))
# writes the input to a file.
with open('data/' + name + ".csv", "a") as matFile:
        matFile.writelines(str(vm_max) + ',' + str(d_max) + ',' + str(e_tot) + '\n')

# print 'Nr',loops,'with name:', name, 'is done'
# loops +=1
    
    
