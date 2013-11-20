% Read data from a .conf file of UON format.
%
% Inputs.
%   filename:    Path to a .conf file.
%
% Outputs.
%   points2d:    [2 x N] matrix, each column is a 2D point.
%   points3d:    [3 x N] matrix, each column is a 3D point.
%   transform:   [4 x 4] matrix of an affine transformation.
%                Is a zero matrix if file not found or an error occurs.
%   scaling:     [1 x 2] array of X and Y image scaling coefficients. 
%
% Example.
%   File should contains rows of the following format:
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

function [points2d, points3d, transform, scaling] = read_conf(filename)
  transform = ReadConfigMatrix(filename);
  points2d = [];
  points3d = [];
  scaling = [];
  
  fin = fopen(filename, 'r');    
  if (fin ~= -1)
    str = fgetl(fin);    
    while (ischar(str))
      mode = sscanf(str, 'contourPoint %*4c %d');
      
      if (~isempty(mode))
        % Read 2D or 3D points.
        switch mode
          case 2
            points2d = [points2d, sscanf(str, 'contourPoint %*4c 2d\t= [ %f %f ]')];
          case 3
            points3d = [points3d, sscanf(str, 'contourPoint %*4c 3d\t= [ %f %f %f ]')];
        end
      end  
      
      % Read scaling.
      [tmp, count] = sscanf(str, 'ImageScaling\t= [ %f %f ]');
      if (count == 2)
        scaling = [tmp(1) tmp(2)];
      end;
      
      str = fgetl(fin);
    end
    
    fclose(fin);
  end
%end

