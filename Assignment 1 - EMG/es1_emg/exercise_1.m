clear
clc

%% LOAD DATA/SET PARAMETERS

data = load("ES1_emg.mat");
% Actual data is contained in the Es1_emg field of the data structure
emg_raw = data.Es1_emg.matrix(:,1); 
% Sampling frequency
Fs = 2000;                          % Sampling frequency (Hz)

%% BANDPASS FILTER (30–450 Hz)
filter_bp = designfilt('bandpassfir', ...       % FIR filter design
    'FilterOrder', 200, ...
    'CutoffFrequency1', 30, ...
    'CutoffFrequency2', 450, ...
    'SampleRate', Fs);
emg_filtered = filtfilt(filter_bp, emg_raw);    % Zero-phase filtering (filtfilt avoids phase delay)

%% RECTIFY SIGNAL
emg_rectified = abs(emg_filtered);

%% LOWPASS TO GET ENVELOPE (4 Hz)
filter_lp = designfilt('lowpassfir', ...
    'FilterOrder', 100, ...
    'CutoffFrequency', 4, ...
    'SampleRate', Fs);

emg_envelope = filtfilt(filter_lp, emg_rectified);

