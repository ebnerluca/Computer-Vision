% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xN
%
% Output
% 	Fh 		Fundamental matrix with the det F = 0 constraint
% 	F 		Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)

% normalized points
[nx1s, T1] = normalizePoints2d(x1s);
[nx2s, T2] = normalizePoints2d(x2s);

x1 = nx1s(1,:)'; %Nx1 vector
y1 = nx1s(2,:)';
x2 = nx2s(1,:)';
y2 = nx2s(2,:)';

%A = [x1.*x2, x1.*y2, x1, y1.*x2, y1.*y2, y1, x2, y2, ones(size(nx1s,2),1)];
A = [x2.*x1, x2.*y1, x2, y2.*x1, y2.*y1, y2, x1, y1, ones(size(nx1s,2),1)];

% perform svd to compute Fn
[U,S,V] = svd(A);
nFvec = V(:,end); %the most right column corresponds to the nullspace vector, which solves the equation A*nFvec = 0
nF = [nFvec(1:3)';
      nFvec(4:6)';
      nFvec(7:9)'];

F = T2'*nF*T1; %similarity transformation
scale = F(3,3);
F = F/scale; %ensure that F is properly scaled for numerical stability and it is nicer to read out for the human eye

%enforce singularity
[U,S,V] = svd(F);
S(3,3) = 0; 

Fh= U*S*V'; %the 'real' fundamental matrix


end