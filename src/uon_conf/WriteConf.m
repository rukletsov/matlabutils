% Writes data to a .conf file of UON format.
%
% Inputs.
%   filename:    Path to a .conf file.
%   points2d:    [M x N] matrix, M >= 2, each column is a 2D point.
%   points3d:    [M x N] matrix, M >= 3, each column is a 3D point.
%   transform:   [4 x 4] matrix of an affine transformation.
%                Is a zero matrix if file not found or an error occurs.
%   scaling:     [1 x 2] array of X and Y image scaling coefficients.
%   other:       A string with other information which should be written
%                to the file end.
%
% Example.
%   Output file format:
%     contourPoint00012d      = [-0.794876 70.241135]
%     ...
%     contourPoint00013d      = [-0.794876 70.241135 0.443379]
%     ...
%     ImageTransform.Rot.x	= [0.999168 0.026478 -0.031013]
%     ImageTransform.Rot.y	= [-0.026749 0.999608 -0.008308]
%     ImageTransform.Rot.z	= [0.030781 0.009131 0.999484]
%     ImageTransform.Trans	= [-52.713451 -25.515961 -95.256989]   
%     ...
%     ImageScaling	        = [0.093000 0.093000]
%
% Copyright (c) 2013 Lena Bakulina <lena.bakulina@gmail.com>
% All rights reserved.

function write_conf(filename, points2d, points3d, transform, scaling, other)
 
  if (~exist('other', 'var'))
    other = '';
  end
  
  if (~exist('points2d', 'var'))
    points2d = [];
  end
  
  if (~exist('points3d', 'var'))
    points3d = [];
  end
  
  if (~exist('transform', 'var'))
    transform = [];
  end
  
  if (~exist('scaling', 'var'))
    scaling = [];
  end
  
  fin = fopen(filename, 'w');    
  if (fin ~= -1)
 
    % Write 2D points.
    [m, n] = size(points2d);
    if (m >= 2) % at least 2 coordinates given
      for (i = 1 : n)
        str = sprintf('contourPoint%04d2d\t= [%f %f]\n', i - 1, ...
          points2d(1, i), points2d(2, i));
        fwrite(fin, str);
      end
    end
    
    % Write 3D points.
    [m, n] = size(points3d);
    if (m >= 3) % at least 3 coordinates given
      for (i = 1 : n)
        str = sprintf('contourPoint%04d3d\t= [%f %f %f]\n', i - 1, ...
          points3d(1, i), points3d(2, i), points3d(3, i));
        fwrite(fin, str);
      end
    end
    
    % Write transformation matrix.
    [m, n] = size(transform);
    if (n == 4 && m == 4)
      str1 = sprintf('ImageTransform.Rot.x\t= [%f %f %f]\n', ...
        transform(1, 1), transform(2, 1), transform(3, 1));
      str2 = sprintf('ImageTransform.Rot.y\t= [%f %f %f]\n', ...
        transform(1, 2), transform(2, 2), transform(3, 2));
      str3 = sprintf('ImageTransform.Rot.z\t= [%f %f %f]\n', ...
        transform(1, 3), transform(2, 3), transform(3, 3));
      str4 = sprintf('ImageTransform.Trans\t= [%f %f %f]\n', ...
        transform(1, 4), transform(2, 4), transform(3, 4));

      fwrite(fin, str1);
      fwrite(fin, str2);
      fwrite(fin, str3);
      fwrite(fin, str4);
    end
       
    % Write scaling.
    n = length(scaling);
    if (n == 2)
      str = sprintf('ImageScaling\t= [%f %f]\n',  scaling(1), scaling(2));
      fwrite(fin, str);
    end
    
    % Write other data.
    fwrite(fin, sprintf('%s\n', other));
    
    fclose(fin);
  end
%end

