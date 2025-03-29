clc; clear; close all;

% Sampling parameters
Fs = 8000;  
note_duration = 0.5;  
gap = 0.05;  
t = 0:1/Fs:note_duration;  

% Lower frequencies for Sa Re Ga Ma (scaled down version of actual notes)
f = [1300, 1460, 1640, 1740, 1960, 2200, 2460, 2610]; % Hz

% Generate tune
tune = [];
for i = 1:length(f)
    tune = [tune, sin(2*pi*f(i)*t), zeros(1, round(Fs * gap))]; 
end

% Normalize and play tune
tune = tune / max(abs(tune));
sound(tune, Fs);

% Compute and plot FFT
N = length(tune);
X_f = abs(fft(tune)/N);
freq = (0:N/2-1) * (Fs/N);

plot(freq, X_f(1:N/2), 'r', 'LineWidth', 1.5);
xlabel('Frequency (Hz)'); ylabel('Magnitude');
title('Frequency Spectrum of the Tune');
xlim([0 3000]); % Adjusted to show relevant frequencies
grid on;
