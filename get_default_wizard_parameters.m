function param_struct = get_default_wizard_parameters()

params.session_data.stim_type = 'cortical';
params.session_data.data_channel = 1;
params.session_data.sig_start = 258;
params.session_data.sig_end = 272;
params.session_data.analysis_type = 'sigmoid';
params.session_data.filter_cutoff_lower = 5;
params.session_data.filter_cutoff_upper = 300;
params.session_data.line_notch = 0;
params.session_data.line_notch_harmonic = 1;

params.data_quant.fit_tolerance = 0.1;
params.data_quant.latency_thresh = 0.05;