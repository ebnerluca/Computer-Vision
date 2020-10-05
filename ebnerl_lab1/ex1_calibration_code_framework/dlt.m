%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xyn: 3xn
% XYZn: 4xn

function [P_normalized] = dlt(xyn, XYZn)
%computes DLT, xy and XYZ should be normalized before calling this function

% TODO 1. For each correspondence xi <-> Xi, computes matrix Ai
[temp, numOfPoints] = size(xyn);

A = [];
for i=1:numOfPoints    
    Ai_11 = XYZn(:,i)';
    Ai_12 = zeros(1,4);
    Ai_13 = -xyn(1,i)*XYZn(:,i)';
    Ai_21 = zeros(1,4);
    Ai_22 = -XYZn(:,i)';
    Ai_23 = xyn(2,i)*XYZn(:,i)';
    
    Ai = [Ai_11, Ai_12, Ai_13;
          Ai_21, Ai_22, Ai_23];
    A = [A; Ai];
end


% TODO 2. Compute the Singular Value Decomposition of Usvd*S*V' = A
[Usvd, S, V] = svd(A);

% TODO 3. Compute P_normalized (=last column of V if D = matrix with positive
% diagonal entries arranged in descending order)
P_normalized_vector = V(:,end);
P_normalized = [P_normalized_vector(1:4)';
                P_normalized_vector(5:8)';
                P_normalized_vector(9:12)'];

end
