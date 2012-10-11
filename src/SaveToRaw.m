
% Saves the provided array into as a raw image.
%
% Inputs.
%   sigma:  Gaussian sigma.
%   type:   Indicates which derivative to take. Can be one from {'0', 'x',
%           'y', 'xx', 'xy', 'yy'}. Value '0' means standard gaussian, no
%           derivative is taken.
%   image:  2D or 3D array containing image data.
%   path:   Path to the output file.
%   transp: Whether transpose image before saving. Can be either true or
%           false.
%   bpp:    Specifies the colour depth of the raw image. Can be one from
%           {8, 16, 32, 64}.
%
% Example.
%   SaveToRaw(img, '128x128_8bpp.raw', true, 8) saves the provided matrix
%   into a 8-bit raw image, applying transpose operation first.
%
% Copyright (c) 2012 Alexander Rukletsov <rukletsov@gmail.com>
% All rights reserved.

function SaveToRaw(image, path, transp, bpp)

  if (transp)
    image = image.';
  end
  
  format_spec = '';
  switch bpp
  case 8
    format_spec = 'uint8';
  case 16
    format_spec = 'uint16';
  case 32
    format_spec = 'uint32';
  case 64
    format_spec = 'uint64';
  otherwise
    cout('Specified bpp is not supported.');
  end  

  fid = fopen(path, 'w+');
  fwrite(fid, image, format_spec);
  fclose(fid);
  
% end SaveToRaw()
