
% Reads requested image using specified image parameters, such as type or size.
%
% Inputs.
%   impath:               Path to the input file.
%   options:              A struct with options defining image read algorithm and its
%                         parameters. See below for available options and also 
%                         ReadImageDefaultOptions().
%
% Outputs.
%   image:                Depending on specified parameters, can be a 2D or 3D array of
%                         doubles or ints.
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
%   options.normalize:    If true, image will be normalized to [0..1], default is false.
% 
% Example.
%   % This will return a 2D (or 3D in case of color image) array of ints.
%   opts = struct; 
%   opts.format = 'std';
%   img1 = ReadImage('~/test/img01.bmp', opts);
%
%   % This will return a 2D normalized image from a 16-bit LE RAW file.
%   opts = struct;
%   opts.format = 'raw';
%   opts.size = [512 512];
%   opts.format_spec = 'uint16';
%   opts.endianness = 'l';
%   opts.normalize = true;
%   img2 = ReadImage('~/test/img02.raw', opts);
%
% Copyright (c) 2014 Alexander Rukletsov <rukletsov@gmail.com>
% All rights reserved.

function image = ReadImage(impath, options)

  % Process input options.
  default_options = ReadImageDefaultOptions();
   
  if (~exist('options','var'))
    options = default_options;
  else
    tags = fieldnames(default_options);
    for i = 1 : length(tags)
      if (~isfield(options, tags{i}))
        options.(tags{i}) = default_options.(tags{i});
      end
    end
    if (length(tags) ~= length(fieldnames(options)))
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

% end ReadImage()
