
%% Constants
clc;
clear all;
fs = 8000;
%% Loading speech files
filename = 'Noise Removal.wav';
[y, fs] = audioread(filename);
Y = transpose(y);

%% Splitting Audio into n parts
num_parts = ceil(length(Y)/40822); % Number of parts to split the audio into
part_length = ceil(length(Y) / num_parts);
audio_parts = cell(1, num_parts);
for i = 1:num_parts
    start_index = (i - 1) * part_length + 1;
    end_index = min(i * part_length, length(Y));
    audio_parts{i} = Y(start_index:end_index);
end

%% Denoise each part separately
denoised_parts = cell(1, num_parts);
for i = 1:num_parts
    % Process each part separately
    part = audio_parts{i};
    if isempty(part)
        continue; % Skip empty parts
    end
    % Splitting the audio further if needed
    duration_len = 160;
    audio_matrix = split_audio(part, duration_len);
    % Frequency matrix generation
    freq_matrix = freq_matrix_gen(audio_matrix);
    % Detecting beeps
    max_freq_array = beep_checker(freq_matrix);
    noise_array = noise_array_gen(max_freq_array);
    % Denoising
    denoised_part = my_notch(part, noise_array);
    % Store denoised part
    denoised_parts{i} = denoised_part;
end

%% Combine denoised parts
output = cat(2, denoised_parts{:});
output = output(1:length(Y)); % Trim to original length

%% Audio player
%sound(output, fs);

%% Audio Splitting
function audio_matrix = split_audio(audio, no_col)
    len = length(audio);
    if len == 0
        audio_matrix = [];
        return;
    end
    r = mod(len, no_col);
    audio = [audio , zeros(1, no_col - r)];
    len = length(audio);
    no_rows = len / no_col;
    audio_matrix = zeros(no_rows, no_col);
    for i = 1:no_rows
       audio_matrix(i,:)  = audio((i - 1) * no_col + 1 : i * no_col);
    end
end

%% FFT
function mag_fft_sample = my_fft(audio)
    num_fft = 1024; 
    fft_sample = fft(audio, num_fft);
    mag_fft_sample = (abs(fft_sample(1 : num_fft / 2 + 1)));
end

%% Frequency matrix generation
function freq_matrix = freq_matrix_gen(audio_matrix)
    num_fft = 1024;
    [rows, ~] = size(audio_matrix);
    freq_matrix = zeros(rows, num_fft / 2 + 1);
    for i = 1:rows
        freq_matrix(i,:) = my_fft(audio_matrix(i,:));
    end
end

%% Beep checker
function max_freq_array = beep_checker(freq_matrix)
    [~, max_freq_array] = max(freq_matrix, [], 2);
end

%% Noise frequency detector
function noise_array = noise_array_gen(max_freq_array)
    noise_array = find_repeated_element(max_freq_array, 6);
end

function repeated_element = find_repeated_element(array, consecutive_count)
    n = length(array);
    j = 0;
    repeated_element1 = [];
    for i = consecutive_count : n
        if all(array((i - consecutive_count+1):i) == array(i - consecutive_count+1))
            j = j + 1;
            repeated_element1(j) = array(i);
            i = i + consecutive_count+1;
        end
    end
    repeated_element = unique(repeated_element1);
end

%% Denoising function
function output = my_notch(audio, noise_array)
    output = audio;
    for i = 1:length(noise_array)
        W0 = noise_array(i) / 512;
        spread = 0.009;
        Wn = [W0 - spread, W0 + spread];
        [b, a] = butter(4, Wn, 'stop');
        output = filter(b, a, output);
    end
end