%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy_normalized: 3xn
% XYZ_normalized: 4xn

function f = fminGoldStandard(pn, xy_normalized, XYZ_normalized)

%reassemble P
P = [pn(1:4);pn(5:8);pn(9:12)];

% TODO compute reprojection errors
numOfPoints = size(xy_normalized, 2);

xy_normalized_reprojected = P*XYZ_normalized;
for i=1:numOfPoints %normalize
    xy_normalized_reprojected(:,i) = xy_normalized_reprojected(:,i) / xy_normalized_reprojected(3,i);
end

diff = xy_normalized_reprojected - xy_normalized;

% TODO compute cost function value
error = 0;
for i=1:numOfPoints
    error = error + norm(diff(1:2,i));
end
 f=error;
 
end