function generateScalpPlots(PSD, scalpPlotDatapath, imgPath, PSD_limits_fallback)

% Call plot_scalp 
graphics_toolkit gnuplot
h = figure('Visible', 'off');
plot_scalp(PSD, scalpPlotDatapath, PSD_limits_fallback)

% Save the resulting figure
print(h, strcat(imgPath,'/scalpplot.png'));
print(h, strcat('scalpplot.png'));
  
close all;

end