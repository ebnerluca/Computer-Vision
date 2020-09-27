%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%

function [K, R, t] = decompose(P)
%Decompose P into K, R and t using QR decomposition

% TODO Compute R, K with QR decomposition such M=K*R 

% TODO Compute camera center C=(cx,cy,cz) such P*C=0 

% TODO normalize K such K(3,3)=1

% TODO Adjust matrices R and Q so that the diagonal elements of K (= intrinsic matrix) are non-negative values and R (= rotation matrix = orthogonal) has det(R)=1

% TODO Compute translation t=-R*C

end