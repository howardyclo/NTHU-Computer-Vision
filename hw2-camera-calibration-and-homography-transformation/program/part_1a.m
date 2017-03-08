%% Clear all the histories
clc;clear;close all;

%% Constant for control
% if QUICK_DEMO == 1(true), load results from mat file instead of computing
% else, compute result again.
QUICK_DEMO = 0;

%% Perform Part 1-A
if QUICK_DEMO == 1
    % load part 1-A result
    load('part_1a_result');
else
    % load 2D, 3D points corresponding to the left image in spec.
    load('points2D3D_1');
    % compute corresponding camera matrix
    P1 = computeCameraMatrix(point2D, point3D);
    % load 2D, 3D points corresponding to the right image in spec.
    load('points2D3D_2');
    % compute corresponding camera matrix
    P2 = computeCameraMatrix(point2D, point3D);
    % save results to 'part_1a_result.mat'
    save('part_1a_result', 'P1');
    save('part_1a_result', 'P2', '-append');
end
% show results
P1
P2