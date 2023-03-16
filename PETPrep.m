function [] = PETPrep(data_dir, config, fs_dir)
% The PETPrep pipeline is a state-of-the-art PET preprocessing pipeline (wrapper),
% performing motion correction, co-registration, segmentation, partial
% volume correction and kinetic modeling on BIDS structured datasets
% containing at least one dynamic PET scan and one anatomical MRI scan. 
% 
% Parameters
% ----------
% data_dir : str
%   path to BIDS data directory
% config : str 
%   path to PETPrep configuration file
% fs_dir : str 
%   path to FreeSurfer outputs
%
% Returns
% -------
% None
%
% Author: Martin Norgaard, Stanford University, 2022


cd(data_dir)
addpath(genpath(fullfile(data_dir,'code')));

% load BIDS data into matlab
BIDS = bids.layout(data_dir);

% load config file
BIDS.config = bids.util.jsondecode(['code/' config]);

% create derivatives directories
create_dirs_derivative(BIDS, ['code/' config])

config_num = regexp(config,'\d*','Match');
if ~isempty(config_num)
    BIDS.config.env.derivatives_dir = [BIDS.config.env.derivatives_dir config_num{1}];
end

% Recon-all FreeSurfer
ReconAll(BIDS)

% GTMSeg
GTMSeg(BIDS)

% FreeSurfer output to derivatives
ConvertFS2BIDS(BIDS,fs_dir)

% Motion Correction
if strcmp(BIDS.config.preproc.mc.precomp,'hmc_workflow')
    PreCompMotionCorrection(BIDS)
elseif strcmp(BIDS.config.preproc.mc.precomp,'no_hmc')
    NoMotionCorrection(BIDS)
else
    MotionCorrection(BIDS)
    PlotMotion(BIDS)
end

% Co-registration
CoReg(BIDS,fs_dir)
PlotCoReg(BIDS)

% GTMPVC
if strcmp(BIDS.config.preproc.pvc.pvc,'agtm')
    GTMPVC(BIDS,fs_dir)
    PETsurfer2TAC(BIDS)
    BIDS.config.preproc.pvc.pvc = 'nopvc';
    GTMPVC(BIDS, fs_dir)
    BIDS.config.preproc.pvc.pvc = 'agtm';
else
    BIDS.config.preproc.pvc.pvc = 'nopvc';
    GTMPVC(BIDS, fs_dir)
    PETsurfer2TAC(BIDS)
end

% Surface-based analysis
PETVol2Surf(BIDS, fs_dir)

% Volume-based analysis
PETVol2Vol(BIDS, fs_dir)

kinsurf(BIDS, fs_dir)
kinvol(BIDS, fs_dir)




    