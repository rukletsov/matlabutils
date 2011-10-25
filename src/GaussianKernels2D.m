
% Generates a [3*sigma, 3*sigma] gaussian kernel up to second derivative.
%
% Inputs.
%   sigma:  Gaussian sigma.
%   type:   Indicates which derivative to take. Can be one from {'0', 'x',
%           'y', 'xx', 'xy', 'yy'}. Value '0' means standard gaussian, no
%           derivative is taken.
% Outputs.
%   Ker:    Requested kernel.
%
% Example.
%   GaussianKernels2D(1, 'x') returns 7x7 matrix with coefficients
%   according to first-order derivative of gaussian.
%
% Copyright (c) 2011 Alexander Rukletsov <rukletsov@gmail.com>
% All rights reserved.

function Ker = GaussianKernels2D(sigma, type)

  % Compute kernels in x and y directions. Note that ndgrid() function has 
  % non-intuitive behaviour. The size of kernel is 3*sigma (see 3-sigma
  % rule).
  [x,y] = ndgrid(floor(-3*sigma):ceil(3*sigma), floor(-3*sigma):ceil(3*sigma));

  % Determine which derivative kernel to compute. Note: sqrt(2*pi) ~ 2.5.
  switch(type)
    case {'0', '00'}
      Ker =  (1  / (2.5*sigma))                 * exp(-(x.^2 + y.^2) / (2*sigma^2));
    case 'x'
      Ker = -(x ./ (2.5*sigma^3))              .* exp(-(x.^2 + y.^2) / (2*sigma^2));
    case 'y'
      Ker = -(y ./ (2.5*sigma^3))              .* exp(-(x.^2 + y.^2) / (2*sigma^2));
    case 'xx'
      Ker = ((x.^2 - sigma^2) / (2.5*sigma^5)) .* exp(-(x.^2 + y.^2) / (2*sigma^2));
    case {'xy','yx'}
      Ker = ((x .* y) / (2.5*sigma^5))         .* exp(-(x.^2 + y.^2) / (2*sigma^2));
    case 'yy'
      Ker = ((y.^2 - sigma^2) / (2.5*sigma^5)) .* exp(-(x.^2 + y.^2) / (2*sigma^2));
  end

  %Ker = imfilter(I,DGauss,'conv','symmetric');

% end GaussianKernels2D()
