%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runDLT(xy, XYZ)

% normalize 
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT with normalized coordinates
[Pn] = dlt(xy_normalized, XYZ_normalized); %compute Pn with normalized coordinates
%[Pspecial] = dlt( [xy; ones(1,size(xy,2))], [XYZ; ones(1,size(xy,2))] ) %Test: compute P without normalized calibration points

% TODO denormalize projection matrix
P = inv(T)*Pn*U;

%factorize projection matrix into K, R and t
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