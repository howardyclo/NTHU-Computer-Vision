%% Clear all the histories
clc;clear;close all;

%% Constant for control
% if QUICK_DEMO == 1(true), load results from mat file instead of computing
% else, compute result again.
QUICK_DEMO = 0;

%% Perform Part 2-A
if QUICK_DEMO == 1
    % load part 2-A result
    load('part_2a_result');
else
    % load Hillary and Trump's four 2D points
    load('part_2_input');
    % compute homography
    H = computeHomography(hillaryPoint2D, trumpPoint2D);
    % save result to 'part_2a_result.mat'
    save('part_2a_result', 'H');
end

% show result
H