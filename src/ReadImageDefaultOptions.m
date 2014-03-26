
% Provides default options structure for ReadImage() function.
%
% Outputs.
%   default_options:      A struct containing default image options. See ReadImage() for 
%                         structure overview and list of available fields.
%
% Copyright (c) 2014 Alexander Rukletsov <rukletsov@gmail.com>
% All rights reserved.

function default_options = ReadImageDefaultOptions()
  
  default_options = struct(...
    'format', 'std', ...
    'size', [512 512], ...
    'format_spec', 'uint16', ...
    'endianness', 'l', ...
    'normalize', false ...
  );
  
% end ReadImageDefaultOptions()
