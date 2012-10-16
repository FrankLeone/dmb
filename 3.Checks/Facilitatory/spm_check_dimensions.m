function sts = spm_check_dimensions(V)
% Check the dimensions and orientations of the images
% FORMAT sts = spm_check_orientations(V)
%
% V    - a struct array as returned by spm_vol
% sts  - status (true means OK)
%
% When used without LHS, this function throws an error accordingly.
%__________________________________________________________________________
% Copyright (C) 2005-2011 Wellcome Trust Centre for Neuroimaging

% John Ashburner
% $Id: spm_check_orientations.m 4199 2011-02-10 20:07:17Z guillaume $

sts = true;

if numel(V) <= 1 || isa(V,'gifti'), return; end

dims = cat(1,V.dim);
if any(any(diff(dims,1,1),1))
    sts = false;
    fprintf('\n    ** The images do not all have the same dimensions. **\n');
    fprintf('The function assumes that a voxel in one image corresponds with\n');
    fprintf('the same  voxel in another.   This  is not a safe assumption if\n');
    fprintf('the  image dimensions differ.   Please  ensure  that  you  have\n');
    fprintf('processed all the image data in the same way (eg. check spatial\n');
    fprintf('normalisation bounding-boxes, voxel-sizes etc).\n');
    fprintf('Here are the dimensions of the image volumes.  This list can be\n');
    fprintf('used to determine which file(s) are causing the problem.\n\n');
    for i=1:numel(V)
        fprintf('[%d %d %d]  %s\n',V(i).dim, V(i).fname);
    end
    fprintf('\n');
    if ~nargout, error('The dimensions must be identical for this procedure.'); end
end
