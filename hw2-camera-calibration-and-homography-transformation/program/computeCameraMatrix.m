% compute camera projection matrix (3x4) using eigenvector approach
function P = computeCameraMatrix(point2D, point3D)
  % point2D and point3D should be same size
  % compose A matrix (Ap = 0)
  A = [];
  for i=1:size(point2D, 1)
    % image plane coord.
    x = point2D(i, 1);
    y = point2D(i, 2);
    % corresponding world coord.
    X = point3D(i, 1);
    Y = point3D(i, 2);
    Z = point3D(i, 3);
    A = [...
      A; ...
      X, Y, Z, 1, 0, 0, 0, 0, -x*X, -x*Y, -x*Z, -x; ...
      0, 0, 0, 0, X, Y, Z, 1, -y*X, -y*Y, -y*Z, -y  ...
    ];
  end
  % compute eigenvector corresponding smallest eigenvalue from A'A to get camera projection matrix
  ATA = A'*A;
  [SMeigvec, SMeigval] = eigs(ATA, 1, 'SM');
  P = [ ...
        SMeigvec(1), SMeigvec(2), SMeigvec(3), SMeigvec(4);   ...
        SMeigvec(5), SMeigvec(6), SMeigvec(7), SMeigvec(8);   ...
        SMeigvec(9), SMeigvec(10), SMeigvec(11), SMeigvec(12) ...
  ];
end
