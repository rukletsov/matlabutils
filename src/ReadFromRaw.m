
% Reads the provided raw image. Assumes raw is a sequence of image
% intensities without any additional information.
%
% Inputs.
%   path:         Path to the input file.
%   size:         Dimensions of the input image.
%   format_spec:  Format of the input image. Can be one from
%                 {'uint8', 'uint16', 'uint32', 'uint64'}.
%   endianness:   Endianness of the raw formar. Can be either 'l' or 'b',
%                 which stands for little-endian and big-endian respectively.
%
% Outputs.
%   image:        2D or 3D array of doubles containing image intensities.
%
% Example.
%   ReadFromRaw('img512x512_uint16LE.raw', [512 512], 'uint16', 'l') reads a 
%   512 x 512, 16 bits per pixel, little-endian image into a double matrix.
%
% Copyright (c) 2013 Alexander Rukletsov <rukletsov@gmail.com>
% All rights reserved.

function image = ReadFromRaw(path, size, format_spec, endianness)

  fid = fopen(path, 'rb', endianness);
  pixelvals = fread(fid, inf, [format_spec, '=>double'], endianness);
  fclose(fid);
  
  image = reshape(pixelvals, size)';
  
% end ReadFromRaw()
