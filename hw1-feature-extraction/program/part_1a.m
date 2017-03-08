%% Clear all the histories
clc;clear;close all;

%% Constant for control
% if QUICK_DEMO == 1(true), load results from mat file instead of computing
% else, compute result again.
QUICK_DEMO = 1; 

%% Perform Part 1-A
% read image
I = imread('J4Poro.png');

if QUICK_DEMO == 1
    % load part 1-A result
    load('part_1a_result');
else
    % define params for guassian filter
    kernel_size_1 = 10;
    kernel_size_2 = 20;
    sigma = 5;
    % apply guassian filter
    Ig1 = CornerDetection.gaussianFilter(I, kernel_size_1, sigma);
    Ig2 = CornerDetection.gaussianFilter(I, kernel_size_2, sigma);
    % save results to 'part_1a_result.mat'
    save('part_1a_result', 'Ig1');
    save('part_1a_result', 'Ig2', '-append');
end

% show image
figure('Name', 'Part 1-A');
subplot(131), imshow(I), title('Original image');
subplot(132), imshow(Ig1), title('After Gaussian smoothing (Kernel size = 10)');
subplot(133), imshow(Ig2), title('After Gaussian smoothing (Kernel size = 20)');
% conclusion: the results show that the blurring level is porpotional to
% keneral size.