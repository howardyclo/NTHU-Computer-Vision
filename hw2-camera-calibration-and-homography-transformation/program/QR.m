% QR decomposition.
% params A: 3x3 matrix
% return Q: 3x3 orthogonal matrix
% retrun R: 3x3 upper triangular matrix
function [Q, R] = QR(A)
  % column vectors from A
  v1 = A(:,1);
  v2 = A(:,2);
  v3 = A(:,3);
  % perform Gram-Schmidt process, starting from the first column
  u1 = v1;
  u2 = v2 - proj(u1, v2);
  u3 = v3 - proj(u1, v3) - proj(u2, v3);
  % compose Q matrix, each row is orthogonal unit vector
  Q = zeros(3,3);
  Q(:,1) = u1/norm(u1);
  Q(:,2) = u2/norm(u2);
  Q(:,3) = u3/norm(u3);
  % compute R matrix
  R = Q'*A;
end

% orthogonal projection for Gram-Schmidt process
% v projects onto u
function proj_uv = proj(u, v)
  proj_uv = (dot(u, v)/dot(u, u))*u;
end
