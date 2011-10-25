
% Creates a [4x4] matrix of a left affine transformation in the 3D space.
% Result matrix is a combination of three rotations around three axes and 
% three translations and is defined in homogeneous coordinates. 
% The order of the transformations done by this matrix is the following:
% 1. Rotation around X axis (anticlockwise).
% 2. Rotation around Y axis (anticlockwise).
% 3. Rotation around Z axis (anticlockwise).
% 4. Translation.
%
% Inputs.
%   rot_x:  Rotation angle around X axis in radians.
%   rot_y:  Rotation angle around Y axis in radians.
%   rot_z:  Rotation angle around Z axis in radians.
%   sh_x:   Translation by X axis.
%   sh_y:   Translation by Y axis.
%   sh_z:   Translation by Z axis.
%
% Outputs.
%   t:      [4x4] matrix, which [3x3] submatrix contains rotation matrix,
%           the last column contains translation vector.
%
% Example.
%   t = TransformationMatrix3D(pi/2, pi/2, pi/2, 10, 20, 30);
%   t * [1 0 0 1]' is [10 20 29 1]'.
%
% Copyright (c) 2011 Alena Bakulina <alena.bakulina@ziti.uni-heidelberg.de>
% All rights reserved.

function [t] = TransformationMatrix3D(rot_x, rot_y, rot_z, shx, shy, shz)
    
    tr_x = [1, 0,           0,          0;
            0, cos(rot_x), -sin(rot_x), 0;
            0, sin(rot_x),  cos(rot_x), 0;           
            0, 0,           0,          1];
       
    tr_y = [ cos(rot_y), 0, sin(rot_y), 0;
             0,          1, 0,          0;
            -sin(rot_y), 0, cos(rot_y), 0;
             0,          0, 0,          1];
          
    tr_z = [cos(rot_z), -sin(rot_z), 0, 0;
            sin(rot_z),  cos(rot_z), 0, 0;
            0,           0,          1, 0;
            0,           0,          0, 1];

    t_sh = [1, 0, 0, shx;
            0, 1, 0, shy;
            0, 0, 1, shz;
            0, 0, 0, 1];

    t = t_sh * tr_z * tr_y * tr_x;
    
% end GetTransformationMatrixFunction()
