function dmb_item_specify_contrasts = dmb_item_specify_contrasts

SPMs                        = cfg_files;
SPMs.tag                    = 'SPMs';
SPMs.name                   = 'SPMs';
SPMs.help                   = {'The SPMs to which the contrasts should be added.'};
SPMs.filter                 = 'mat';
SPMs.ufilter                = '.mat';
SPMs.num                    = [1 inf];

contrasts_file                        = cfg_files;
contrasts_file.tag                    = 'contrasts_file';
contrasts_file.name                   = 'Contrasts file';
contrasts_file.help                   = {'The contrasts file in which the contrasts are specified.'};
contrasts_file.filter                 = 'csv';
contrasts_file.ufilter                = '.csv';
contrasts_file.num                    = [1 1];

dmb_item_specify_contrasts       = cfg_exbranch;
dmb_item_specify_contrasts.tag   = 'dmb_item_specify_contrasts';
dmb_item_specify_contrasts.name  = 'Specify contrasts';
dmb_item_specify_contrasts.help  = {'Automatically specify contrasts from csv file.'};
dmb_item_specify_contrasts.val   = {SPMs, contrasts_file};
dmb_item_specify_contrasts.prog  = @dmb_run_specify_contrasts;
dmb_item_specify_contrasts.vout  = @dmb_vout_specify_contrasts;