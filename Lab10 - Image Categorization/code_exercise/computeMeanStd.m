function [mu sigma] = computeMeanStd(vBoW)

% columnwise
mu = mean(vBoW);  
sigma = std(vBoW); 

idx = find(sigma<0.5);
sigma(idx) = 0.5;

end