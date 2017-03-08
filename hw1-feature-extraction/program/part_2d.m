%% Clear all the histories
clc;clear;close all;

%% Constant for control
% if QUICK_DEMO == 1(true), load results from mat file instead of computing
% else, compute result again.
QUICK_DEMO = 1;

%% Perform Part 2-D
if QUICK_DEMO == 1
    load('part_2d_result');
else
    % load LBPs from part 2-A result
    load('part_2a_result');
    % compute LBPs for images
    kobeUniformLBP = LBP.LBP2UniformLBP(kobeLBP);
    gasolUniformLBP = LBP.LBP2UniformLBP(gasolLBP);
    % save results
    save('part_2d_result', 'kobeUniformLBP');
    save('part_2d_result', 'gasolUniformLBP', '-append');
end
% show results (remember to normalize by dividing 59)
subplot(121), imshow(kobeUniformLBP./59), title('Kobe Uniform LBP');
subplot(122), imshow(gasolUniformLBP./59), title('Gasol Uniform LBP');