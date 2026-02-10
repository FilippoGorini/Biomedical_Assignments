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
ylabel("FFT Magnitude");
title("Data1 - Frequency Spectrum (FFT)");
grid on;

% --- Interpretation ---
% The time domain signal shows very fast and irregular fluctuations, with bursts of 
% high amplitude activity separated by quieter periods.
% This behavior is typical of raw EMG (electromyography) data, which captures
% muscle activity.
% EMG signals usually contain high-frequency components about 20–500 Hz,
% this can also be observed by the frequency spectrum of the analyzed signal
% (in particular in our case we have a peak at about 35 Hz, with smaller components all the way up to 400/500 Hz).
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
ylabel("FFT Magnitude");
title("Data2 - Frequency Spectrum (FFT)");
grid on;
legend("Channel 1", "Channel 2");

% --- Interpretation ---
% The signal displays a series of isolated periodic spikes that appear every few seconds on both channels.
% This pattern is typical of motion data, where spikes represent discrete movements.
% The low sampling rate (166 Hz) supports this interpretation.
% Energy is concentrated in low frequencies, below 6 Hz, which is also consistent with motion data.


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

% This signal is not zero mean, therefore we center it to avoid having a
% big spike at 0 Hz in the fft:
x3_centered = x3 - mean(x3);

n_samples = numel(x3_centered);
fourier = fft(x3_centered);
frequencies = linspace(-fs3/2, fs3/2, n_samples);
subplot(2,1,2)
plot(frequencies, fftshift(abs(fourier)));
xlabel("Frequency (Hz)");
ylabel("FFT Magnitude");

% x and y axis limits to better show the relevant frequencies
ylim([0, 15000]); 
xlim([-25, 25]);

title("Data3 - Frequency Spectrum (FFT)");
grid on;

% --- Interpretation ---
% The signal shows slower continuous oscillations with some noise.
% The signal was not zero mean so the offset was removed before doing the
% fft.
% This behavior is characteristic of EEG (electroencephalography) data, 
% representing brain activity.
%  EEG signals generally contain low-frequency components, and in this case, 
% even if not very pronounced, there are some components at about 6 and 10 Hz which is plausible for eeg signals.
% The sampling frequency of 250 Hz also is good for EEG recordings.
