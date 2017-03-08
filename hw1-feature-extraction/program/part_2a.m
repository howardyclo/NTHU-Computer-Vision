%% Clear all the histories
clc;clear;close all;

%% Constant for control
% if QUICK_DEMO == 1(true), load results from mat file instead of computing
% else, compute result again.
QUICK_DEMO = 1;

%% Perform Part 2-A
if QUICK_DEMO == 1
    load('part_2a_result');
else
    % read images and convert them to grayscale
    kobe = rgb2gray(imread('kobeFace.png'));
    gasol = rgb2gray(imread('gasolFace.png'));
    % compute LBPs for images
    kobeLBP = LBP.computeLBP(kobe);
    gasolLBP = LBP.computeLBP(gasol);
    % save results
    save('part_2a_result', 'kobeLBP');
    save('part_2a_result', 'gasolLBP', '-append');
end
% show results (need to convert to uint8)
subplot(121), imshow(uint8(kobeLBP)), title('Kobe LBP');
subplot(122), imshow(uint8(gasolLBP)), title('Gasol LBP');