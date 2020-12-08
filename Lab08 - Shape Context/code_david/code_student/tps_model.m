function [w_x, w_y, E] = tps_model(Xunwarped ,Y, lambda)

n_points = size(Xunwarped, 1);

P = [ones(n_points, 1), Xunwarped]; % dim: n_points x 3

t = squareform(pdist(Xunwarped));  % t_ij = || (x_i, y_i) - (x_j, y_j) ||
K = t.^2 .* log(t.^2);  % K_ij = U(t_ij), dim: n_points x n_points
K(isnan(K)) = 0;  % eliminate NaNs
L = [ [K + lambda * eye(n_points), P]; [P' zeros(3)] ]; % dim: (n_points+3) x (n_points+3)

v_x = [Y(:, 1); zeros(3, 1)]; % dim: (n_points+3) x 1
v_y = [Y(:, 2); zeros(3, 1)]; % dim: (n_points+3) x 1

f_x = L \ v_x;
f_y = L \ v_y;

w_x = f_x(1:n_points, :);
w_y = f_y(1:n_points, :);

E = w_x' * K * w_x + w_y' * K * w_y;

w_x = f_x;
w_y = f_y;

end