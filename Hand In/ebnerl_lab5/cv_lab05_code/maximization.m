function [mu, var, alpha] = maximization(P, X)

K = size(P,2);
N = size(X,1);

mu = zeros(K,3);
var = zeros(3,3,K);
alpha = zeros(1,K);

for k=1:K
   
    % formulas taken from http://lasa.epfl.ch/teaching/lectures/ML_Phd/Notes/GP-GMM.pdf
    alpha(k) = sum(P(:,k))/N; % average probability of a pixel to lie in segment k
    mu(k,:) = sum(X.* repmat(P(:,k), [1,3])) / sum(P(:,k)); % Expected L*a*b value for segment k
    
    for l = 1:N
        var(:,:,k) = var(:,:,k) + P(l,k)*((X(l,:)-mu(k,:))'*(X(l,:)-mu(k,:)));
    end
    var(:,:,k) = var(:,:,k)/sum(P(:,k));
end

alpha = alpha/sum(alpha); % makes sure that the total probability is always = 1


end