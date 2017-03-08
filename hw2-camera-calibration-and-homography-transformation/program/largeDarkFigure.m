function darkHandle = largeDarkFigure()

darkHandle = figure( 'units','normalized', 'outerposition',[0 0.04 1 0.96] ); %Big Window
set(gcf,'color',[0.4 0.4 0.4]); 
whitebg([0.3 0.3 0.3]); 

set(gca, 'FontSize', 14, 'FontName', 'Futura LT Book');

end
