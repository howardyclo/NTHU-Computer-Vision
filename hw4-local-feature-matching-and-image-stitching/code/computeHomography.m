% compute projective transformation matrix (3x3) using eigenvector approach
% such that left(homogeneous) = H * right(homogeneous)
function H = computeHomography(left, right)
  % point2D and point3D should be same size
  % compose A matrix (Ap = 0)
  A = [];
  for i=1:size(left, 1)
    x_p = left(i, 1);
    y_p = left(i, 2);
    % corresponding points.
    x = right(i, 1);
    y = right(i, 2);
    A = [...
      A; ...
      x, y, 1, 0, 0, 0, -x_p*x, -x_p*y, -x_p; ...
      0, 0, 0, x, y, 1, -y_p*x, -y_p*y, -y_p, ...
    ];
  end
  % compute eigenvector corresponding smallest eigenvalue from A'A to get camera projection matrix
  [eigvec, eigval] = eig(A'*A);
  [val, index] = min(max(eigval));
  SMeigvec = eigvec(:, index);

  H(1,1:3) = SMeigvec(1:3,1);
  H(2,1:3) = SMeigvec(4:6,1);
  H(3,1:3) = SMeigvec(7:9,1);
end