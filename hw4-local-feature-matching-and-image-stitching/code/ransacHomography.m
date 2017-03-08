function [H, inlier_indexs, outlier_indexs] = ransacHomography(l_f_points, r_f_points, inlier_distance_threshold, max_iteration)
  % Perform ransac
  iteration = 1;
  inlier_min_size = round(size(l_f_points, 1) * 0.2);
  inlier_indexs = [];
  while iteration < max_iteration
    % Randomly select a seed group of points on which to base transformation estimate (e.g., a group of matches)
    % In this case, we want to compute homography, so we select min number of 4 pairs of matches as seed points.
    rand_indexs = randi(size(l_f_points,1), [1,4]);
    left = l_f_points(rand_indexs,:);
    right = r_f_points(rand_indexs,:);

    % Compute transformation from seed group
    H = computeHomography(left, right);

    % Compute projected points
    left = l_f_points;
    right = r_f_points;
    right(:,3) = 1;
    proj_left = (H * right')';
    proj_left(:,1) = proj_left(:,1) ./ proj_left(:,3);
    proj_left(:,2) = proj_left(:,2) ./ proj_left(:,3);
    proj_left(:,3) = 1;

    % Find sufficiently large numbers of inliers
    % for distance(projected point, target points) < inlier_distance_threshold
    mat_error = left - proj_left(:, 1:2);
    vec_dist = sum(mat_error.^2, 2);
    tmp_inlier_indexs = find(vec_dist < inlier_distance_threshold);

    if size(tmp_inlier_indexs, 1) > size(inlier_indexs, 1)
      inlier_indexs = tmp_inlier_indexs;
    end

    iteration = iteration + 1;

    % Check if we have sufficiently large numbers of inliers,
    % if not, re-run ransac for <max_iteration> times.
    if iteration == max_iteration && size(inlier_indexs, 1) < inlier_min_size
      size(inlier_indexs, 1)
      iteration = 1;
    end
  end

  % Re-compute H on all of the inliers
  left = l_f_points(inlier_indexs,:);
  right = r_f_points(inlier_indexs,:);
  H = computeHomography(left, right);

  % Compute outlier indexs
  outlier_indexs = 1:size(l_f_points,1);
  outlier_indexs(inlier_indexs) = [];
end
