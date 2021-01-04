function P = expectation(mu,var,alpha,X)
% Outputs:
%   - P: Total probability that x is in segment k, size Nxk

K = length(alpha);
N = size(X,1);
P = zeros(N,K);

for idx=1:N % for all pixels in the dataset
    
    for k=1:K % for all segments
       
        % compute P(idx,k) (Probability that pixel idx lies in segment k)
        temp = -0.5 * (X(idx,:)-mu(k,:)) * pinv(var(:,:,k)) * (X(idx,:)-mu(k,:))';
        P(idx,k) = alpha(k) * (1 / ( ((2*pi)^(3/2)) * det(var(:,:,k))^(1/2) )) * exp(temp);
        
    end
    
    total_probability = sum(P(idx,:));
    P(idx,:) = P(idx,:)/total_probability; % makes sure that the total probability is always = 1
    
end

end