%% Clear all the histories
clc;clear;close all;

%% Constant for control
% if QUICK_DEMO == 1(true), load results from mat file instead of computing
% else, compute result again.
QUICK_DEMO = 1;

%% Perform Part 2-E
if QUICK_DEMO == 1
    load('part_2e_result');
else
    % load LBPs from part 2-D result
    load('part_2d_result');
    % compute normalized histogram vectors
    dimesion = 59;
    [kobeHistVector, kobeNormHistVector] = LBP.image2NormalizedHistogramVector(kobeUniformLBP, dimesion);
    [gasolHistVector, gasolNormHistVector] = LBP.image2NormalizedHistogramVector(gasolUniformLBP, dimesion);
    % compute similarity by inner product of 2 vectors
    similarity = dot(kobeNormHistVector, gasolNormHistVector);
    % save to 'part_2e_result.mat'
    save('part_2e_result', 'similarity');
end
% show similarity in command window
disp(strcat('Similarity:', num2str(similarity)))