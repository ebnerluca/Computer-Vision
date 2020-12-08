function [w_x, w_y, E] = tps_model(X ,Y, lambda)
% Inputs:
%   - X: points in the template shape
%   - Y: corresponding points in target shape
%   - lambda: regularization parameter
% Outputs: 
%   - w_x: parameters of first TPS model
%   - W_y: parameters of second TPS model
%   - E: total bending energy

num_points = size(X, 1);

P = [ones(num_points, 1), X];

t = sqrt(dist2(X,X));
K = t.^2 .* log(t.^2);
K(isnan(K)) = 0; % set nan entries to zero

T = [ [K + lambda * eye(num_points), P         ];
      [P',                           zeros(3)  ]  ];

vx = [Y(:,1); zeros(3,1)];
vy = [Y(:,2); zeros(3,1)];

fx = T \ vx;
fy = T \ vy;

w_x = fx(1:num_points, :);
w_y = fy(1:num_points, :);

E = w_x'*K*w_x + w_y'*K*w_y;

w_x = fx;
w_y = fy;

end