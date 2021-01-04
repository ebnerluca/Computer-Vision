function C = chi2_cost(s1,s2)
%CHI2_COST computes a cost matrix between two sets of shape context
%descriptors
%   Input:
%       s1,s2 - shape context descriptors
%   Output:
%       C - cost matrix

% initialize cost matrix
num_s1 = numel(s1);
num_s2 = numel(s2);
C = zeros(num_s1, num_s2);

% fill cost matrix
for i=1:num_s1
    for j=1:num_s2
        
        c = 0.5 * (s1{i}-s2{j}).^2 ./ (s1{i} + s2{j});
        c(isnan(c)) = 0; % set nan entries to zero 
        C(i,j) = sum(c, 'all');
    end
end

end

