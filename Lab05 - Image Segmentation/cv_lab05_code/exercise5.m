function run_ex5()

close all;
clear all;

% load image
img = imread('cow.jpg');
% for faster debugging you might want to decrease the size of your image
% (use imresize)
% (especially for the mean-shift part!)
img = imresize(img, 1); % imresize(input_img, scale)

figure, imshow(img), title('original image');

% smooth image (6.1a)
% (replace the following line with your code for the smoothing of the image)
filter = fspecial('gaussian', [5 5], 5); %fspecial(type, window_size, sigma)
imgSmoothed = imfilter(img, filter);
figure, imshow(imgSmoothed), title('smoothed image');

% convert to L*a*b* image (6.1b)
% (replace the folliwing line with your code to convert the image to lab
cform = makecform('srgb2lab');
imglab = applycform(imgSmoothed,cform);
figure, imshow(imglab), title('l*a*b* image');


% (6.2)
% [mapMS peak] = meanshiftSeg(imglab);
% visualizeSegmentationResults (mapMS,peak);
% disp(['Mean-Shift: peaks = ' int2str(size(peak,1))])

% (6.3)
[mapEM cluster] = EM(imglab);
visualizeSegmentationResults (mapEM,cluster);

end