function descriptors = sc_compute(X,nbBins_theta, nbBins_r, smallest_r, biggest_r)
%SC_COMPUTE computes the shape context descriptors for a set of points
%   Input:
%       X - set of Points, size nx2
%       nbBins_theta - number of bins in the angular dimension
%       nbBins_r - number of bins in the radial dimension
%       smallest_r - length of the smallest radius
%       biggest_r - length of the biggest radius
%   Output:
%       shape_descriptors - shape descriptors

% initiaize output, each descriptor in its own cell
X = X';
num_points = size(X, 1);
descriptors = cell(num_points, 1);

% create bin boundaries for theta and r
bins_theta = linspace(-pi, pi, nbBins_theta + 1);
bins_r = [0, logspace(log10(smallest_r), log10(biggest_r), nbBins_r)];

% compute angles between points
theta_mat = zeros(num_points, num_points);
for i=1:num_points          % since theta_mat will be symmetric, 
    for j=(i+1):num_points    % we iterate only over the lower left triangle
        
        theta = atan2(X(j, 1)-X(i, 1), X(j, 2)-X(i, 2));
        theta_mat(i, j) = theta;
        
        % set upper right triangle as well by flipping indices
        if theta < 0
            theta_mat(j, i) = theta + pi;
        else
            theta_mat(j, i) = theta - pi;
        end
    end    
end

% compute normalized distances
dist_vec = pdist(X);
mean_dist = sum(dist_vec) / size(dist_vec,2);
dist_mat = squareform(dist_vec);
dist_mat_normalized = dist_mat / mean_dist;

% set descriptor
for i=1:num_points
    distances = dist_mat_normalized(i, :);
    indices = find(distances > 0); %only use distance to other points, not to the point itself
    descriptors{i} = histcounts2(distances(indices), theta_mat(i, indices), bins_r, bins_theta);
end

% visualize random descriptors for report
% figure(100)
% imshow(descriptors{1}, []);
% test = descriptors{1}
% figure(101)
% imshow(descriptors{100}, []);
% figure(102)
% imshow(descriptors{200}, []);
% figure(103)
% imshow(descriptors{300}, []);
% figure(104)
% imshow(descriptors{400}, []);
% figure(105)
% imshow(descriptors{150}, []);
% figure(106)
% imshow(descriptors{250}, []);
% figure(107)
% imshow(descriptors{350}, []);


end
