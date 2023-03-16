function BIDS = GTMPVC(BIDS, fs_dir)
%
%
%

output_dir = fullfile(BIDS.pth,'derivatives',BIDS.config.env.derivatives_dir);
if exist(fs_dir)
    setenv('SUBJECTS_DIR',fs_dir)
else
fs_dir = fullfile(BIDS.pth,'derivatives','freesurfer');
setenv('SUBJECTS_DIR',fullfile(BIDS.pth,'derivatives','freesurfer'));
end

if BIDS.config.env.nproc > 1
    parpool('local',BIDS.config.env.nproc)
    parfor idx = 1:numel(BIDS.subjects)
        subj = BIDS.subjects(idx).name;
        ses = BIDS.subjects(idx).session;
        input_file = fullfile(output_dir, subj, ses, ...
            'pet', [subj '_' ses '_desc-mc_pet.nii.gz']);

        mean_file = fullfile(output_dir, subj, ses, ...
            'pet', [subj '_' ses '_desc-mc_mean.nii.gz']);

        lta_file = fullfile(output_dir, subj, ses, ...
            'pet', [subj '_' ses '_from-pet_to-T1w_reg.lta']);

        seg_file = fullfile(fs_dir, subj, 'mri/gtmseg.mgz');

        pvc_dir = fullfile(output_dir, subj, ses, ...
            'pet', BIDS.config.preproc.pvc.pvc);

        cmd = ['mri_gtmpvc --i '  input_file ...
            ' --reg ' lta_file ...
            ' --psf ' num2str(BIDS.config.preproc.pvc.psf) ...
            ' --seg ' seg_file ...
            ' --default-seg-merge --auto-mask 1 .01' ...
            ' --km-ref ' BIDS.config.preproc.pvc.ref ...
            ' --km-hb ' BIDS.config.preproc.pvc.hb ...
            ' --no-rescale ' ...
            ' --save-input ' ...
            ' --save-yhat ' ...
            '--o ' pvc_dir];

        if strcmp(BIDS.config.preproc.pvc.pvc, 'mgx')
            cmd = append(cmd, ' --mgx .01');
            unix(cmd);
        elseif strcmp(BIDS.config.preproc.pvc.pvc, 'rbv')
            cmd = append(cmd, ' --rbv');
            unix(cmd);
        elseif strcmp(BIDS.config.preproc.pvc.pvc, 'agtm')
            unix(['mri_gtmpvc --i ' mean_file ...
                ' --reg ' lta_file ...
                ' --o ' pvc_dir ...
                ' --psf ' num2str(BIDS.config.preproc.pvc.psf) ...
                ' --opt 3 '...
                ' --opt-tol 4 10e-6 .02 ' ...
                ' --seg ' seg_file ...
                ' --opt-brain ' ...
                ' --auto-mask 1 0.01 ' ...
                ' --opt-seg-merge ' ...
                ' --no-rescale ' ...
                ' --threads 1'])

            fwhm = load(fullfile(output_dir, subj, ses, ...
                'pet', BIDS.config.preproc.pvc.pvc, '/aux/opt.params.dat'));

            cmd = ['mri_gtmpvc --i '  input_file ...
                ' --reg ' lta_file ...
                ' --psf-col ' num2str(fwhm(1)) ...
                ' --psf-row ' num2str(fwhm(2)) ...
                ' --psf-slice ' num2str(fwhm(3)) ...
                ' --seg ' seg_file ...
                ' --default-seg-merge --auto-mask 1 .01' ...
                ' --km-ref ' BIDS.config.preproc.pvc.ref ...
                ' --km-hb ' BIDS.config.preproc.pvc.hb ...
                ' --no-rescale ' ...
                ' --save-input ' ...
                ' --save-yhat ' ...
                '--o ' pvc_dir];

            unix(cmd)
        else
            unix(cmd)
        end

    end
    delete(gcp('nocreate'));
else
    for idx = 1:numel(BIDS.subjects)
        subj = BIDS.subjects(idx).name;
        ses = BIDS.subjects(idx).session;
        input_file = fullfile(output_dir, subj, ses, ...
            'pet', [subj '_' ses '_desc-mc_pet.nii.gz']);

        mean_file = fullfile(output_dir, subj, ses, ...
            'pet', [subj '_' ses '_desc-mc_mean.nii.gz']);

        lta_file = fullfile(output_dir, subj, ses, ...
            'pet', [subj '_' ses '_from-pet_to-T1w_reg.lta']);

        seg_file = fullfile(fs_dir, subj, 'mri/gtmseg.mgz');

        pvc_dir = fullfile(output_dir, subj, ses, ...
            'pet', BIDS.config.preproc.pvc.pvc);

        cmd = ['mri_gtmpvc --i '  input_file ...
            ' --reg ' lta_file ...
            ' --psf ' num2str(BIDS.config.preproc.pvc.psf) ...
            ' --seg ' seg_file ...
            ' --default-seg-merge --auto-mask 1 .01' ...
            ' --km-ref ' BIDS.config.preproc.pvc.ref ...
            ' --km-hb ' BIDS.config.preproc.pvc.hb ...
            ' --no-rescale ' ...
            ' --save-input ' ...
            ' --save-yhat ' ...
            '--o ' pvc_dir];

        if strcmp(BIDS.config.preproc.pvc.pvc, 'mgx')
            cmd = append(cmd, ' --mgx .01');
            unix(cmd);
        elseif strcmp(BIDS.config.preproc.pvc.pvc, 'rbv')
            cmd = append(cmd, ' --rbv');
            unix(cmd);
        elseif strcmp(BIDS.config.preproc.pvc.pvc, 'agtm')
            unix(['mri_gtmpvc --i ' mean_file ...
                ' --reg ' lta_file ...
                ' --o ' pvc_dir ...
                ' --psf ' num2str(BIDS.config.preproc.pvc.psf) ...
                ' --opt 3 '...
                ' --opt-tol 4 10e-6 .02 ' ...
                ' --seg ' seg_file ...
                ' --opt-brain ' ...
                ' --auto-mask 1 0.01 ' ...
                ' --opt-seg-merge ' ...
                ' --no-rescale ' ...
                ' --threads 1'])

            fwhm = load(fullfile(output_dir, subj, ses, ...
                'pet', BIDS.config.preproc.pvc.pvc, '/aux/opt.params.dat'));

            cmd = ['mri_gtmpvc --i '  input_file ...
                ' --reg ' lta_file ...
                ' --psf-col ' num2str(fwhm(1)) ...
                ' --psf-row ' num2str(fwhm(2)) ...
                ' --psf-slice ' num2str(fwhm(3)) ...
                ' --seg ' seg_file ...
                ' --default-seg-merge --auto-mask 1 .01' ...
                ' --km-ref ' BIDS.config.preproc.pvc.ref ...
                ' --km-hb ' BIDS.config.preproc.pvc.hb ...
                ' --no-rescale ' ...
                ' --save-input ' ...
                ' --save-yhat ' ...
                '--o ' pvc_dir];

            unix(cmd)
        else
            unix(cmd)
        end
        
    end
end