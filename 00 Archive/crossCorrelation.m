template = readmatrix('ppg_template.csv');
Fs_template = 300;

Fs_ppg = framerate;

[p,q] = rat(Fs_ppg/Fs_template);
template_resampled = resample(template,p,q);

[c,lag] = xcorr(template,phone_ppg{1});
