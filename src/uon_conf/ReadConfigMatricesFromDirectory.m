% Read .conf files in UON format from a specified diretory and store transformation
% matrices and scalings from them to a cell array. Each .conf is read for a
% correspondent image, which name is an input.
% All configs shoul have the same name pattern:
%  'somewordsomenumber.conf'
% All correspondent images also have names like:
%  'someanotherwordsomenumber.bmp'
% 
% Inputs:
%   directory_name
%   image_names:    A cell array of image names (names only, not paths) for
%                   which a config should be read.
%   img_name_part:  This word is substitutes by conf_name_part and the
%                   result is the name of the .conf file correspondent to 
%                   the image. It is 'someanotherword' in the example above.
%   conf_name_part: It is 'someword' in the example above.
%   img_extension:  Image extension string without a dot, e.g. 'bmp'.
% 
% Outputs:
%   matrices:     A cell array of [4 x 4] transformation matrices.
%   scalings:     [2 x N] array, each column is a scaling from one config.
%
% Copyright (c) 2013 Lena Bakulina <lena.bakulina@gmail.com>
% All rights reserved.

function [matrices, scalings] = ReadConfigMatricesFromDirectory(...
  directory_name, image_names, img_name_part, conf_name_part, img_extension)
    
  n = length(image_names);
  matrices = cell(1, n);
  scalings = zeros(2, n);

  % For each image name get correspondent config filename and read .conf
  for (i = 1 : n)
      config_filename = strrep(image_names{i}, img_name_part, conf_name_part); 
      config_filename = strrep(config_filename, img_extension, 'conf'); 
      config_filepath = fullfile(directory_name, config_filename);
      
      [tmp1, tmp2, matrices{i}, scaling] = ReadConf(config_filepath);
      if (length(scaling == 2))
        scalings(:, i) = scaling;
      end
  end    
% end ReadConfigMatricesFromDirectory()

