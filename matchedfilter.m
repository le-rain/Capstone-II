waveform = phased.LinearFMWaveform('PulseWidth',1e-4,'PRF',5e3);
x = waveform();
filter = phased.MatchedFilter('Coefficients',getMatchedFilter(waveform));
y = filter(x);
subplot(2,1,1)
plot(real(x))
xlabel('Samples')
ylabel('Amplitude')
title('Input Signal')
subplot(2,1,2)
plot(real(y))
xlabel('Samples')
ylabel('Amplitude')
title('Matched Filter Output')