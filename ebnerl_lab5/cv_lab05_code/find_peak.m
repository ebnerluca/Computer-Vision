function peak = find_peak(X, xl, r)

% Inputs:
%   - X: discrete set of samples from a density function, size L x n (L:
%   number of total pixels in the image, n=3 for L*a*b value
%   - xl: starting pixel, size 1xn
%   - r: radius for spherical window in L*a*b space
% Outputs:
%   - peak 

L = size(X,1);

% initialize loop variables
current_peak = xl;
threshold = 2; % set to ~5 for debugging, speeds up computation significantly 
shift_distance = Inf;

while shift_distance > threshold
    
    % find distances in L*a*b space from the pixels to the current lab peak
    current_peak_matrix = repmat(current_peak, [L,1]);
    lab_distances = sqrt( sum( (X-current_peak_matrix).^2 ,2) );
    
    % find spherical window around current lab peak in L*a*b space
    window = X(lab_distances < r,:);
    
    % find new lab peak
    new_peak = mean(window,1); %average of the L*a*b values in the window
    
    % distance shift in L*a*b space
    shift_distance = norm(new_peak - current_peak);
    
    % reset for next loop
    current_peak = new_peak;
    
end

peak = new_peak;

end