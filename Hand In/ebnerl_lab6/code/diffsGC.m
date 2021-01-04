function diffs = diffsGC(img1, img2, dispRange)
% get data costs for graph cut

numLabels = size(dispRange,2);
offset = ceil(numLabels/2);

% average filter with window size 5
filter = fspecial('average', 5);

% initialize diffs 
diffs = zeros(size(img1,1), size(img1,2), numLabels);

for label=1:numLabels
    
    d = label - offset;
    
    % difference in grey scale of img1 and shifted img2
    shift_diff = (img1 - shiftImage(img2, d)).^2;

    % apply average filter with window size
    diffs(:,:,label) = conv2(shift_diff, filter, 'same');
    
end

end