% Converts and concatenates to a single string passed arguments. Supports
% arbitrary quantity of arguments. The argument is supposed to be either a
% string (char) or a number. Other (incl. custom) types are not supported.
function [string] = str(varargin)

  string = '';

  for (i = 1 : size(varargin, 2))
    val = varargin{i};

    if (ischar(val))
      string = [string val];
    else
      string = [string num2str(val)];
    end
  end
  
% end str()
