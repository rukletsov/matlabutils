
% Saves the provided array as a raw image.
%
% Inputs.
%   image:        2D or 3D array containing image intensities.
%   path:         Path to the output file.
%   transp:       Whether transpose image before saving. Can be either true or
%                 false.
%   format_spec:  Format of the input image. Can be one from
%                 {'uint8', 'uint16', 'uint32', 'uint64'}.
%
% Example.
%   SaveToRaw(img, '128x128_8bpp.raw', true, 8) saves the provided matrix
%   into a 8-bit raw image, applying transpose operation first.
%
% Copyright (c) 2012, 2013 Alexander Rukletsov <rukletsov@gmail.com>
% All rights reserved.

function SaveToRaw(image, path, transp, format_spec)

  if (transp)
    image = image.';
  end 

  fid = fopen(path, 'w+');
  fwrite(fid, image, format_spec);
  fclose(fid);
  
% end SaveToRaw()
