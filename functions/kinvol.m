function BIDS = kinvol(BIDS, fs_dir)

output_dir = fullfile(BIDS.pth,'derivatives',BIDS.config.env.derivatives_dir);
if exist(fs_dir)
    setenv('SUBJECTS_DIR',fs_dir)
else
    fs_dir = fullfile(BIDS.pth,'derivatives','freesurfer');
    setenv('SUBJECTS_DIR',fullfile(BIDS.pth,'derivatives','freesurfer'));
end

for idx = 1:numel(BIDS.subjects)
    subj = BIDS.subjects(idx).name;
    ses = BIDS.subjects(idx).session;

    input_file = fullfile(BIDS.pth, 'derivatives/rCPS', subj, ses, ...
        [subj '_' ses '_desc-VcPDIF_stat-rCPS_statmap.nii.gz']);

    output_file = fullfile(output_dir, subj, ses, ...
        'pet',[subj '_' ses '_space-mni305_pvc-nopvc_desc-VcPDIF_rcps.nii.gz']);

    lta_file = fullfile(output_dir, subj, ses, ...
        'pet', [subj '_' ses '_from-pet_to-T1w_reg.lta']);

    unix(['mri_vol2vol --mov '  input_file ...
        ' --reg ' lta_file ...
        ' --tal' ...
        ' --talres 2' ...
        ' --o ' output_file]);

    input_file = fullfile(output_dir, subj, ses, ...
        'pet',[subj '_' ses '_space-mni305_pvc-nopvc_desc-VcPDIF_rcps.nii.gz']);

    output_file = fullfile(output_dir, subj, ses, ...
        'pet',[subj '_' ses '_space-mni305_sm-06_desc-VcPDIF_rcps.nii.gz']);

    unix(['mri_fwhm --smooth-only --i '  input_file ...
        ' --fwhm 6 ' ...
        ' --mask $FREESURFER_HOME/subjects/fsaverage/mri.2mm/brainmask.mgz' ...
        ' --o ' output_file]);

end
