function visualize_checkerboard_corners (P, IMG_NAME)

XYZ_corners = [];
spacing = 0.027;% *1000; % if coordinates entered in mm
x_dim = 7; %tile dimension in x
y_dim = 6; %tile dimension in y
z_dim = 9; %tile dimension in z

for i=0:x_dim
    for j=0:z_dim
        corner = [i*spacing; 0; j*spacing];
        XYZ_corners = [XYZ_corners, corner];
    end
end
for j=0:z_dim
    for k=1:y_dim
        corner = [0; k*spacing; j*spacing];
        XYZ_corners = [XYZ_corners, corner];
    end
end

% Apply projection matrix P
XYZ_homogeneous=homogenization(XYZ_corners);
xyz_projected=P*XYZ_homogeneous;

% Compute Inhomogeneous projected points 
NB_PTS=size(XYZ_corners,2);
xy_projected=zeros(2,NB_PTS);
for i=1:NB_PTS
    xy_projected(1,i)=xyz_projected(1,i)./xyz_projected(3,i); % compute inhomogeneous coordinates x=x/z 
    xy_projected(2,i)=xyz_projected(2,i)./xyz_projected(3,i); % compute inhomogeneous coordinates y=y/z 
end

% Display on the calibration image
figure();
img = imread(IMG_NAME);
image(img);
hold on;
for n=1:NB_PTS
    plot(xy_projected(1,n), xy_projected(2,n), 'ro', 'MarkerSize', 10) % reprojected points
end
hold off;

end