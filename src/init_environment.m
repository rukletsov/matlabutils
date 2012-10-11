
% Initializes some properties of MatLab environment. Supported properties:
%
% - DisableImShowBorder. Controls, whether imshow discludes a border around 
%     an image in the figure window. When the border is disabled, adjusts  
%     the figure size so that the image entirely fills the figure. Note:  
%     there can still be a border if the image is very small, or if there 
%     are other objects besides the image and its axes in the figure.
%     Values: ON (border disabled), OFF (border enabled).
%
% - CompactCoutFormat. Affects the spacing in the display of all variables. 
%     In a compact format suppresses excess line feeds to show more output 
%     in a single screen, otherwise adds extra linefeeds to the output.
%     Values: ON (compact format), OFF (loose format with extra spacing).
%
% Inputs.
%   imshow_border_off:       Default = true. Turns on (true) or off (false)
%                            the DisableImShowBorder property.
%   compact_cout_format_on:  Default = true. Turns on (true) or off (false)
%                            the CompactCoutFormat property.
%
% Copyright (c) 2012 Alena Bakulina <lena.bakulina@gmail.com>
% All rights reserved.

function init_environment(imshow_border_off, compact_cout_format_on)

  if (nargin < 1)
    imshow_border_off = true;
  end
  
  if (nargin < 2)
    compact_cout_format_on = true;
  end
  
	if (imshow_border_off == true)
    iptsetpref('ImshowBorder', 'tight');
  else
    iptsetpref('ImshowBorder', 'loose');
  end
  
  if (compact_cout_format_on == true)
    format compact;
  else
    format loose;
  end
  
% end init_environment()
