function [best_k, best_b] = ransacLine(data, iter, threshold)
% data: a 2xn dataset with n data points
% iter: the number of iterations
% threshold: the threshold of the distances between points and the fitting line

num_pts = size(data, 2); % Total number of points
best_num_inliers = 0;   % Best fitting line with largest number of inliers
best_k = 0; best_b = 0;     % parameters for best fitting line


for i=1:iter
    % Randomly select 2 points and fit line to these
    % Tip: Matlab command randperm / randsample is useful here
    rand_indices = randsample(num_pts, 2);
    pt1 = data(:, rand_indices(1));
    pt2 = data(:, rand_indices(2));

    % Model is y = k*x + b. You can ignore vertical lines for the purpose
    % of simplicity.
    line_coeff = polyfit( [pt1(1), pt2(1)], [pt1(2), pt2(2)], 1);
    k = line_coeff(1);
    b = line_coeff(2);
    
    % Compute the distances between all points with the fitting line
    distances = abs(-data(2,:)+k*data(1,:)+b) / (sqrt(1+k*k)); %common formula
        
    % Compute the inliers with distances smaller than the threshold
    inlier_indices = find(distances < threshold);
    num_inliers = numel(inlier_indices);
    
    % Update the number of inliers and fitting model if the current model
    % is better.
    if(num_inliers > best_num_inliers)
        best_num_inliers = num_inliers;
        best_k = k;
        best_b = b;
    end
end


end
