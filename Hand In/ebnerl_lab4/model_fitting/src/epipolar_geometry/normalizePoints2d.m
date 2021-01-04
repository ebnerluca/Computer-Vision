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

% deviding by unit mean distance
%xs_sum = 0;
%for i=1:numOfPoints
    %xs_sum = xs_sum + sqrt( xs_shifted(1,i)^2 + xs_shifted(2,i)^2 );
%end
%xs_meanDist = xs_sum / numOfPoints;
%T2 = 1/xs_meanDist;

% deviding by standard deviation
stdx = std(xs_shifted(1,:));
stdy = std(xs_shifted(2,:));

%create T transformation matrix (similarity transformation)
%T = T1*T2; % unit mean distance method
%T(3,3) = 1;
T = [(T1(1,:)/stdx); %2D standard deviation method
     (T1(2,:)/stdy);
     (T1(3,:))       ];


% normalize the points according to the transformations
nxs = T*xs;

end
