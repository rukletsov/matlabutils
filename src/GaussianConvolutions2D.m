
% Convolves given image using one of the gaussian kernels. See notes on
% GaussianKernels2D() function for more information about available
% kernels.
%
% Inputs.
%   I:      Input image (discrete brightness function).
%   sigma:  Gaussian sigma.
%   type:   Indicates which derivative to take. Can be one from {'0', 'x',
%           'y', 'xx', 'xy', 'yy'}. Value '0' means standard gaussian, no
%           derivative is taken.
%
% Outputs.
%   J:      Convolved image of type double.
%
% Copyright (c) 2011 Alexander Rukletsov <rukletsov@gmail.com>
% All rights reserved.

function J = GaussianConvolutions2D(I, sigma, type)

  % Get appropriate kernel.
  kernel = GaussianKernels2D(sigma, type);
  J = imfilter(double(I), kernel, 'conv', 'symmetric');

% end GaussianConvolutions2D()
