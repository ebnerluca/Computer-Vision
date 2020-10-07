% Extract Harris corners.
%
% Input:
%   img           - n x m gray scale image
%   sigma         - smoothing Gaussian sigma
%                   suggested values: .5, 1, 2
%   k             - Harris response function constant
%                   suggested interval: [4e-2, 6e-2]
%   thresh        - scalar value to threshold corner strength
%                   suggested interval: [1e-6, 1e-4]
%   
% Output:
%   corners       - 2 x q matrix storing the keypoint positions
%   C             - n x m gray scale image storing the corner strength
function [corners, C] = extractHarris(img, sigma, k, thresh)

[img_height, img_width] = size(img);

%% Image gradients
gradx_filter = [0.5, 0, -0.5];
grady_filter = [0.5; 0; -0.5];
I_x = conv2(img, gradx_filter, 'same');
I_y = conv2(img, grady_filter, 'same');

%% Local auto-correlation matrix & Harris response function

%blurred gradient images
I_x_blurred = imgaussfilt(I_x.^2, sigma);
I_y_blurred = imgaussfilt(I_y.^2, sigma);
I_xy_blurred = imgaussfilt(I_x.*I_y, sigma);


C = zeros(img_height, img_width);

for i=1:img_width
    for j=1:img_height

                M_p = [ I_x_blurred(j,i),  I_xy_blurred(j,i);
                        I_xy_blurred(j,i)    I_y_blurred(j,i)];
                    
                C(j,i) = det(M_p) -k*trace(M_p)^2;   
    end
end

%% Detection Criteria
 
regionalMaxTest = imregionalmax(C); %returns 1 for the C(i,j) if surroundings are lower
thresholdTest = abs(C) > thresh; %returns 1 for the C(i,j) if bigger than threshold

corners = [];
for i=1:img_width
    for j=1:img_height
        if (regionalMaxTest(j,i) == 1 && thresholdTest(j,i))
            corner = [j;i];
            corners = [corners, corner];
        end
    end
end
 
end