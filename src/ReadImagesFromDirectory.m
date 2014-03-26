
% Returns the cell array of images (represented as matrices) from the provided directory.
%
% Inputs.
%   directory_name:       Use a name without a slash in the end. Both '/' and 
%                         '\' slashes in path are allowed.
%   img_name_pattern:     Specify the filename pattern, e.g 'image*.bmp'. At least
%                         specify an extension, e.g. img_name_pattern = '*.bmp'. If no
%                         second argument is passed or it is empty, all files are read.
%   options:              A struct with options defining image read algorithm and its
%                         parameters. See ReadImage() and ReadImageDefaultOptions() for 
%                         available options.
% 
% Outputs.
%   images:               Cell array of images matrices.
%   full_names:           Cell array of images full filepathes.
%   names:                Cell array of names of the files which are read.
% 
% Example.
%   opts = struct; opts.format = 'std';
%   ReadImagesFromDirectory('C:/Temp', 'image*.bmp', opts) returns a cell array of
%   all BMP images from directory 'C:/Temp' with names starting from 'image'.
%
% Copyright (c) 2014 Alexander Rukletsov <rukletsov@gmail.com>
% Copyright (c) 2013 Lena Bakulina <lena.bakulina@gmail.com>
% All rights reserved.

function [images, names, full_names] = ReadImagesFromDirectory(directory_name, ...
    img_name_pattern, options)

  % Use default options for image reading.
  if(~exist('options', 'var')), 
    options = ReadImageDefaultOptions();
  end
  
  % Get file names pattern.
  names_pattern = directory_name;
  if (nargin >= 2 && ~isempty(img_name_pattern))
      names_pattern = fullfile(directory_name, img_name_pattern);
  end

  % Read all files (file is a matlab structure containing name, etc.).
  files = dir(names_pattern);
  n = length(files);
  
  % Preallocate output cell arrays.
  images = cell(1, n);
  names = cell(1, n);
  full_names = cell(1, n);

  % Read each image.
  for (i = 1 : n)
    filename = fullfile(directory_name, files(i).name);
    images{i} = ReadImage(filename, options);
    names{i} = files(i).name;
    full_names{i} = filename;
  end
  
% end ReadImagesFromDirectory()
