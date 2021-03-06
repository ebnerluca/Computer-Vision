%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn
% xy_normalized: 3xn
% XYZ_normalized: 4xn
% T: 3x3
% U: 4x4

function [xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)
%data normalization

%counting rows and columns of stored point pairs
[xy_rows, xy_columns] = size(xy);
numOfPoints = xy_columns;

%modify points to make them homogenous
xy = [xy; ones(1, numOfPoints)];
XYZ = [XYZ; ones(1, numOfPoints)];

% TODO 1. compute centroids
xy_centroid = [0;0];
XYZ_centroid = [0;0;0];

for i=1:numOfPoints
    xy_centroid = xy_centroid + xy(1:2,i);
    XYZ_centroid = XYZ_centroid + XYZ(1:3, i);
end

xy_centroid = xy_centroid / numOfPoints;
XYZ_centroid = XYZ_centroid / numOfPoints;

% TODO 2. shift the points to have the centroid at the origin
T1 = [1 0 -xy_centroid(1),
      0 1 -xy_centroid(2),
      0 0        1        ];
U1 = [1 0 0  -XYZ_centroid(1),
      0 1 0  -XYZ_centroid(2),
      0 0 1  -XYZ_centroid(3),
      0 0 0          1        ];
  
xy_shifted = T1*xy;
XYZ_shifted = U1*XYZ;

% TODO 3. compute scale
xy_sum = 0;
XYZ_sum = 0;

for i=1:numOfPoints
    xy_sum = xy_sum + sqrt( xy_shifted(1,i)^2 + xy_shifted(2,i)^2 );
    XYZ_sum = XYZ_sum + sqrt( XYZ_shifted(1,i)^2 + XYZ_shifted(2,i)^2 + XYZ_shifted(3,i)^2 );
end

xy_meanDist = xy_sum / numOfPoints;
XYZ_meanDist = XYZ_sum / numOfPoints;

T2 = 1/xy_meanDist;
U2 = 1/XYZ_meanDist; 

% TODO 4. create T and U transformation matrices (similarity
% transformation)
T = T1*T2;
T(3,3) = 1;
U = U1*U2;
U(4,4) = 1;

% TODO 5. normalize the points according to the transformations

xy_normalized = T*xy;
XYZ_normalized = U*XYZ;

end