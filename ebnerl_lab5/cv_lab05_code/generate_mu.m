% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(min_lab, max_lab, K)

mu = zeros(K,3);

for i=1:K
    
    l = randi([min_lab(1) max_lab(1)]);
    a = randi([min_lab(2) max_lab(2)]);
    b = randi([min_lab(3) max_lab(3)]);
    mu(i,:) = [l,a,b];
    
end

end