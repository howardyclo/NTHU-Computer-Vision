%% Clear all the histories
clc;clear;close all;

%% Perform Part 1-D

% load point3D
load('points2D3D_1');
% load rotation matrix, translation vector from part_1b_result.mat
load('part_1b_result');
% visualize
visualizeCamera(point3D, Rotation1, Translation1, Rotation2, Translation2);