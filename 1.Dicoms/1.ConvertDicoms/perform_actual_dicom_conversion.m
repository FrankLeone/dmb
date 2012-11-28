function out = perform_actual_dicom_conversion(job)
hdr = dmb_run_spm_dicom_headers(strvcat(job.data), job.dict, true);
out = spm_dicom_convert(hdr,'all',job.rootdir,job.convopts.format);