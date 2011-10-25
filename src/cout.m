% Prints passed argument list to a MATLAB console. For more information on
% supported types and implementation details, see str() function.
function cout(varargin)

  disp(str(varargin{:}));

% end cout()