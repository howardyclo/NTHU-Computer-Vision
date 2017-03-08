function visualizeCamera( point3D, R1, t1, R2, t2 )

% Get Camera Pose and Camera Position
% camera pose is row vector
cameraPoseVector1 = [0, 0, 1] * R1;
cameraPoseVector1 = cameraPoseVector1 / norm(cameraPoseVector1);
cameraPoseVector2 = [0, 0, 1] * R2;
cameraPoseVector2 = cameraPoseVector2 / norm(cameraPoseVector2);
% camera position is row vector , please compute your matrix here
cameraPosition1 = (-inv(R1)*t1)';
cameraPosition2 = (-inv(R2)*t2)';
angle = acosd(dot(cameraPoseVector1, cameraPoseVector2));

%% Draw Chessboard
largeDarkFigure();
view(60,35);
hold on;

for rowI = 1 : 11 %12-1
	for colI = 1 : 8 %9-1

		% Clockwizely Traverse 4 corners of a Square; Concatenate their XYZ
		fourCornerXYZ = [...
			point3D( rowI*9 + colI - 9       , : ) ;...
			point3D( rowI*9 + colI - 9 + 1, : ) ;...
			point3D( rowI*9 + colI - 9 + 10, : ) ;...
			point3D( rowI*9 + colI - 9 + 9, : ) ;...
		];

		X = fourCornerXYZ(:,1) ;
		Y = fourCornerXYZ(:,2) ;
		Z = fourCornerXYZ(:,3) ;

		if mod(rowI,2) == mod(colI,2)
			thisColor = 'black';
		else
			thisColor = 'white';
		end

		fill3(Z,X,Y,thisColor);

	end
end

%% Draw Camera 1
cameraColor = [ 0.6, 0.4, 1 ] ;
draw_camera(R1, cameraPosition1, cameraColor);

%% Draw Camera 2
cameraColor = [ 0.4, 0.6, 1 ] ;
draw_camera(R2, cameraPosition2, cameraColor);

%%
xlabel( 'Z', 'FontName', 'Arial', 'FontSize', 18 );
ylabel( 'X', 'FontName', 'Arial', 'FontSize', 18 );
zlabel( 'Y', 'FontName', 'Arial', 'FontSize', 18 );
%set(gca, 'xdir', 'reverse');
%set(gca, 'ydir', 'reverse');
%set(gca, 'zdir', 'reverse');

hold off;
end

function draw_camera(R, cameraPosition, cameraColor)
	leftTopCorner = [ -0.2, 0.2, -1 ] * R ;
	leftTopCorner = leftTopCorner / norm(leftTopCorner)*4 + cameraPosition ;

	leftBotCorner = [ -0.2, -0.2, -1 ] * R ;
	leftBotCorner = leftBotCorner / norm(leftBotCorner)*4 + cameraPosition ;

	rightTopCorner = [ 0.2, 0.2, -1 ] * R ;
	rightTopCorner = rightTopCorner / norm(rightTopCorner)*4 + cameraPosition ;

	rightBotCorner = [ 0.2, -0.2, -1 ] * R ;
	rightBotCorner = rightBotCorner / norm(rightBotCorner)*4 + cameraPosition ;

	leftTriangle = [ cameraPosition ; leftTopCorner ; leftBotCorner ] ;
	topTriangle = [ cameraPosition ; leftTopCorner ; rightTopCorner ] ;
	rightTriangle = [ cameraPosition ; rightTopCorner ; rightBotCorner ] ;
	botTriangle = [ cameraPosition ; leftBotCorner ; rightBotCorner ] ;

	fill3( leftTriangle(:,3), leftTriangle(:,1), leftTriangle(:,2), cameraColor );
	fill3( topTriangle(:,3), topTriangle(:,1), topTriangle(:,2), cameraColor );
	fill3( rightTriangle(:,3), rightTriangle(:,1), rightTriangle(:,2), cameraColor );
	fill3( botTriangle(:,3), botTriangle(:,1), botTriangle(:,2), cameraColor );
end
