function vPoints = grid_points(img,nPointsX,nPointsY,border)
    
[height, width] = size(img);   

x_range = linspace( border+1, width-border, nPointsX );
y_range = linspace( border+1, height-border, nPointsY );
x_range = floor(x_range);  % round to next smallest integer (e.g. 3.47 -> 3)
y_range = floor(y_range);

[X_coord, Y_coord] = meshgrid(x_range,y_range); % X,Y are matrices with size of the grid, containing the x or y coordinates of each grid point

% reshaping coordinate matrices to vectors
X_coord = reshape(X_coord, nPointsX*nPointsY, 1);
Y_coord = reshape(Y_coord, nPointsX*nPointsY, 1);


vPoints = [X_coord, Y_coord];

end
