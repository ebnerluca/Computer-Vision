function cost_matrix = chi2_cost(d_1, d_2)

n_points_1 = numel(d_1);
n_points_2 = numel(d_2);
n_max = max(n_points_1, n_points_2);

cost_matrix = zeros(n_max, n_max);  % hungarian algorithm requires square matrix

for i=1:n_points_1
    for k=1:n_points_2
        cost_ik = 0.5 * (d_1{i} - d_2{k}).^2 ./ (d_1{i} + d_2{k});
        cost_ik(isnan(cost_ik)) = 0;  % there are most likely some empty bins that lead to NaNs
        cost_matrix(i, k) = sum(sum(cost_ik));
        
    end
end

end