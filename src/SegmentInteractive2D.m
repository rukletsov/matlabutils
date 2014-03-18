
% Segments image basing on provided contours and region brightness values.
%
% Inputs.
%   impath:       Path to the input file.
%   outpath:      Path to the output file.
%   extra_input:  Either a single integer (number of regions to segment), or a list 
%                 of reals (region brightness values). In the former case user will
%                 be prompted for region brightness after contour selection, in the 
%                 latter the values from the list will be used directly.
%
% Example.
%   SegmentInteractive2D('input-img.bmp', 'result-img.bmp', [0.5 0.7]) queries user
%   for two contours, sets the brightness of the region enclosed by the first contour 
%   to 0.5, by the second - to 0.7, and saves the result image.
%
% Copyright (c) 2014 Alexander Rukletsov <rukletsov@gmail.com>
% Copyright (c) 2010 Dirk-Jan Kroon 
% All rights reserved.

function SegmentInteractive2D(impath, outpath, extra_input)

  % Determine what we got as extra input: a single integer with the number of 
  % regions or a list of rational numbers with region brightness values.
  if ((length(extra_input) > 1) || (extra_input < 1))
    % extra_input is a list of brightness values
    have_values = true;
    regions_count = length(extra_input);
    cout('Region brightness values for ', regions_count, ' regions provided.');
  else
    % extra_input is a number of regions.
    have_values = false;
    regions_count = extra_input;
    cout('No region brightness values provided. ', regions_count, ' regions to segment.');
  end

  % Read input image and fill result image with background color.
  img = im2double(imread(impath));
  res_img = zeros(size(img));

  % Prepare figures for intermediate output.
  h1 = figure('Name', 'User selection and segmented image');
    subplot(1, 2, 1); imshow(img); hold on; title('Selected contours');
    subplot(1, 2, 2); imshow(res_img); hold on; title('Segmented image'); 
  
  % Loop through region intensities, extracting one region per value.
  for idx = 1 : regions_count

    % Get points selected by user.
    figure('Name', 'Region selection'); imshow(img);
    pts = choose_region;
    
    % Get region brightness from user if haven't got them as input.
    if (have_values)
      brightness = extra_input(idx);
    else
      brightness = str2double(inputdlg('Enter mean brightness for the region: ', 'SegmentInteractive2D'));
    end

    % Interpolate points inbetween.
    pts = smooth_contour_2d(pts);
    
    % Update part of result image with current intensity value using area selected by 
    % user as a mask.
    res_img(fill_contour_2d(pts, size(img))) = brightness;
    cout('Adding region with brightness ', brightness, '.');
    
    % Show current status.
    figure(h1)
      subplot(1, 2, 1); plot([pts(:,2);pts(1,2)],[pts(:,1);pts(1,1)], 'LineWidth', 2, 'Color', 'red');
      subplot(1, 2, 2); imshow(res_img);
  end
  
  % Save segmented image.
  if (~isempty(outpath))
    cout('Saving segmented image to ''', outpath, '''.');
    imwrite(res_img, outpath);
  end
  
% end SegmentInteractive2D()


  
% Queries user for points lying along the region boundary. Uses *active* figure.
function pts = choose_region
  [y, x] = getpts;
  close;
  pts = [x, y];
  
  
% Interpolates and smoothens a contour defined as a set of points. Requires at least 4
% points.
function smoothed = smooth_contour_2d(contour)
  P = contour;
  O(:,1)=interp([P(end-3:end,1);P(:,1);P(:,1);P(1:4,1)], 10);
  O(:,2)=interp([P(end-3:end,2);P(:,2);P(:,2);P(1:4,2)], 10);
  O=O(41:end-39,:);
  smoothed = O;
  

% Creates binary image out of the given contour. Note that contour points must fit into 
% the requested image size.
function filled_img = fill_contour_2d(contour, target_size)
  P = contour;
  Isize = target_size;
  J=false(Isize+2);
  x=round([P(:,1);P(1,1)]); x=min(max(x,1),Isize(1));
  y=round([P(:,2);P(1,2)]); y=min(max(y,1),Isize(2));
  % Loop through all line coordinates
  for i=1:(length(x)-1)
     % Calculate the pixels needed to construct a line of 1 pixel thickness
     % between two coordinates.
     xp=[x(i) x(i+1)]; yp=[y(i) y(i+1)]; 
     dx=abs(xp(2)-xp(1)); dy=abs(yp(2)-yp(1));
     if(dx==dy)
       if(xp(2)>xp(1)), xline=xp(1):xp(2); else xline=xp(1):-1:xp(2); end
       if(yp(2)>yp(1)), yline=yp(1):yp(2); else yline=yp(1):-1:yp(2); end
     elseif(dx>dy)
       if(xp(2)>xp(1)), xline=xp(1):xp(2); else xline=xp(1):-1:xp(2); end
       yline=linspace(yp(1),yp(2),length(xline));
     else
       if(yp(2)>yp(1)), yline=yp(1):yp(2); else yline=yp(1):-1:yp(2); end
       xline=linspace(xp(1),xp(2),length(yline));   
     end
     % Insert all pixels in the fill image
     J(round(xline+1)+(round(yline+1)-1)*size(J,1))=1;
  end
  
  % Mark the area defined by the contour with 1 and remove margins.
  J = bwfill(J,1,1);
  J=~J(2:end-1,2:end-1);
  
  filled_img = J;
