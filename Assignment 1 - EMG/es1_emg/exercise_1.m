%% ANSWERS 
% Question A:
% Down-sampling is performed after the computation of the envelope because
% high sampling rates (e.g., 2000 Hz) are unnecessary once the envelope has
% been computed. This has the benefit of reducing data size while
% preserving the meaningful envelope shape.

% Question B:
% If we compare the envelope and the accelerometer signal we can see that 
% the activation usually precedes visible changes in the acceleration by
% some hundreds of milliseconds, indicating that the muscle is activated
% slightly earlier than when the motion starts.


%% LOAD DATA/SET PARAMETERS
clear
clc

data = load("ES1_emg.mat");
% Actual data is contained in the Es1_emg field of the data structure
emg_raw = data.Es1_emg.matrix(:,1); % EMG Signal

% Load the 3 raw accelerometer axes
ax_x = data.Es1_emg.matrix(:,2);
ax_y = data.Es1_emg.matrix(:,3);
ax_z = data.Es1_emg.matrix(:,4);

Fs = 2000;                          % Sampling frequency (Hz)

%% BANDPASS FILTER (30–450 Hz)
filter_bp = designfilt('bandpassfir', ...      
    'FilterOrder', 200, ...
    'CutoffFrequency1', 30, ...
    'CutoffFrequency2', 450, ...
    'SampleRate', Fs);
emg_filtered = filtfilt(filter_bp, emg_raw);  

%% RECTIFY SIGNAL
emg_rectified = abs(emg_filtered);

%% LOWPASS TO GET ENVELOPE (4 Hz)
filter_lp = designfilt('lowpassfir', ...
    'FilterOrder', 100, ...
    'CutoffFrequency', 4, ...
    'SampleRate', Fs);
emg_envelope = filtfilt(filter_lp, emg_rectified);

%% DOWNSAMPLING
% We chose to downsample to 1000 Hz assuming that the highest frequency of
% our interest is 500 Hz, like it is common for emg data. 
new_Fs = 1000; % New sampling frequency (Hz)
downsample_factor = Fs / new_Fs;
emg_downsampled = downsample(emg_envelope, downsample_factor);

%% VISUALIZE RESULTS
N_raw = length(emg_raw);
% Time vector for original signals
t_raw = (0:N_raw-1) / Fs;

figure('Name', 'EMG Processing & Raw Accelerometer Comparison', 'Position', [100, 100, 900, 700]);

tl = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

title(tl, 'Deltoid Muscle EMG & Raw Accelerometer Analysis', 'FontSize', 14, 'FontWeight', 'bold');

% Plot Raw EMG signal overlaid with the filtered signal
ax1 = nexttile;
plot(t_raw, emg_raw, 'Color', "r");
hold on; 
plot(t_raw, emg_filtered, 'Color', [0.27 0.49 0.77]); 
hold off;
title('1. Raw vs. Filtered Signal (Bandpass 30-450 Hz)');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
legend('Raw EMG', 'Filtered EMG', 'Location', 'northeast');
grid on;

% Plot Rectified EMG signal overlaid with the envelope
ax2 = nexttile;
plot(t_raw, emg_rectified, 'Color', [0.75 0.75 0.75]); % Rectified in light gray
hold on;
plot(t_raw, emg_envelope, 'r', 'LineWidth', 2); % Envelope in thick red
hold off;
title('2. Rectified Signal & Linear Envelope (Lowpass 4 Hz)');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
legend('Rectified EMG', 'EMG Envelope', 'Location', 'northeast');
grid on;

% Plot EMG Envelope signal overlaid with 3 Raw Accel Axes 
ax3 = nexttile;

yyaxis left;
plot(t_raw, ax_x, '-', 'LineWidth', 1.2, 'Color', [0.27 0.49 0.77]);
hold on;
plot(t_raw, ax_y, '-', 'LineWidth', 1.2, 'Color', [0.93 0.69 0.13]);
plot(t_raw, ax_z, '-', 'LineWidth', 1.2, 'Color', [0.47 0.67 0.19]);
ylabel('Raw Accel. (g)');

yyaxis right;
plot(t_raw, emg_envelope, '-', 'Color', "r", 'LineWidth', 2); 
ylabel('EMG Envelope (mV)');

title('3. EMG Envelope vs. Raw Accelerometer Axes');
xlabel('Time (s)');
grid on;
legend('Accel X', 'Accel Y', 'Accel Z', 'EMG Envelope', 'Location', 'northeast');

set(gca, 'FontSize', 10);
box off;
hold off;
