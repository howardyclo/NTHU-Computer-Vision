%% Clear all the histories
clc;clear;close all;

%% Constant for control
% if QUICK_DEMO == 1(true), load results from mat file instead of computing
% else, compute result again.
QUICK_DEMO = 1;

%% Perform Part 2-B
if QUICK_DEMO == 1
    load('part_2b_result');
else
    % load LBPs from part 2-A result
    load('part_2a_result');
    % compute normalized histogram vectors
    dimesion = 256;
    [kobeHistVector, kobeNormHistVector] = LBP.image2NormalizedHistogramVector(kobeLBP, dimesion);
    [gasolHistVector, gasolNormHistVector] = LBP.image2NormalizedHistogramVector(gasolLBP, dimesion);
    % compute similarity by inner product of 2 vectors
    similarity = dot(kobeNormHistVector, gasolNormHistVector);
    % save to 'part_2b_result.mat'
    save('part_2b_result', 'kobeHistVector');
    save('part_2b_result', 'gasolHistVector', '-append');
    save('part_2b_result', 'similarity', '-append');
end
% show similarity in command window
disp(strcat('Similarity:', num2str(similarity)));