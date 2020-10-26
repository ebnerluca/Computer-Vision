% Compute the distance for pairs of points and lines
% Input
%   points    Homogeneous 2D points 3xN
%   lines     2D homogeneous line equation 3xN
% 
% Output
%   d         Distances from each point to the corresponding line N
function d = distPointsLines(points, lines)

%line = [a, b, c], where ax + by + c = 0
%distance between a point and a line is (ax + by + c)/sqrt(a^2 + b^2)
d = abs(lines(1,:).*points(1,:) + lines(2,:).*points(2,:) + lines(3,:)) ./ sqrt(lines(1,:).^2 + lines(2,:).^2);

end

