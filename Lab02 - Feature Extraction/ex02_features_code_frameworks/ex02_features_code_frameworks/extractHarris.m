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

[img_width, img_height] = size(img);

%% Image gradients
gradx_filter = [0.5, 0, -0.5];
grady_filter = [0.5; 0; -0.5];
I_x = conv2(img, gradx_filter, 'same');
I_y = conv2(img, grady_filter, 'same');

%% Local auto-correlation matrix & Harris response function

%blurred gradient images
I_x_blurred = imgaussfilt(I_x, sigma);
I_y_blurred = imgaussfilt(I_y, sigma);
I_xy_blurred = imgaussfilt(I_x.*I_y, sigma);


C = zeros(img_width, img_height);

for i=1:img_width
    for j=1:img_height

                M_p = [ I_x_blurred(i,j)^2,  I_xy_blurred(i,j);
                        I_xy_blurred(i,j)    I_y_blurred(i,j)^2 ];
                    
                C(i,j) = det(M_p) -k*trace(M_p)^2;   
    end
end
% for i=2:(img_width-1)
%     for j=2:(img_height-1)
%         
%         M_p = [0;0];
%         for u=-1:1
%             for v=-1:1
%                 
%                 M_pk = [ I_x_blurred(i+u,j+v)^2,  I_xy_blurred(i+u,j+v);
%                         I_xy_blurred(i+u,j+v)    I_y_blurred(i+u,j+v)^2 ];
%                     
%                 M_p = M_p + M_pk;
%                 
%             end
%         end
%         C(i,j) = det(M_p) -k*trace(M_p)^2;
%     end
% end

%% Detection Criteria
 
regionalMaxTest = imregionalmax(C); %returns 1 for the C(i,j) if surroundings are lower
thresholdTest = abs(C) > thresh; %returns 1 for the C(i,j) if bigger than threshold

corners = [];
for i=1:img_width
    for j=1:img_height
        if (regionalMaxTest(i,j) == 1 && thresholdTest(i,j))
            corner = [i;j];
            corners = [corners, corner];
        end
    end
end
 
end