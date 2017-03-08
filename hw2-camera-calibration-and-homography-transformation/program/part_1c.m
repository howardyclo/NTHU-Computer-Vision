%% Clear all the histories
clc;clear;close all;

%% Constant for control
% if QUICK_DEMO == 1(true), load results from mat file instead of computing
% else, compute result again.
QUICK_DEMO = 0;

%% Perform Part 1-C
if QUICK_DEMO == 1
    % load part 1-C result
    load('part_1c_result');
else
    % load 2D, 3D points corresponding to the left image in spec.
    load('points2D3D_1');
    point2D_1 = point2D;
    point3D_1 = point3D;
    load('points2D3D_2');
    point2D_2 = point2D;
    point3D_2 = point3D;
    % load intrinsic matrix, rotation matrix, translation vector and extrinsic matrix from part 1b result
    load('part_1b_result');

    % compose projection matrix for testing:
    % point2D(homogeneous) = Intrinsic * Projection * Extrinsic * point3D(homogeneous)
    Projection = eye(3);
    Projection(:,4) = [0,0,0]';

    % for chessboard1.jpg: re-project 2D point from computed camera intrinsic matrix, rotation matrix and translation vector
    homoPoint3D_1 = point3D_1;
    homoPoint3D_1(:,4) = 1;
    homoPoint2D_1 = (Intrinsic1 * Projection * Extrinsic1 * homoPoint3D_1')';
    homoPoint2D_1(:,1) = homoPoint2D_1(:,1) ./ homoPoint2D_1(:,3);
    homoPoint2D_1(:,2) = homoPoint2D_1(:,2) ./ homoPoint2D_1(:,3);
    homoPoint2D_1(:,3) = 1;

    % for chessboard2.jpg: re-project 2D point from computed camera intrinsic matrix, rotation matrix and translation vector
    homoPoint3D_2 = point3D_2;
    homoPoint3D_2(:,4) = 1;
    homoPoint2D_2 = (Intrinsic2 * Projection * Extrinsic2 * homoPoint3D_2')';
    homoPoint2D_2(:,1) = homoPoint2D_2(:,1) ./ homoPoint2D_2(:,3);
    homoPoint2D_2(:,2) = homoPoint2D_2(:,2) ./ homoPoint2D_2(:,3);
    homoPoint2D_2(:,3) = 1;

    % calculate RMSE
    error1 = homoPoint2D_1(:,1:2) - point2D_1(:,1:2);
    RMSE1 = sqrt(sum(sum(error1.^2))/size(error1,1));

    error2 = homoPoint2D_2(:,1:2) - point2D_2(:,1:2);
    RMSE2 = sqrt(sum(sum(error2.^2))/size(error2,1));

    % prepare to plot re-projected points back to 2 images
    clickX_1 = point2D_1(:,1);
    clickY_1 = point2D_1(:,2);
    predictX_1 = homoPoint2D_1(:,1);
    predictY_1 = homoPoint2D_1(:,2);

    clickX_2 = point2D_2(:,1);
    clickY_2 = point2D_2(:,2);
    predictX_2 = homoPoint2D_2(:,1);
    predictY_2 = homoPoint2D_2(:,2);

    % save result to part 1c result
    save('part_1c_result', 'clickX_1');
    save('part_1c_result', 'clickY_1', '-append');
    save('part_1c_result', 'predictX_1', '-append');
    save('part_1c_result', 'predictY_1', '-append');
    save('part_1c_result', 'RMSE1', '-append');

    save('part_1c_result', 'clickX_2', '-append');
    save('part_1c_result', 'clickY_2', '-append');
    save('part_1c_result', 'predictX_2', '-append');
    save('part_1c_result', 'predictY_2', '-append');
    save('part_1c_result', 'RMSE2', '-append');
end

RMSE1
RMSE2

% plot re-projected points back to 2 images (yellow: clicked points; red: predicted points)
figure('Name', 'chessboard1.jpg'), imshow('chessboard1.jpg');
hold on;
plot(clickX_1, clickY_1, 'yo');
plot(predictX_1, predictY_1, 'r*');
hold off;

figure('Name', 'chessboard2.jpg'), imshow('chessboard2.jpg');
hold on;
plot(clickX_2, clickY_2, 'yo');
plot(predictX_2, predictY_2, 'r*');
hold off;
