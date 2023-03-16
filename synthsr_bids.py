#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 12 13:13:37 2022

@author: martinnorgaard
"""
from bids import BIDSLayout
import os

data_path = '/Volumes/Crucial_X6/nimh/ds004291'
data = BIDSLayout(data_path)

T1ws = data.get(suffix='T1w', extension='.nii.gz')
derivatives_dir = '/Volumes/Crucial_X6/nimh/ds004291/derivatives/synthsr'
os.chdir(derivatives_dir)

for idx in range(len(T1ws)):
    subj_ses_path = os.path.join(derivatives_dir,'sub-' + T1ws[idx].get_entities()['subject'],'ses-' + T1ws[idx].get_entities()['session'],'anat')
    out_file = 'sub-' + T1ws[idx].get_entities()['subject'] + '_ses-' + T1ws[idx].get_entities()['session'] + '_T1w.nii.gz'
    os.makedirs(subj_ses_path)
    os.chdir(subj_ses_path)
    
    os.system('mri_synthsr --i ' + T1ws[idx].path + ' --o ' + out_file + ' --cpu')
    
    os.chdir(derivatives_dir)
    
    
    
    