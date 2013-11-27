
% Clamps an argument (scalar, matrix, or cell array) to values in the range [a, b].
% For non-scalars the operation is element-wise.
%
% Inputs.
%   arg:          A scalar, matrix or cell array to clamp.
%   a:            Left endpoint of the clamping range.
%   b:            Right endpoint of the clamping range.
%
% Outputs.
%   clamped:      Argument clamped to the range [a, b] element-wise.
%
% Example.
%   Clamp([1 10 -2], -1, 1) produces [1, 1, -1].
%
% Copyright (c) 2013 Alexander Rukletsov <rukletsov@gmail.com>
% All rights reserved.

function clamped = Clamp(arg, a, b)

if iscell(arg)
  clamped = cell(size(arg));
  for i = 1 : length(arg)
    clamped{i} = clamp(arg{i}, a, b);
  end
else
  clamped = max(min(arg, b), a);
end

% end Clamp()
