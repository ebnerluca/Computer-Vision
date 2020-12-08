clear
close all

%% init
N_SAMPLES = 500;  % number of points to use for shape matching

TEMPLATE_IDX = 1;  % index of template object in dataset
TARGET_IDX = 7;  % index of target object in dataset

DISPLAY_FLAG = 1;

% dataset.objects(index): 1-5 heart, 6-10 fork, 11-15 watch
dataset = load('dataset.mat'); 

% each object has attributes X (points), class (type of shape), img (bool array)
template = dataset.objects(TEMPLATE_IDX);
target = dataset.objects(TARGET_IDX);

% plot template and target image (debug)
figure(20)
subplot(1,2,1)
imshow(template.img)
title('Template Image')
subplot(1,2,2)
imshow(target.img)
title('Target Image')


%% test, debug
points_template = template.X;
figure(3)
scatter(points_template(:, 1), points_template(:, 2), 'b.')

d = sc_compute(points_template', 12, 5, 1/8, 3);

% plot template and target points
figure(21)
subplot(1,2,1)
scatter(template.X(:, 1), template.X(:, 2), 'b.')
daspect([1 1 1])  % equal scaling of x and y axes
title('Template Points')
subplot(1,2,2)
scatter(target.X(:, 1), target.X(:, 2), 'k.')
daspect([1 1 1])  % equal scaling of x and y axes
title('Target Points')


%% shape matching

% % ensure template and target contain the same number of points
% points_template = get_samples(template.X, N_SAMPLES);
% points_target = get_samples(target.X, N_SAMPLES);
% 
% matching_error = shape_matching(points_template, points_target, DISPLAY_FLAG)

