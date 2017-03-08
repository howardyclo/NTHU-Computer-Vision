%% Clear all the histories
clc;clear;close all;

%% Constant for control
% if QUICK_DEMO == 1(true), load results from mat file instead of computing
% else, compute result again.
QUICK_DEMO = 1;

%%  Perform Part 1-D
% read image and convert it to grayscale
I = imread('J4Poro.png');
I = rgb2gray(I);
I = im2double(I);

if QUICK_DEMO == 1
    load('part_1d_result');
else
    % load 4 corner images and thresolds from part 1-c result
    load('part_1c_result');
    % perform non-maximum suppression for 4 corner images with their own thresholds
    Ieig1_filtered = CornerDetection.nonMaximumSuppression(Ieig1, threshold1);
    Ieig2_filtered = CornerDetection.nonMaximumSuppression(Ieig2, threshold2);
    Ieig3_filtered = CornerDetection.nonMaximumSuppression(Ieig3, threshold3);
    Ieig4_filtered = CornerDetection.nonMaximumSuppression(Ieig4, threshold4);
    % save results to 'part_1d_result.mat'
    save('part_1d_result', 'Ieig1_filtered');
    save('part_1d_result', 'Ieig2_filtered', '-append');
    save('part_1d_result', 'Ieig3_filtered', '-append');
    save('part_1d_result', 'Ieig4_filtered', '-append');
end

% plot corner positions on original image (here are 4 results)
% for gaussian kernel size=10, sigma=5, tensor structure window size=3
[posc1, posr1] = find(Ieig1_filtered == 1);
figure('Name', 'Corners with NMS (grad_mag1, 3x3 window)'), imshow(I);
hold on;
plot(posr1, posc1, 'r.');
% for gaussian kernel size=10, sigma=5, tensor structure window size=5
[posc2, posr2] = find(Ieig2_filtered == 1);
figure('Name', 'Corners with NMS (grad_mag1, 5x5 window)'), imshow(I);
hold on;
plot(posr2, posc2, 'r.');
% for gaussian kernel size=20, sigma=5, tensor structure window size=3
[posc3, posr3] = find(Ieig3_filtered == 1);
figure('Name', 'Corners with NMS (grad_mag2, 3x3 window)'), imshow(I);
hold on;
plot(posr3, posc3, 'r.');
% for gaussian kernel size=20, sigma=5, tensor structure window size=5
[posc4, posr4] = find(Ieig4_filtered == 1);
figure('Name', 'Corners with NMS (grad_mag2, 5x5 window)'), imshow(I);
hold on;
plot(posr4, posc4, 'r.');