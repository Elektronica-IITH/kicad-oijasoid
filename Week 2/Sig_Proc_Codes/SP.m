clear; clc; close all;

% Load the MP3 file
[file, fs] = audioread('Shape_of_You.mp3');

duration = 16; 
samples = fs * duration;
file = file(1:samples, :); 

% Play original audio
disp('Playing original audio...');
sound(file, fs);
pause(duration + 1);

% Time-reversed (Reverse the audio)
rev_file = flipud(file);
disp('Playing reversed audio...');
sound(rev_file, fs);
pause(duration + 1);

% Speed-up (Double speed)
disp('Playing fast version (double speed)...');
sound(file, 2 * fs);
pause(duration / 2 + 1);

% Low-pass filter (Remove high frequencies)
fc = 700; % Cut-off frequency at 1kHz
[b, a] = butter(6, fc / (fs / 2), 'low');
low_pass_file = filter(b, a, file);
disp('Playing low-pass filtered audio...');
sound(low_pass_file, fs);
pause(duration + 1);

% Build on Echo: Adding Reverb
delay = round(0.01 * fs); % 300 ms delay
echo_file = file;
echo_file(delay+1:end, :) = echo_file(delay+1:end, :) + 0.6 * file(1:end-delay, :);
reverb_file = filter([1 zeros(1, fs*0.1) 0.6], 1, echo_file);
disp('Playing with echo and  reverb effect...');
sound(reverb_file, fs);
pause(duration + 1);

