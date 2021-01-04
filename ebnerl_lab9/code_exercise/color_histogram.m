function hist = color_histogram(xMin, yMin, xMax, yMax, frame, hist_bin)
%   COLOR_HISTOGRAM calculates the normalized histogram of RGB colors occurring
%   within the bounding box defined by [xMin, xMax] x [yMin, yMax] within the current
%   video frame


% make sure bounding boxes are valid (corners are integers and do not
% exceed frame
xMin = round( max(1,xMin) );
yMin = round( max(1,yMin) );
xMax = round( min(xMax,size(frame,2)) );
yMax = round( min(yMax,size(frame,1)) );

% initialize histogram
hist = zeros(3,hist_bin);
bin_boundaries = linspace(0, 256, hist_bin+1);

% cut out box frame
box_frame = frame(yMin:yMax, xMin:xMax, :);

for channel=1:3
    
    % count histogram
    [count, ~] = histcounts(box_frame(:,:,channel), bin_boundaries);
    
    %normalize  histogram
    hist(channel,:) = count/sum(count);
    
end


end

