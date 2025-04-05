function s = generateSignal(base, step, N, t)
	s = 0;
	for n = 1:N
		s = s + (1/n)*sin((base + step*(n-1))*2*pi*t);
	end
end

Fs = 48000;
Ts = 1/Fs;
dur = 0.1;

t = linspace(0, dur, dur*Fs);

L = length(t);
n = 2^nextpow2(L);

f = linspace(0, Fs/2, n/2);

Hd = myFilter();

signal = generateSignal(440, 650, 10, t);
X = abs(fft(signal, n));

filteredSignal = filtfilt(Hd.Numerator, 1, signal);
Y = abs(fft(filteredSignal, n));

figure(1);
subplot(2,1,1)
plot(t,signal)
title('Original Signal');
xlabel('time [s]'); ylabel('magnitude');
xlim([0,0.02]);

subplot(2,1,2)
plot(t,filteredSignal)
title('Filtered Signal');
xlabel('time [s]'); ylabel('magnitude');
xlim([0,0.02]);

figure(2);
subplot(2,1,1)
plot(f,X(1:n/2))
title('Original Signal FFT');
xlabel('frequency [Hz]'); ylabel('magnitude');

subplot(2,1,2)
plot(f,Y(1:n/2))
title('Filtered Signal');
xlabel('frequency [Hz]'); ylabel('magnitude');

[data, Fs] = audioread("hello.mp3");

t = linspace(0, (1/Fs)*length(data), length(data));
L = length(t);
n = 2^nextpow2(L);

f = linspace(0, Fs/2, n/2);
Z = abs(fft(data, n));

filteredAudio = filtfilt(Hd.Numerator, 1, data);
W = abs(fft(filteredAudio, n));

figure(3);
subplot(2,1,1)
plot(t,data)
title('Original Audio');
xlabel('time [s]'); ylabel('magnitude');

subplot(2,1,2)
plot(t,filteredAudio)
title('Filtered Audio');
xlabel('time [s]'); ylabel('magnitude');

figure(4);
subplot(2,1,1)
plot(f,Z(1:n/2))
title('Original Audio FFT');
xlabel('frequency [Hz]'); ylabel('magnitude');

subplot(2,1,2)
plot(f,W(1:n/2))
title('Filtered Audio');
xlabel('frequency [Hz]'); ylabel('magnitude');

sound(data, Fs);
sound(filteredAudio, Fs);
