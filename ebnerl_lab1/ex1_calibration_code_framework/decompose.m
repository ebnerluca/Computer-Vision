%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%

function [K, R, t] = decompose(P)
%Decompose P into K, R and t using QR decomposition

% TODO Compute R, K with QR decomposition such M=K*R 
M = P(1:3, 1:3);
[R_inv, K_inv] = qr(inv(M));

R = inv(R_inv);
K = inv(K_inv);

% TODO Compute camera center C=(cx,cy,cz) such P*C=0 
[U, S, V] = svd(P);
C = V(:, end);

% TODO normalize K such K(3,3)=1
scale = K(3,3);
K = K / scale;

% TODO Adjust matrices R and Q so that the diagonal elements of K (= intrinsic matrix) are non-negative values and R (= rotation matrix = orthogonal) has det(R)=1
for i=1:3
    if K(i,i) < 0
        K(:,i) = -K(:,i);
        R(i,:) = -R(i,:);
    end
end


detR = det(R);
[R_rows, R_columns] = size(R);
R = R / nthroot(detR, R_rows); %ensure that  R has det(R) == 1

% TODO Compute translation t=-R*C
C = C / C(end);
t = -R*C(1:3);
end