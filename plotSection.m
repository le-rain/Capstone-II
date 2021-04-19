function [peaks, time] = plotSection(sectionValue, sectionSample, minDist, binOne)

figure
findpeaks(sectionValue, sectionSample, 'MinPeakDistance', minDist, 'MinPeakProminence', binOne);
hold off
xlabel('Sample Number');
ylabel('Relative Sound Amplitude');
ax = gca; 
ax.XAxis.FontSize = 15;
ax.YAxis.FontSize = 15;
ax.FontWeight = 'bold';  

[peaks, time] = findpeaks(sectionValue, sectionSample, 'MinPeakDistance', minDist, 'MinPeakProminence', binOne);

end