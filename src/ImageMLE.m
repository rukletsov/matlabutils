
% Performs Maximum Likelihood segmentation for a given image and classes' mean values.
%
% Inputs.
%   img:          Input image.
%   mus:          List of mean brightness values representing different classes.
%
% Outputs.
%   result:       Segmented image.
%
% Example.
%   ImageMLE(img, [0, 0.5]) assignes each pixel of the provided image ether 0 or 0.5, 
%   depending which is closer to the original pixel value,
%
% Copyright (c) 2014 Alexander Rukletsov <rukletsov@gmail.com>
% All rights reserved.

function result = ImageMLE(img, mus)

  % Cache global parameters.
  N = numel(img);
  result = zeros(size(img));  

  % Obtain initial state using only likelihood term.
  for pixel_idx = 1 : N
    [~, min_idx] = min(abs(mus - img(pixel_idx)));
    result(pixel_idx) = mus(min_idx);
  end
  
% end ImageMLE()
