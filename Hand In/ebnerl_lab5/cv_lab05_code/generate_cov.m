% Generate initial values for the K
% covariance matrices

function cov = generate_cov(min_lab, max_lab, K)

cov = zeros(3,3,K);
lab_range = max_lab-min_lab;

for i=1:K
    cov(:,:,i) = diag([lab_range(1), lab_range(2), lab_range(3)]);
end

end