%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runGoldStandard(xy, XYZ)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT with normalized coordinates
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error to refine P_normalized
% TODO fill the gaps in fminGoldstandard.m
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized);
end

% TODO: denormalize projection matrix
P_normalized = [pn(1:4);pn(5:8);pn(9:12)];
P = inv(T)*P_normalized*U;

%factorize prokection matrix into K, R and t
[K, R, t] = decompose(P);

% TODO compute average reprojection error
numOfPoints = size(xy, 2);
XYZ = [XYZ; ones(1, numOfPoints)];
xy = [xy; ones(1, numOfPoints)];

xy_reprojected = P*XYZ;
for i=1:numOfPoints %normalize
    xy_reprojected(:,i) = xy_reprojected(:,i) / xy_reprojected(3,i);
end

diff = xy_reprojected - xy;
error = 0;
for i=1:numOfPoints
    error = error + norm(diff(1:2,i));
end
error = error/numOfPoints;

end