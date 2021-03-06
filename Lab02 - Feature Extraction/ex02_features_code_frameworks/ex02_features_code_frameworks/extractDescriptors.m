% Extract descriptors.
%
% Input:
%   img           - the gray scale image
%   keypoints     - detected keypoints in a 2 x q matrix
%   
% Output:
%   keypoints     - 2 x q' matrix
%   descriptors   - w x q' matrix, stores for each keypoint a
%                   descriptor. w is the size of the image patch,
%                   represented as vector
function [keypoints, descriptors] = extractDescriptors(img, keypoints)

[img_height, img_width] = size(img);
patchSize = 9;
boundary = 5;

newKeypoints = keypoints;
for i=size(keypoints,2):-1:1
    if ( (keypoints(2,i) <= boundary) || ((img_width - keypoints(2,i)) <= boundary) ) %check x boundaries
        newKeypoints(:,i) = []; %remove keypoint
    elseif ( (keypoints(1,i) <= boundary) || (img_height - keypoints(1,i) <= boundary) ) %check y boundaries
        newKeypoints(:,i) = [];
    end
end
keypoints = newKeypoints;

descriptors = extractPatches(img, keypoints, patchSize);
 
end