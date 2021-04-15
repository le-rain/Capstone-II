function [peaks, time] = plotSection(sectionValue, Fs, minDist, binOne)

figure
findpeaks(sectionValue, Fs, 'MinPeakDistance', minDist, 'MinPeakProminence', binOne);
xlabel('Time (s)');
ylabel('Relative Sound Amplitude');
ax = gca; 
ax.XAxis.FontSize = 15;
ax.YAxis.FontSize = 15;
ax.FontWeight = 'bold';  

[peaks, time] = findpeaks(sectionValue, Fs, 'MinPeakDistance', minDist, 'MinPeakProminence', binOne);

end