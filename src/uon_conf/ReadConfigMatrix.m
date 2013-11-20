% Read a transformation matrix from a .conf file in UON format.
%
% Inputs.
%   filename:    Path to a .conf file.
%
% Outputs.
%   transform:   [4 x 4] matrix of an affine transformation.
%                Is a zero matrix if file not found or an error occurs.
%
% Example.
%   File should contains rows of the following format:
%     ...
%     ImageTransform.Rot.x	= [0.999168 0.026478 -0.031013]
%     ImageTransform.Rot.y	= [-0.026749 0.999608 -0.008308]
%     ImageTransform.Rot.z	= [0.030781 0.009131 0.999484]
%     ImageTransform.Trans	= [-52.713451 -25.515961 -95.256989]   
%
% Copyright (c) 2013 Lena Bakulina <lena.bakulina@gmail.com>
% All rights reserved.

function m = ReadConfigMatrix(filename)
  m = zeros(4,4);
  
  fid = fopen(filename, 'r');
  if (fid ~= -1)
    m(4,4) = 1;                 % homogeneous coordinates
    line = fgets(fid); 

    delimiter = ['[ =]' char(9)];
    % Scan file to the end
    while (line ~= -1)
      rem = line;
      i = 0;
      j = 0;

      % Find only rows where matrix transformations are written
      while (strcmp(rem, '') == 0)
        [token, rem] = strtok(rem, delimiter);
        j = j + 1;
        if ( strcmp(token, 'ImageTransform.Rot.x') == 1 )
          i = 1; 
        elseif ( strcmp(token, 'ImageTransform.Rot.y') == 1 )
          i = 2; 
        elseif ( strcmp(token, 'ImageTransform.Rot.z') == 1 )
          i = 3;
        elseif ( strcmp(token, 'ImageTransform.Trans') == 1 )
          i = 4;
        end

        % Set a column
        if (i > 0 && j > 1 && j <= 4)
          m(j-1, i) = str2num(token);
        end
      end

     % Get next line
     line = fgets(fid);
    end
    
    fclose(fid);
  end
%end

