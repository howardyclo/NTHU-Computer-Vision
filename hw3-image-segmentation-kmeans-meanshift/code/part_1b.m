%% Clear all the histories
clc;clear;close all;

%% Perform Part 1-B

img = im2double(imread('CaitlinPoro.jpg'));

% hand-picked initial centroid colors from image 
white = [0.98, 0.976, 0.855];
red = [0.945, 0.459, 0.31];
pink = [0.82, 0.729, 0.667];
purple = [0.318, 0.196, 0.318];
light_blue = [0.702, 0.933, 0.965];
dark_blue = [0.208, 0.439, 0.51];
light_yellow = [1, 0.835, 0.322];
dark_yellow = [0.749, 0.439, 0.0784];
light_brown = [0.494, 0.192, 0.122];
dark_brown = [0.165, 0.145, 0.133];
gray = [0.373, 0.439, 0.416];

centroids1 = [light_blue; gray; dark_brown];
centroids2 = [white; red; purple; light_yellow; light_blue; light_brown; dark_brown];
centroids3 = [white; red; pink; purple; light_yellow; dark_yellow; light_blue; dark_blue; gray; light_brown; dark_brown];

[img_segmented1, color_bar1] = Segment.optimize_kmeans(img, 3, 1, centroids1);
[img_segmented2, color_bar2] = Segment.optimize_kmeans(img, 7, 1, centroids2);
[img_segmented3, color_bar3] = Segment.optimize_kmeans(img, 11, 1, centroids3);

% show results
% k = 3
figure;
subplot(4,5,[1:12]);
imshow(img_segmented1);
subplot(4,4,[13:16]);
imshow(color_bar1);
% k = 7
figure;
subplot(4,5,[1:12]);
imshow(img_segmented2);
subplot(4,4,[13:16]);
imshow(color_bar2);
% k = 11
figure;
subplot(4,5,[1:12]);
imshow(img_segmented3);
subplot(4,4,[13:16]);
imshow(color_bar3);
