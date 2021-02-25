ppg009 = signal.pleth.y;
ecg009 = signal.ecg.y;

[pksppg, locsppg] = findpeaks(ppg009, 'MinPeakDistance', 140);
[pksecg, locsecg] = findpeaks(ecg009, 'MinPeakDistance', 140);

record_time = length(ppg009);
tm = [1:record_time];
tm = tm';

figure (1)
plot (tm, ppg009, tm(locsppg), pksppg, 'or')


figure (2)
plot (tm, ecg009, tm(locsecg), pksecg, 'or')

peaks_count_ppg = length(locsppg);
peaks_count_ecg = length(locsecg);

if (peaks_count_ppg < peaks_count_ecg)
    n = 1;
    while (n < peaks_count_ppg)
        if (locsppg(n) - locsecg(n) <140)
            peak_pair_ppg(n) = locsppg(n);
            peak_pair_ecg(n) = locsecg(n);
        n = n+1;
        end
    end
else
    n = 1;
    while (n < peaks_count_ecg)
        if (locsppg(n) - locsecg(n) < 140)
            peak_pair_ppg(n) = locsppg(n);
            peak_pair_ecg(n) = locsecg(n);
        n = n+1;
        end
    end
end

delay = peak_pair_ppg - peak_pair_ecg;
average_delay = mean(delay);
PTT = average_delay *(1000/300)

