function [map, peaks] = mean_shift(X, r)
% Inputs:
%   - X: discrete set of samples from a density function, size L x n (L:
%   number of total pixels in the image, n=3 for L*a*b value
%   - r: radius for spherical window in L*a*b space
% Outputs: 
%   - peaks: L*a*b peaks, size m x n (m: number of peaks, n=3 for L,a,b)
%   - map: maps data set pixels in X to their peak index in peaks, size L x
%   1

L = size(X,1);

% initialize loop variables
initialized = false;
peaks = [];
map = zeros(L,1);

for i=1:L
    
    text = ['Finding peak for pixel ',num2str(i),'/',num2str(L), '...'];
    fprintf(text);
    
    new_peak = find_peak(X, X(i,:), r);
    
    if initialized == false
        initialized = true;
        peaks = [peaks; new_peak];
        map(i) = size(peaks,1);
    else
        % find distances in L*a*b space from the new L*a*b peak to the
        % already found ones
        new_peak_matrix = repmat(new_peak, [size(peaks,1),1]);
        lab_distances = sqrt( sum( (peaks-new_peak_matrix).^2 ,2) );
        
        % find peaks that are too close to the new peak
        too_close_indices = find(lab_distances < (r/2));
        
        if isempty(too_close_indices) % if no peaks are found that are too close, add the new one
            peaks = [peaks; new_peak];
            map(i) = size(peaks,1);
        else % map pixel to the closest found peak that already exists
            [closest_distance, closest_index] = min(lab_distances);
            map(i) = closest_index;
        end
            
    end
    
end
end