
% Generates an array of random values uniformly distributed on an interval
% [-max, max].
%
% Inputs.
%   size: Size of the vector.
%   max_value: Values will lie between -max_value amd max_value.
%
% Outputs.
%   values: [1 x N] array of numbers.
%
% Example.
%   random_array(10, 3) returns [v1 v2 ... vi ... v10], -3 <= vi <= 3.
%
%  Copyright (c) 2011 Alena Bakulina <alena.bakulina@ziti.uni-heidelberg.de>
%  All rights reserved.

function [values] = random_array(size, max_value)

  values = rand([1 size]);      % Generate random values from 0 to 1.
  values = values - 0.5;        % Make values being from -0.5 to 0.5.
  values = values * 2;          % Make values being from -1 to 1.
  values = values * max_value;  % Make values being from -max_value to max_value.   
  
% end random_array()
