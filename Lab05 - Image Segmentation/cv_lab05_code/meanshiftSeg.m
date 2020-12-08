function [map peak] = meanshiftSeg(img)

% finer results
img = double(img);

% performance variables
r = 25; % experiment with other values

% generate dataset from image
L = size(img,1)*size(img,2); % number of pixels
X = [reshape(img(:,:,1),L,1), reshape(img(:,:,2),L,1), reshape(img(:,:,3),L,1)];

% find peaks and pixel to peak map
[map, peak] = mean_shift(X,r);

map = reshape(map, size(img(:,:,1))); % map is a Lx1 vector before





end