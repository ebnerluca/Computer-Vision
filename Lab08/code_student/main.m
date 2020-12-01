close all;
clear all;

display_flag = true;

% Loading data
objects = load('dataset.mat').objects;
num_objects = size(objects,2);

object1 = objects(1); % placeholder
object2 = objects(2)

X1 = object1.X;
X2 = object2.X;

matching_cost = shape_matching(X1, X2, display_flag)
