function dmb_item_estimate_contrasts = dmb_item_estimate_contrasts
SPMs                        = cfg_files;
SPMs.tag                    = 'SPMs';
SPMs.name                   = 'SPMs';
SPMs.help                   = {'The SPMs to which the contrasts should be added.'};
SPMs.filter                 = 'mat';
SPMs.ufilter                = '.mat';
SPMs.num                    = [1 inf];

contrasts             = cfg_entry;
contrasts.name        = 'Contrasts';
contrasts.tag         = 'contrasts';
contrasts.help        = {'Which contrasts to calculate.'};
contrasts.strtype     = 'e';
contrasts.num         = [0 inf];

dmb_item_estimate_contrasts           = cfg_exbranch;
dmb_item_estimate_contrasts.tag       = 'dmb_item_estimate_contrasts';
dmb_item_estimate_contrasts.name      = 'Run contrasts';
dmb_item_estimate_contrasts.help      = {'Run already specified contrasts'};
dmb_item_estimate_contrasts.val       = {SPMs, contrasts};
dmb_item_estimate_contrasts.prog      = @dmb_run_estimate_contrasts;
% dmb_item_estimate_contrasts.vout      = @dmb_vout_estimate_contrasts;