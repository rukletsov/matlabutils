
% Prints passed argument list to a MATLAB console. For more information on
% supported types and implementation details, see str() function.
%
% Copyright (c) 2011 Alexander Rukletsov <rukletsov@gmail.com>
% All rights reserved.

function cout(varargin)

  disp(str(varargin{:}));

% end cout()
