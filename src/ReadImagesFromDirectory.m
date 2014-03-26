
% Returns the cell array of images (represented as matrices) from the provided directory.
%
% Inputs.
%   directory_name:       Use a name without a slash in the end. Both '/' and 
%                         '\' slashes in path are allowed.
%   img_name_pattern:     Specify the filename pattern, e.g 'image*.bmp'. At least
%                         specify an extension, e.g. img_name_pattern = '*.bmp'. If no
%                         second argument is passed or it is empty, all files are read.
%   options:              A struct with options defining image read algorithm and its
%                         parameters. See below for available options.
% 
% Outputs.
%   images:               Cell array of images matrices.
%   full_names:           Cell array of images full filepathes.
%   names:                Cell array of names of the files which are read.
%
% Available options through 'options' struct.
%   options.format:       Format of image, 'std' or 'raw' are supported. Default is 'std'.
%   options.size:         Only for 'raw' images. Dimensions of the input image. 
%                         Default is [512 512].
%   options.format_spec:  Only for 'raw' images. Format of the input image. Can be one 
%                         from {'uint8', 'uint16', 'uint32', 'uint64'}. Default is
%                         'uint16'.
%   options.endianness:   Only for 'raw' images. Endianness of the raw formar. Can be 
%                         either 'l' or 'b', which stands for little-endian and 
%                         big-endian respectively. Default is 'l'.
%   options.normalize:    If true, image will be normalized, default is false.
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
    options = get_default_options();
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
    images{i} = read_image(filename, options);
    names{i} = files(i).name;
    full_names{i} = filename;
  end
  
% end ReadImagesFromDirectory()


function default_options = get_default_options()
  
  default_options = struct(...
    'format', 'std', ...
    'size', [512 512], ...
    'format_spec', 'uint16', ...
    'endianness', 'l', ...
    'normalize', false ...
  );
  
% end get_default_options()

  
function image = read_image(impath, options)

  % Process input options.
  default_options = get_default_options();
   
  if(~exist('options','var')), 
    options = default_options;
  else
    tags = fieldnames(default_options);
    for i = 1 : length(tags)
      if(~isfield(options, tags{i}))
        options.(tags{i}) = default_options.(tags{i});
      end
    end
    if(length(tags) ~= length(fieldnames(options))), 
      warning('ReadImagesFromDirectory:UnknownOption', 'Unknown options found.');
    end
  end
  
  % Depending on the image format, use either a built-in function or the custom one.
  % Normalize image if requested. Normalization differs for standard and RAW images.
  image = zeros(2, 2);
  switch (options.format)
    case 'std'
      image = imread(impath);
      if (options.normalize)
        image = im2double(image);
      end
      
    case 'raw'
      image = ReadFromRaw(impath, options.size, options.format_spec, options.endianness);
      if (options.normalize)
        image = NormalizeImage(image);
      end
    
    otherwise
      warning('ReadImagesFromDirectory:UnsupportedImageFormat', 'Unsupported image format.');
  end

% end read_image()
