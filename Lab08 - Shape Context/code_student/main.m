close all;
clear all;

%% Parameters

display_flag = true;
num_samples = 750;
template_index  = 1;
target_index = 5;

%% Loading data
objects = load('dataset.mat').objects;
num_objects = size(objects,2);

template = objects(template_index); % placeholder
target = objects(target_index);

% display template and target
figure(20)
subplot(1,2,1)
imshow(template.img)
title('Template Image')
subplot(1,2,2)
imshow(target.img)
title('Target Image')

%% Run

X1 = get_samples(template.X, num_samples);
X2 = get_samples(target.X, num_samples);

matching_cost = shape_matching(X1, X2, display_flag)
