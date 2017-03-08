% use bilinear interpolation to get right image region's new pixel
% value in the position of left image region.
function img_new = backwardWrap(img, img_new, projected_points, target_points)
    for i=1:size(target_points,1)
        x = projected_points(i,1);
        y = projected_points(i,2);
        target_x = target_points(i,1);
        target_y = target_points(i,2);
        % calculate weights
        w = ceil(x) - floor(x);
        h = ceil(y) - floor(y);
        left_weight = (ceil(x) - x)/w;
        right_weight = (x - floor(x))/w;
        up_weight = (ceil(y) - y)/h;
        bottom_weight = (y - floor(y))/h;
        % interpolate color. color = img(y,x) <=> y=row, x=col
        top_left_color = img(floor(y), floor(x), :);
        top_right_color = img(floor(y), ceil(x), :);
        bottom_left_color = img(ceil(y), floor(x), :);
        bottom_right_color = img(ceil(y), ceil(x), :);
        up_weighted_color = left_weight*top_left_color + right_weight*top_right_color;
        bottom_weighted_color = left_weight*bottom_left_color + right_weight*bottom_right_color;
        target_color = up_weight*up_weighted_color + bottom_weight*bottom_weighted_color;
        % assign color to target pixel
        if img_new(target_y, target_x, 1) == 0 && img_new(target_y, target_x, 2) == 0 && img_new(target_y, target_x, 3) == 0
          img_new(target_y, target_x, :) = target_color;
        else
          % alpha blending
          img_new(target_y, target_x, :) = 0.5*img_new(target_y, target_x, :) + 0.5*target_color;
        end
    end
end
