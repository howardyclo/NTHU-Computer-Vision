function [l_f_points, r_f_points] = find_matches(l_img, r_img, dist_ratio_threshold)

  if exist('vl_sift') == 0
    %% Setup VLFeat toolbox
    run('~/Desktop/vlfeat-0.9.20/toolbox/vl_setup.m')
  end

  %% Get SIFT frames(keypoint(x,y), scale, orientation) and descriptors
  [l_f, l_d] = vl_sift(single(rgb2gray(l_img)));
  [r_f, r_d] = vl_sift(single(rgb2gray(r_img)));

  l_f = l_f';
  l_d = l_d';
  r_f = r_f';
  r_d = r_d';

  %% Find closest discriptor as measured L2 norm
  vec_matches = zeros(size(l_d,1), 1);
  for i=1:size(l_d, 1)
    % Compute distances bewteen descriptor(l_d, i) and descriptor(r_d, 1.....size(r_d))
    mat_error = repmat(l_d(i,:), [size(r_d,1), 1]) - r_d;
    vec_dist = sum(mat_error.^2, 2);
    [vec_dist, vec_index] = sort(vec_dist, 'ascend');
    % The distance of the min distance and the second min distance
    % between SIFT descriptor should be large enough
    if (vec_dist(2) - vec_dist(1)) > (vec_dist(1) * dist_ratio_threshold)
      vec_matches(i) = vec_index(1);
    end
  end

  %% Get match point positions
  l_f_indexs = find(vec_matches ~= 0);
  r_f_indexs = vec_matches(l_f_indexs);
  l_f_points = l_f(l_f_indexs, 1:2);
  r_f_points = r_f(r_f_indexs, 1:2);
end
