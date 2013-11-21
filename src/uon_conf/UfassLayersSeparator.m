% Separates points from UFASS's scans into layers based on the Z coordinate of each scan.
% Scan's Z coordinate is defined by the UFASS's height position (tranlation) in the .conf
% file. The .conf file must have the structure supported by 'ReadConfigMatrix.m' function.
%
% Copyright (c) 2013 Lena Bakulina <lena.bakulina@gmail.com>
% All rights reserved.

function UfassLayersSeparator()
  % Add path to the 'MatlabUtils' folder and it's 'uon_conf' subfolder hier:
  addpath('path-to-MatlabUtils-lib');
  addpath('path-to-MatlabUtils-lib-uon_conf');
  
  input_dir_name = 'input';
  output_dir_name = 'output';
  
  % Read images and correspondent .conf files. Tranformation matrices from .conf will
  % be stored in 'matrices'.
  img_name_pattern = 'image*.bmp';
  [images, img_names] = ReadImagesFromDirectory(input_dir_name, img_name_pattern);
  [matrices, scalings] = ReadConfigMatricesFromDirectory(...
      input_dir_name, img_names, 'image', 'image', 'bmp');
   
  % UFASS's calibration matrix. 
  ufass_conf = ReadConfigMatrix(fullfile(input_dir_name, 'ufassH.conf'));
    
  n = length(images);
  
  % Detect unique UFASS's height (Z coordinates) from .conf files (is the third value)
  % in 'ImageTransform.Trans' property.
  zs = zeros(1, n);
  for (ind = 1 : n)
    z = matrices{ind}(3, 4);
    zs(ind) = z;
  end
  z_unique = unique(zs);
  
  % Map a unique index from 1 to the 'layers_count' to each unique Z.
  layers_count = length(z_unique);
  layers_map = containers.Map(z_unique, 1 : layers_count);
  
  all_points_w = [];
  layers = cell(1, layers_count);
  for (ind = 1 : n)
    % Detect contour points from images here:
    pp = find(images{ind} == 255);
    
    % Get (x, y) coordinates of that points, use 'scalings' to translate the image 
    % coordinates to the real world coordinates.
    [i, j] = ind2sub(size(images{ind}), pp);
    y = (i - 1) * scalings(1, ind); % use 'i - 1' to start indexing X & Y from 0
    x = (j - 1) * scalings(2, ind);
    
    l = length(x);
    p_t = [x(:)'; y(:)'; zeros(1, l); ones(1, l)]; % p_t are points in transducer's coordinates   
    p_w = matrices{ind} * ufass_conf * p_t; % p_w are poins in target common coordinates 
    all_points_w = [all_points_w p_w];
    
    % Store the points to a correspondent level according to it's Z coordinate.
    z = matrices{ind}(3, 4);
    layer_no = layers_map(z);
    layers{layer_no} = [layers{layer_no} p_w];
  end
  
  if (~isdir(output_dir_name))
    mkdir(output_dir_name);
  end
  
  % Output by layers.
  for (ind = 1 : layers_count)
    % Set a break on this line to see step-by-step how the layers are built.
    plot3(layers{ind}(1, :), layers{ind}(2, :), layers{ind}(3, :), 'r.', 'MarkerSize', 1), ... 
      axis equal, grid on, hold on;
    
    WritePly(fullfile(output_dir_name, sprintf('%04d.ply', ind)), layers{ind}(1 : 3, :));
  end
  
  % Output all points together.
  WritePly(fullfile(output_dir_name, '~all.ply'), all_points_w(1 : 3, :));
%end

% 'points' must be a [3 x N] or a [N x 3] matrix
function WritePly(file_path, points)
  fin = fopen(file_path, 'w');
  
  if (fin ~= -1)    
    % Write header.
    str = sprintf('%s\n%s\n%s %d\n%s\n%s\n%s\n%s\n%s\n%s\n', ...
                  'ply', ...
                  'format ascii 1.0', ...
                  'element vertex', length(points), ...
                  'property float x', ...
                  'property float y', ...
                  'property float z', ...
                  'element face 0', ...
                  'property list uchar uint vertex_indices', ...
                  'end_header' ...
                  );
    fwrite(fin, str);
    
    % Write points.
    [m, n] = size(points);
    if (m == 3 || n == 3)
      if (n == 3) 
        points = points'; % transpose the matrix
        n = m;
      end
      
      for (i = 1 : n)
        str = sprintf('%f %f %f\n', points(1, i), points(2, i), points(3, i));
        fwrite(fin, str);
      end      
    else
      cout('WritePly error: points array must be a [3 x N] or a [N x 3] matrix.');
    end
    
    fclose(fin);
  else
    cout('WritePly error: file can not be opened for writing.');
  end
%end
