%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runDLT(xy, XYZ)

% normalize 
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT with normalized coordinates
[Pn] = dlt(xy_normalized, XYZ_normalized);

% TODO denormalize projection matrix
P = inv(T)*Pn*U;
%factorize projection matrix into K, R and t
[K, R, t] = decompose(P);   

% TODO compute average reprojection error
error = 0;
end