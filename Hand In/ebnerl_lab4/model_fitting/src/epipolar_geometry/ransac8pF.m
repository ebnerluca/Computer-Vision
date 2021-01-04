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

%simple RANSAC
iter = 1000; 

%adaptive RANSAC
m = 0;
M = iter;
p = 0.99;

sampleSize = 8; %sampleSize >= 8

num_pts = size(x1, 2); % Total number of correspondences
best_num_inliers = 0; best_inliers = [];
best_F = 0;

%for i=1:iter
while(m<M)
    % Randomly select 8 points and estimate the fundamental matrix using these.
    rand_indices = randsample(num_pts, sampleSize);
    x1s = x1(:, rand_indices);
    x2s = x2(:, rand_indices);
    [Fh, F] = fundamentalMatrix(x1s, x2s);
    
    % Compute the error.
    distances1 = distPointsLines(x2, Fh*x1);
    distances2 = distPointsLines(x1, Fh'*x2);
    error = (distances1 + distances2) / 2;
    
    % Compute the inliers with errors smaller than the threshold.
    inlier_indices = [];
    inlier_indices = find(error < threshold);
    num_inliers = numel(inlier_indices);
        
    % Update the number of inliers and fitting model if the current model
    % is better.
    if num_inliers > best_num_inliers
        best_num_inliers = num_inliers;
        best_F = Fh;
        best_inliers = [];
        best_inliers = inlier_indices';
        
        %adaptive RANSAC
        r = best_num_inliers/num_pts;
        M = abs(round(log(1-p)/log(1-r^sampleSize)));
    end
    
    %adaptive RANSAC
    m = m+1; 
    
end

% nice outputs
%inliers_distances1 = distPointsLines(x2(:,best_inliers), best_F*x1(:,best_inliers));
%inliers_distances2 = distPointsLines(x1(:,best_inliers), best_F'*x2(:,best_inliers));
%inliers_error = (inliers_distances1 + inliers_distances2) / 2;
%mean_inliers_error = sum(inliers_error)/size(inliers_error,2)
%total_inlier_count = best_num_inliers
%M = M
%m = m

end


