% =========================================================================
% Exercise 8
% =========================================================================
clear all;
close all;

% Initialize VLFeat (http://www.vlfeat.org/)
addpath(genpath('../toolbox'));
% vl_setup;

%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, scores] = vl_ubcmatch(da, db);

%raw sift feature matches
showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);

%% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices
thresh_f = 0.0001;
thresh_p = 0.04;

xa = fa(1:2, matches(1,:));
xb = fb(1:2, matches(2,:));
xa = makehomogeneous(xa);
xb = makehomogeneous(xb);

[F, inlier_indices] = ransacfitfundmatrix(xa, xb, thresh_f);

xa_inliers = xa(:, inlier_indices);
xb_inliers = xb(:, inlier_indices);
outlier_indices = setdiff(1:size(matches,2), inlier_indices);
xa_outliers = xa(:, outlier_indices);
xb_outliers = xb(:, outlier_indices);


% show feature matches that were counted as inliers
showFeatureMatches(img1, xa(1:2, inlier_indices), img2, xb(1:2, inlier_indices), 21);
% show feature matches that were counted as outliers
showFeatureMatches(img1, xa(1:2, outlier_indices), img2, xb(1:2, outlier_indices), 22);



% show inlier points
figure(1),clf, imshow(img1, []); hold on, plot(xa_inliers(1,:), xa_inliers(2,:), '*r');
figure(2),clf, imshow(img2, []); hold on, plot(xb_inliers(1,:), xb_inliers(2,:), '*r');

% draw epipolar lines in img 1
figure(1)
for k = 1:size(xa_inliers,2)
    drawEpipolarLines(F'*xb_inliers(:,k), img1);
end
% draw epipolar lines in img 2
figure(2)
for k = 1:size(xb_inliers,2)
    drawEpipolarLines(F*xa_inliers(:,k), img2);
end

E = K'*F*K;

Ps{1} = eye(4);

xa_calibrated = K \ xa_inliers;
xb_calibrated = K \ xb_inliers;
Ps{2} = decomposeE(E, xa_calibrated, xb_calibrated);

%triangulate the inlier matches with the computed projection matrix
[X2, ~] = linearTriangulation(Ps{1}, xa_calibrated, Ps{2}, xb_calibrated);

%% Add an addtional view of the scene 

imgName3 = '../data/house.003.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated
fa_triangulated = fa(:, matches(1, inlier_indices));
da_triangulated = da(:, matches(1, inlier_indices));
[matches3, scores] = vl_ubcmatch(da_triangulated, dc);

%SIFT inliers
xa3 = fa_triangulated(1:2, matches3(1,:));
xc = fc(1:2, matches3(2,:));
xa3 = makehomogeneous(xa3);
xc = makehomogeneous(xc);

xa3_calibrated = K \ xa3;
xc_calibrated = K \ xc;


%run 6-point ransac
[Ps{3}, inlier_indices3] = ransacfitprojmatrix(xc_calibrated, X2(:,matches3(1,:)), thresh_p);
Ps{3}
if (det(Ps{3}(1:3,1:3)) < 0 )
    %Ps{3}(1:3,1:3) = -Ps{3}(1:3,1:3);
    %Ps{3}(1:3, 4) = -Ps{3}(1:3, 4);
    Ps{3}(1:3,:) = -Ps{3}(1:3,:);
end
Ps{3}

% show feature matches that were counted as inliers
%xa3_inliers = xa3(:, inlier_indices3);
%xc_inliers = xc(:, inlier_indices3);
showFeatureMatches(img1, xa3(1:2, inlier_indices3), img3, xc(1:2, inlier_indices3), 31);
outlier_indices3 = setdiff(1:size(matches3,2), inlier_indices3);
showFeatureMatches(img1, xa3(1:2, outlier_indices3), img3, xc(1:2, outlier_indices3), 32);

%triangulate the inlier matches with the computed projection matrix
[X3, ~] = linearTriangulation(Ps{1}, xa3_calibrated, Ps{3}, xc_calibrated);

%% Add more views...

% img4
imgName4 = '../data/house.002.pgm';
img4 = single(imread(imgName4));
[fd, dd] = vl_sift(img4);

%match against the features from image 1 that where triangulated
[matches4, scores] = vl_ubcmatch(da_triangulated, dd);

%SIFT inliers
xa4 = fa_triangulated(1:2, matches4(1,:)); %sift features of img1 that were triangulated and were counted as matches
xd = fd(1:2, matches4(2,:));
xa4 = makehomogeneous(xa4);
xd = makehomogeneous(xd);

xa4_calibrated = K \ xa4;
xd_calibrated = K \ xd;

%run 6-point ransac
[Ps{4}, inlier_indices4] = ransacfitprojmatrix(xd_calibrated, X2(:,matches4(1,:)), thresh_p);
if (det(Ps{4}(1:3,1:3)) < 0 )
    Ps{4}(1:3,:) = -Ps{4}(1:3,:);
end

% show inlier matches
showFeatureMatches(img1, xa4(1:2, inlier_indices4), img4, xd(1:2, inlier_indices4), 41);
% show outlier matches
outlier_indices4 = setdiff(1:size(matches4,2), inlier_indices4);
showFeatureMatches(img1, xa4(1:2, outlier_indices4), img4, xd(1:2, outlier_indices4), 42);

% triangulate
[X4, ~] = linearTriangulation(Ps{1}, xa4_calibrated, Ps{4}, xd_calibrated);


% img5
imgName5 = '../data/house.001.pgm';
img5 = single(imread(imgName5));
[fe, de] = vl_sift(img5);

%match against the features from image 1 that where triangulated
[matches5, scores] = vl_ubcmatch(da_triangulated, de);

%SIFT inliers
xa5 = fa_triangulated(1:2, matches5(1,:)); %sift features of img1 that were triangulated and were counted as matches
xe = fe(1:2, matches5(2,:));
xa5 = makehomogeneous(xa5);
xe = makehomogeneous(xe);

xa5_calibrated = K \ xa5;
xe_calibrated = K \ xe;

%run 6-point ransac
[Ps{5}, inlier_indices5] = ransacfitprojmatrix(xe_calibrated, X2(:,matches5(1,:)), thresh_p);
if (det(Ps{5}(1:3,1:3)) < 0 )
    Ps{5}(1:3,:) = -Ps{5}(1:3,:);
end

% show inlier matches
showFeatureMatches(img1, xa5(1:2, inlier_indices5), img5, xe(1:2, inlier_indices5), 51);
% show outlier matches
outlier_indices5 = setdiff(1:size(matches5,2), inlier_indices5);
showFeatureMatches(img1, xa5(1:2, outlier_indices5), img5, xe(1:2, outlier_indices5), 52);

% triangulate
[X5, ~] = linearTriangulation(Ps{1}, xa5_calibrated, Ps{5}, xe_calibrated);

%% Plot stuff

fig = 10;
figure(fig);

%use plot3 to plot the triangulated 3D points
plot3(X2(1,:),X2(2,:),X2(3,:),'r.'); hold on;
plot3(X3(1,:),X3(2,:),X3(3,:),'g.'); hold on;
plot3(X4(1,:),X4(2,:),X4(3,:),'b.'); hold on;
plot3(X5(1,:),X5(2,:),X5(3,:),'y.'); hold on;

%draw cameras
drawCameras(Ps, fig);