function dep = vout(job)
% This depends on job contents, which may not be present when virtual
% outputs are calculated.

cdep = cfg_dep;
cdep(end).sname      = 'Seg Params';
cdep(end).src_output = substruct('.','param','()',{':'});
cdep(end).tgt_spec   = cfg_findspec({{'filter','mat','strtype','e'}});

for i=1:numel(job.channel),
    if job.channel(i).write(1),
        cdep(end+1)          = cfg_dep;
        cdep(end).sname      = sprintf('Bias Field (%d)',i);
        cdep(end).src_output = substruct('.','channel','()',{i},'.','biasfield','()',{':'});
        cdep(end).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
    end
    if job.channel(i).write(2),
        cdep(end+1)          = cfg_dep;
        cdep(end).sname      = sprintf('Bias Corrected (%d)',i);
        cdep(end).src_output = substruct('.','channel','()',{i},'.','biascorr','()',{':'});
        cdep(end).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
    end
end

for i=1:numel(job.tissue),
    if job.tissue(i).native(1),
        cdep(end+1)          = cfg_dep;
        cdep(end).sname      = sprintf('c%d Images',i);
        cdep(end).src_output = substruct('.','tiss','()',{i},'.','c','()',{':'});
        cdep(end).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
    end
    if job.tissue(i).native(2),
        cdep(end+1)          = cfg_dep;
        cdep(end).sname      = sprintf('rc%d Images',i);
        cdep(end).src_output = substruct('.','tiss','()',{i},'.','rc','()',{':'});
        cdep(end).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
    end
    if job.tissue(i).warped(1),
        cdep(end+1)          = cfg_dep;
        cdep(end).sname      = sprintf('wc%d Images',i);
        cdep(end).src_output = substruct('.','tiss','()',{i},'.','wc','()',{':'});
        cdep(end).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
    end
    if job.tissue(i).warped(2),
        cdep(end+1)          = cfg_dep;
        cdep(end).sname      = sprintf('mwc%d Images',i);
        cdep(end).src_output = substruct('.','tiss','()',{i},'.','mwc','()',{':'});
        cdep(end).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
    end
end

if job.warp.write(1),
    cdep(end+1)          = cfg_dep;
    cdep(end).sname      = 'Inverse Deformations';
    cdep(end).src_output = substruct('.','invdef','()',{':'});
    cdep(end).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
end

if job.warp.write(2),
    cdep(end+1)          = cfg_dep;
    cdep(end).sname      = 'Forward Deformations';
    cdep(end).src_output = substruct('.','fordef','()',{':'});
    cdep(end).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
end

cdep(end+1) = cfg_dep;
cdep(end).sname      = sprintf('All Images');
cdep(end).src_output = substruct('.','tiss','()',{':'},'.','c','()',{':'});
cdep(end).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});

dep = cdep;