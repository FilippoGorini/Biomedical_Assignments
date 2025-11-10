%% === EMG FILTER DESIGN SCRIPT ===
% Questo script calcola i coefficienti per:
% - Notch (50 Hz)
% - Bandpass (30-450 Hz)
% - Lowpass (1 Hz)
% Da usare in blocchi "Discrete Filter" Simulink

clear; clc; close all;

%% === PARAMETRI BASE ===
Fs = 1000;     % Frequenza di campionamento [Hz]
Ts = 1/Fs;     % Sample time [s]

%% === 1. NOTCH FILTER (50 Hz) ===
f0 = 50;       % Frequenza del notch [Hz]
Q = 40;        % Fattore di qualità (più alto = notch più stretto)
BW = f0 / Q;

d_notch = designfilt('bandstopiir', ...
    'FilterOrder', 2, ...
    'HalfPowerFrequency1', f0 - BW/2, ...
    'HalfPowerFrequency2', f0 + BW/2, ...
    'DesignMethod', 'butter', ...
    'SampleRate', Fs);

[b_notch, a_notch] = tf(d_notch);

%% === 2. BANDPASS FILTER (30–450 Hz) ===
d_band = designfilt('bandpassiir', ...
    'FilterOrder', 4, ...                   % ordine medio, stabile
    'HalfPowerFrequency1', 30, ...
    'HalfPowerFrequency2', 450, ...
    'DesignMethod', 'butter', ...
    'SampleRate', Fs);

[b_band, a_band] = tf(d_band);

%% === 3. LOWPASS FILTER (1 Hz) ===
d_low = designfilt('lowpassiir', ...
    'FilterOrder', 4, ...
    'HalfPowerFrequency', 0.8, ...
    'DesignMethod', 'butter', ...
    'SampleRate', Fs);

[b_low, a_low] = tf(d_low);

%% === 4. Avarage Filter ===

N = 20;

%% === 5. LOWPASS AFTER DIVISION

Fs_control = 1000;
%frequenza di taglio
%   - Per più smoothing (cursore più "pigro"): abbassa la frequenza (es. 0.8 Hz)
%   - Per meno smoothing (cursore più "reattivo"): alza la frequenza (es. 3 Hz)
f_cutoff = 0.5; % Frequenza di taglio in Hz

d_lowpass = designfilt('lowpassiir', ...
    'FilterOrder', 2, ...                 % Ordine del filtro (1 o 2 sono buoni per il controllo)
    'HalfPowerFrequency', f_cutoff, ...   % Frequenza di taglio
    'DesignMethod', 'butter', ...         % Metodo di design Butterworth
    'SampleRate', Fs_control);            % Frequenza di campionamento

[b_low2, a_low2] = tf(d_lowpass);

%% === ESPORTA IN WORKSPACE ===
assignin('base','b_notch',b_notch);
assignin('base','a_notch',a_notch);
assignin('base','b_band',b_band);
assignin('base','a_band',a_band);
assignin('base','b_low',b_low);
assignin('base','a_low',a_low);
assignin('base','Ts',Ts);

disp('✅ Tutti i coefficienti sono pronti nel workspace!');
