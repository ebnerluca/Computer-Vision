% Compute the fundamental matrix using the eight point algorithm and RANSAC
% Input
%   x1, x2 	  Point correspondences 3xN
%   threshold     RANSAC threshold
%
% Output
%   best_inliers  Boolean inlier mask for the best model
%   best_F        Best fundamental matrix
%
function [best_inliers, best_F] = ransac8pF(x1, x2, threshold)

iter = 1000;

num_pts = size(x1, 2); % Total number of correspondences
best_num_inliers = 0; best_inliers = [];
best_F = 0;

for i=1:iter
    % Randomly select 8 points and estimate the fundamental matrix using these.
    
    % Compute the error.
    
    % Compute the inliers with errors smaller than the threshold.
        
    % Update the number of inliers and fitting model if the current model
    % is better.
end

end


