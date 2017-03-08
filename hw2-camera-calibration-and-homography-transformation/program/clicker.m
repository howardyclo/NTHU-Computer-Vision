% �ٮ�aClicker
function [ point3D, point2D ] = clicker( imagePath )

chessboardImage = imread(imagePath) ;

thisWindow = largeDarkFigure();
imshow(chessboardImage);

hold on;

xlabel ('Locate(Click) 108 points (Left to Right and Up to Down) along the outline', 'FontName', 'Arial', 'FontSize', 18);

% 12 rows, 9 columns, X Y Z
point3D = zeros(12,9,3);

% 12 rows, 9 columns, x y
point2D = zeros(12,9,2);

for columnI = 1 : 9
	for rowI = 1 : 7
		point3D( rowI, columnI, : ) = [ columnI-1, 7-rowI, 0 ] ;
	end
	for rowI = 8 : 12
		point3D( rowI, columnI, : ) = [ columnI-1, 0, rowI-7 ] ;
	end
end

for rowI = 1 : 12
	for columnI = 1 : 9
		coord3DString = sprintf( '( %d, %d, %d )', point3D(rowI,columnI,1), point3D(rowI,columnI,2), point3D(rowI,columnI,3) );
		nowClickingString = sprintf( 'You are Clicking %s',  coord3DString );
		title( nowClickingString, 'FontName', 'Arial', 'FontSize', 18 );

		[ clickX, clickY ] = ginput(1);
		scatter( clickX, clickY, 100, 'lineWidth', 4 );
		text ( clickX, clickY-12, coord3DString, 'Color', [1 1 1], 'BackgroundColor', [.3 .3 .3], 'FontName', 'Arial', 'FontSize',8 );
		drawnow;

		point2D( rowI, columnI, : ) = [ clickX, clickY ] ;
	end
end

close(thisWindow);

point3D = reshape( permute(point3D, [2 1 3]), [108 3] );
point2D = reshape( permute(point2D, [2 1 3]), [108 2] );

save('points2D3D','point2D','point3D');
end
