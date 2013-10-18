
% Normalizes the provided image to [0..1] based on the maximal brightness value.
% Use this instead of im2double() if the actual color depth is lower than
% maximal value of the storage type, e.g. fir medical raw images.
%
% Inputs.
%   image:       2D or 3D array containing image intensities.
%
% Outputs.
%   normalized:  Array with intensities normalized to [0..1].
%
% Copyright (c) 2013 Alexander Rukletsov <rukletsov@gmail.com>
% All rights reserved.

function normalized = NormalizeImage(image)

  maxval = max(image(:));
  normalized = image ./ maxval;
  
% end ReadFromRaw()
