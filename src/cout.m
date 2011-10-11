
function cout(varargin)

str = '';

for i = 1 : size(varargin, 2)
    val = varargin{i};
    
    if (ischar(val))
        str = [str val];
    else
        str = [str num2str(val)];
    end
end

disp(str);
