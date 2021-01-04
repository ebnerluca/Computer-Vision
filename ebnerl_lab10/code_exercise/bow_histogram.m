function histo = bow_histogram(vFeatures, vCenters)
  % input:
  %   vFeatures: MxD matrix containing M feature vectors of dim. D
  %   vCenters : NxD matrix containing N cluster centers of dim. D
  % output:
  %   histo    : N-dim. vector containing the resulting BoW
  %              activation histogram.
  
nCenters = size(vCenters,1);
nFeatures = size(vFeatures,1);
  
% Match all features to the codebook and record the activated
% codebook entries in the activation histogram "histo".

% nearest neighbor search:
[idx, ~] = knnsearch(vCenters, vFeatures);

% fill histogram
histo = zeros(1, nCenters);
for i=1:nCenters  % for all features of the list
    
    histo(i) = size(find(idx == i),1); % count
    
end
 
end
