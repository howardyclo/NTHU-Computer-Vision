%% Clear all the histories
clc;clear;close all;

%% Perform Part 1-A
im_scene = imread('scene.jpg');
im_book1 = imread('book1.jpg');
im_book2 = imread('book2.jpg');
im_book3 = imread('book3.jpg');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CASE1: distance ratio threshold = 0.07
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Find match points
im_book = im_book1;
[l_f_points, r_f_points] = find_matches(im_book, im_scene, 0.07);

%% Copy book1 image and scene image to result image
im_book_large = zeros(size(im_scene));
im_book_large(1:size(im_book,1), 1:size(im_book, 2), :) = im_book;
im_result = [im_book_large, im_scene];

%% Draw match lines with green color
figure('Name', 'distance ratio threshold = 0.07');
imshow(im_result);
hold on;
plot(l_f_points(:,1), l_f_points(:,2), '*', 'Color', 'b');
plot(r_f_points(:,1)+size(im_scene,2), r_f_points(:,2), '*', 'Color', 'b');
for i=1:size(l_f_points,1)
  plot([l_f_points(i,1), r_f_points(i,1)+size(im_scene,2)], [l_f_points(i,2), r_f_points(i,2)], 'Color', 'g');
end
hold off;

%% Find match points
im_book = im_book2;
[l_f_points, r_f_points] = find_matches(im_book, im_scene, 0.07);

%% Copy book1 image and scene image to result image
im_book_large = zeros(size(im_scene));
im_book_large(1:size(im_book,1), 1:size(im_book, 2), :) = im_book;
im_result = [im_book_large, im_scene];

%% Draw match lines with green color
figure('Name', 'distance ratio threshold = 0.07');
imshow(im_result);
hold on;
plot(l_f_points(:,1), l_f_points(:,2), '*', 'Color', 'b');
plot(r_f_points(:,1)+size(im_scene,2), r_f_points(:,2), '*', 'Color', 'b');
for i=1:size(l_f_points,1)
  plot([l_f_points(i,1), r_f_points(i,1)+size(im_scene,2)], [l_f_points(i,2), r_f_points(i,2)], 'Color', 'g');
end
hold off;

%% Find match points
im_book = im_book3;
[l_f_points, r_f_points] = find_matches(im_book, im_scene, 0.07);

%% Copy book1 image and scene image to result image
im_book_large = zeros(size(im_scene));
im_book_large(1:size(im_book,1), 1:size(im_book, 2), :) = im_book;
im_result = [im_book_large, im_scene];

%% Draw match lines with green color
figure('Name', 'distance ratio threshold = 0.07');
imshow(im_result);
hold on;
plot(l_f_points(:,1), l_f_points(:,2), '*', 'Color', 'b');
plot(r_f_points(:,1)+size(im_scene,2), r_f_points(:,2), '*', 'Color', 'b');
for i=1:size(l_f_points,1)
  plot([l_f_points(i,1), r_f_points(i,1)+size(im_scene,2)], [l_f_points(i,2), r_f_points(i,2)], 'Color', 'g');
end
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CASE2: distance ratio threshold = 0.35
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Find match points
im_book = im_book1;
[l_f_points, r_f_points] = find_matches(im_book, im_scene, 0.35);

%% Copy book1 image and scene image to result image
im_book_large = zeros(size(im_scene));
im_book_large(1:size(im_book,1), 1:size(im_book, 2), :) = im_book;
im_result = [im_book_large, im_scene];

%% Draw match lines with green color
figure('Name', 'distance ratio threshold = 0.35');
imshow(im_result);
hold on;
plot(l_f_points(:,1), l_f_points(:,2), '*', 'Color', 'b');
plot(r_f_points(:,1)+size(im_scene,2), r_f_points(:,2), '*', 'Color', 'b');
for i=1:size(l_f_points,1)
  plot([l_f_points(i,1), r_f_points(i,1)+size(im_scene,2)], [l_f_points(i,2), r_f_points(i,2)], 'Color', 'g');
end
hold off;

%% Find match points
im_book = im_book2;
[l_f_points, r_f_points] = find_matches(im_book, im_scene, 0.35);

%% Copy book1 image and scene image to result image
im_book_large = zeros(size(im_scene));
im_book_large(1:size(im_book,1), 1:size(im_book, 2), :) = im_book;
im_result = [im_book_large, im_scene];

%% Draw match lines with green color
figure('Name', 'distance ratio threshold = 0.35');
imshow(im_result);
hold on;
plot(l_f_points(:,1), l_f_points(:,2), '*', 'Color', 'b');
plot(r_f_points(:,1)+size(im_scene,2), r_f_points(:,2), '*', 'Color', 'b');
for i=1:size(l_f_points,1)
  plot([l_f_points(i,1), r_f_points(i,1)+size(im_scene,2)], [l_f_points(i,2), r_f_points(i,2)], 'Color', 'g');
end
hold off;

%% Find match points
im_book = im_book3;
[l_f_points, r_f_points] = find_matches(im_book, im_scene, 0.35);

%% Copy book1 image and scene image to result image
im_book_large = zeros(size(im_scene));
im_book_large(1:size(im_book,1), 1:size(im_book, 2), :) = im_book;
im_result = [im_book_large, im_scene];

%% Draw match lines with green color
figure('Name', 'distance ratio threshold = 0.35');
imshow(im_result);
hold on;
plot(l_f_points(:,1), l_f_points(:,2), '*', 'Color', 'b');
plot(r_f_points(:,1)+size(im_scene,2), r_f_points(:,2), '*', 'Color', 'b');
for i=1:size(l_f_points,1)
  plot([l_f_points(i,1), r_f_points(i,1)+size(im_scene,2)], [l_f_points(i,2), r_f_points(i,2)], 'Color', 'g');
end
hold off;
