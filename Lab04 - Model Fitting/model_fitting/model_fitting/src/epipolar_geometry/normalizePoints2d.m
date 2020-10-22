% Normalization of 2d-pts
% Inputs: 
%           xs = 2d points
% Outputs:
%           nxs = normalized points
%           T = 3x3 normalization matrix
%               (s.t. nx=T*x when x is in homogenous coords)
function [nxs, T] = normalizePoints2d(xs)

%counting points
numOfPoints = size(xs,2);

%compute centroids
xs_centroid = [0;0];

for i=1:numOfPoints
    xs_centroid = xs_centroid + xs(1:2,i);
end

xs_centroid = xs_centroid / numOfPoints;

%shift the points to have the centroid at the origin
T1 = [1 0 -xs_centroid(1),
      0 1 -xs_centroid(2),
      0 0        1        ];

xs_shifted = T1*xs;

%compute scale
xs_sum = 0;

for i=1:numOfPoints
    xs_sum = xs_sum + sqrt( xs_shifted(1,i)^2 + xs_shifted(2,i)^2 );
end

xs_meanDist = xs_sum / numOfPoints;

T2 = 1/xs_meanDist;

%create T and U transformation matrices (similarity transformation)
T = T1*T2;
T(3,3) = 1;

% normalize the points according to the transformations
nxs = T*xs;

end
