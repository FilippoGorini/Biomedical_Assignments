clc; clear; close all;

%% Load the datasets
data1 = load("Data_Assignment_0/data1.mat");
data2 = load("Data_Assignment_0/data2.mat");
data3 = load("Data_Assignment_0/data3.mat");

% Sampling frequencies (Hz)
fs1 = 2000;
fs2 = 166;
fs3 = 250;

%% ---------------- First dataset ----------------
figure(1)

% ---- Time domain ----
x1 = data1.data1;
t1 = (0:length(x1)-1)/fs1;
subplot(2,1,1)
plot(t1, x1)
xlabel("Time (s)");
ylabel("Amplitude");
title("Data1 - Time domain");
grid on;

% ---- Frequency domain (FFT) ----
n_samples = numel(x1);
fourier = fft(x1);
frequencies = linspace(-fs1/2, fs1/2, n_samples);
subplot(2,1,2)
plot(frequencies, fftshift(abs(fourier)));
xlabel("Frequency (Hz)");
ylabel("|Amplitude|");
title("Data1 - Frequency Spectrum (FFT)");
grid on;

% --- Interpretation ---
% The signal shows very fast and irregular fluctuations, with bursts of 
% high amplitude activity separated by quieter periods.
% This behavior is typical of EMG (electromyography) data, which captures
% muscle activity.
% EMG signals usually contain high-frequency components about 20–500 Hz,
% this can also be observed by the frequency spectrum of the analyzed signal.
% The high sampling rate (2000 Hz) is consistent with this signal type.


%% ---------------- Second dataset ----------------
figure(2)

% ---- Time domain ----
x2 = data2.data2;
t2 = (0:length(x2)-1)/fs2;
subplot(2,1,1)
plot(t2, x2)
xlabel("Time (s)");
ylabel("Amplitude");
title("Data2 - Time domain");
grid on;

% ---- Frequency domain (FFT) ----
n_samples = size(x2, 2);
fourier1 = fft(x2(1,:));
fourier2 = fft(x2(2,:));
frequencies = linspace(-fs2/2, fs2/2, n_samples);

subplot(2,1,2)
plot(frequencies, fftshift(abs(fourier1)));
hold on;
plot(frequencies, fftshift(abs(fourier2)));
hold off;
xlabel("Frequency (Hz)");
ylabel("|Amplitude|");
title("Data2 - Frequency Spectrum (FFT)");
grid on;
legend("Channel 1", "Channel 2");

% --- Interpretation ---
% The signal displays a series of isolated periodic spikes that appear every few seconds.
% This pattern is typical of motion data, where spikes represent discrete movements (e.g., steps).
% The low sampling rate (166 Hz) supports this interpretation.
% Energy is concentrated in low frequencies, between around -6 Hz and 6 Hz, consistent with motion data.


%% ---------------- Third dataset ----------------
figure(3)

% ---- Time domain ----
x3 = data3.data3;
t3 = (0:length(x3)-1)/fs3;
subplot(2,1,1)
plot(t3, x3)
xlabel("Time (s)");
ylabel("Amplitude");
title("Data3 - Time domain");
grid on;

% ---- Frequency domain (FFT) ----
n_samples = numel(x3);
fourier = fft(x3);
frequencies = linspace(-fs3/2, fs3/2, n_samples);
subplot(2,1,2)
plot(frequencies, fftshift(abs(fourier)));
xlabel("Frequency (Hz)");
ylabel("|Amplitude|");
title("Data3 - Frequency Spectrum (FFT)");
grid on;

% --- Interpretation ---
% The signal shows slow, continuous oscillations without sharp spikes.
% The amplitude changes gradually.
% This behavior is characteristic of EEG (electroencephalography) data, 
% representing brain activity.
%  EEG signals generally contain low-frequency components, in this case
% mostly between -0.01 Hz and 0.01 Hz.
% The sampling frequency of 250 Hz is standard for EEG recordings.
