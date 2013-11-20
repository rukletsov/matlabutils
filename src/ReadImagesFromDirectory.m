% Returns the cell array of images (represented as matrices).
%
% Inputs:
%   directory_name. Use a name without a slash in the end. Both '/' and 
%     '\' slashes in path are allowed.
%   img_name_pattern. Specify the filename pattern, e.g 'image*.bmp'.
%     At least specify an extension, e.g. img_name_pattern = '*.bmp'.
%     If no second argument is passed or it is empty all files are read.    
% 
% Outputs:
%   images. Cell array of images matrices.
%   full_names. Cell array of images full filepathes.
%   names. Cell array of names of the files which are read.
% 
% Example:
% ReadImagesFromDirectory('C:/Temp', 'image*.bmp') returns a cell array of
% all BMP images from directory 'C:/Temp' with names starting from 'image'.
%
% Copyright (c) 2013 Lena Bakulina <lena.bakulina@gmail.com>
% All rights reserved.

function [images, names, full_names] = ReadImagesFromDirectory(directory_name, img_name_pattern)
  images = {};
  names = {};
  full_names = {};

  % Get file names pattern
  names_pattern = directory_name;
  if (nargin >= 2 && ~isempty(img_name_pattern))
      names_pattern = fullfile(directory_name, img_name_pattern);
  end

  % Read all files (file is a matlab structure containing name, etc.)
  files = dir(names_pattern);
  n = length(files);

  % Read each image
  for (i = 1 : n)
    filename = fullfile(directory_name, files(i).name);
    images{i} = imread(filename);
    names{i} = files(i).name;
    full_names{i} = filename;
  end
%end

