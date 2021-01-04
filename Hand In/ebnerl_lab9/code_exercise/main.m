close all;
clear all;

%% parameters

video = 'video3';
load params;

% overwrite param
params.model = 0;
params.initial_velocity = [16,0]
params.alpha = 0.1
params.sigma_position = 15
params.sigma_velocity = 8
params.sigma_observation = 0.1


%% run

condensationTracker(video, params)
