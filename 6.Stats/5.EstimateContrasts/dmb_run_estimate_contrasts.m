function out = dmb_run_estimate_contrasts(job)

%%
%% Read in input arguments
%%

SPM_dirs = job.SPMs;
out(1).SPMs = SPM_dirs;
contrasts = job.contrasts;

%%
%% Initialize variables
%%

old_dir = pwd;

nr_of_contrasts = length(contrasts);
significance_level = 0.25;
nr_SPM = 1;

while nr_SPM <= length(SPM_dirs)
    
    SPM_dir         = SPM_dirs{nr_SPM};
    
    if exist(SPM_dir, 'file')
        load (SPM_dir);
        xCon = SPM.xCon;
        order   = SPM.xBF.order;
        clear SPM;
        
        if nr_of_contrasts == 0;
            contrasts = {xCon.name};
            nr_of_contrasts = length(contrasts);
        end
        
        for nr_contrast = 1:nr_of_contrasts
            for nr_order = 1: order
                xSPM.swd            = SPM_dir(1:max(find(SPM_dir == filesep)));
                
                if iscell(contrasts)
                    xSPM.Ic             = find(strcmp({xCon.name}, [contrasts{nr_contrast} '_' num2str(nr_order)]));
                else
                    xSPM.Ic = contrasts(nr_contrast);
                end
                if isempty(xSPM.Ic)
                    xSPM.Ic             = find(strcmp({xCon.name}, [contrasts{nr_contrast}]));
                end
                if any(any(xCon(xSPM.Ic).c))
                    if numel(xSPM.Ic) > 1
                        xSPM.Ic = xSPM.Ic(1);
                    end
                    if ~isempty(xSPM.Ic)% && any(strcmp({SPM.xX.name}, [contrasts{nr_contrast} '_' num2str(nr_order)]))
                        xSPM.correction = 'none';
                        if iscell(contrasts)
                            xSPM.title      = [contrasts{nr_contrast} '_' num2str(nr_order)];
                        else
                            xSPM.title      = [xCon(xSPM.Ic).name];
                        end
                        
                        xSPM.u          = significance_level;
                        xSPM.k          = 0;
                        xSPM.Im         = [];
                        
                        xSPM.n          = nr_of_contrasts;
                        xSPM.thresDesc  = 'none';
                        
                        flags.mean=0;
                        flags.hold = 0;
                        flags.which=1;
                        flags.mask=0;
                        
                        num             = 1;
                        
                        for i = 1:num,
                            [~,VOL] = spm_getSPM(xSPM);
                            dat(i)    = struct(	'XYZ',	VOL.XYZ,...
                                't',	VOL.Z',...
                                'mat',	VOL.M,...
                                'dim',	VOL.DIM);
                            spm_write_filtered_no_ask(VOL.Z, VOL.XYZ, VOL.DIM, VOL.M, xSPM.title, [xSPM.title '.img']);
                        end
                    end
                end
            end            
            
        end
        nr_SPM = nr_SPM+1;
    end
end

cd(old_dir);

function PO = prepend(PI,pre)
[pth,nm,xt,vr] = fileparts(deblank(PI));
PO             = fullfile(pth,[pre nm xt vr]);
return;

%
%  if order > 1
%                 disp('Ain''t doing amplitude calculation');
%                 for nr_order = 1: order
%                     nrs = find(SPM.xCon(nr_beta(nr_order)).c);
%                     beta_base = [];
%                     for nr_regr = 1: length(nrs)
%                         str_nr_beta = num2str([zeros(1, 4 - length(num2str(nrs(nr_regr)))) nrs(nr_regr)]);
%                         str_nr_beta(str_nr_beta==' ') = [];
%                         beta_base   = [beta_base; 'beta_' str_nr_beta '.img'];
%                     end
%                     data(:, :, :, nr_order) = sum(spm_read_vols(spm_vol(beta_base)), 4);%([contrasts{nr_contrast} '_' num2str(nr_order) '.img']));
%                 end
%                 ResMS = spm_read_vols(spm_vol('ResMS.img'));
%                 std = sqrt(ResMS)/sqrt(SPM.nscan);
%                 amp = (sign(data(:, :, :, 1)) .* sqrt(sum(data.^2, 4)))./std;
%                 file = spm_vol(beta_base(1, :));
%                 file.fname = [contrasts{nr_contrast} '.img'];
%                 file = rmfield(file, 'pinfo');
%                 spm_write_vol(file, amp);
% %             else
% %                 eval(['!mv ' [contrasts{nr_contrast} '_' num2str(nr_order) '.img'] ' ' [contrasts{nr_contrast} '.img'] ]);
% %                 eval(['!mv ' [contrasts{nr_contrast} '_' num2str(nr_order) '.hdr'] ' ' [contrasts{nr_contrast} '.hdr'] ]);

%
%         else
%             SPM_dirs(nr_SPM) = [];
%             warning('Constrasts:NotForAllSubjects', ['The constrast ' contrasts{nr_contrast} ' is not specified for subject ' num2str(nr_SPM)]);
%         end