function [map cluster] = EM(img)

% use function generate_mu to initialize mus
% use function generate_cov to initialize covariances

% iterate between maximization and expectation
% use function maximization
% use function expectation

% convert img to double for more precision
img = double(img);

% generate dataset from image
N = size(img,1)*size(img,2); % number of pixels
X = [reshape(img(:,:,1),N,1), reshape(img(:,:,2),N,1), reshape(img(:,:,3),N,1)];

% fix number of segments to {3,4,5}, depending on exercise
K = 5;

% get L*a*b range of dataset
min_lab = [min(X(:,1)), min(X(:,2)), min(X(:,3))];
max_lab = [max(X(:,1)), max(X(:,2)), max(X(:,3))];

% initialize gaussian parameters
alpha_current = 1/K * ones(1,K); % uniform alpha
mu_current = generate_mu(min_lab, max_lab, K);
var_current = generate_cov(min_lab, max_lab, K);

thresh = 1*K;
shift = Inf;

while shift > thresh
    
    % expectation
    P = expectation(mu_current,var_current,alpha_current,X);
    
    % maximization
    [mu_new, var_current, alpha_current] = maximization(P, X);
    
    % compute average shift
    shift = mean( sum((mu_new - mu_current).^2, 2) )
    mu_current = mu_new;
        
end

% for each pixel get cluster index with the biggest probability
[~,indices] = max(P,[],2);

% form map of img size where each entry contains index of its segment
map = reshape(indices,size(img(:,:,1)));
cluster = mu_current;

% output gaussian parameters for report
K = K
mu = mu_current
var = var_current
alpha = alpha_current
end