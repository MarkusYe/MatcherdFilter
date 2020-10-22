clc;close all;clear;
%% CW signal source 
A = 5;
f = 10e3;
omega = 2*pi*f;
Phi = 0;%pi/3;
FS = 80e3;
Delta_T = 1/FS;
NFFT = FS;
T = 5e-3;
t1 = (1:T/Delta_T)*Delta_T;
signal_1 = A * exp(1i*(omega*t1+Phi));
t = t1;
Signal_source_time = signal_1;
figure;plot(t,real(Signal_source_time));
xlabel('t/s');ylabel('Amplitude/V');
title('Signal source')
Signal_source_Freq = fft(Signal_source_time,NFFT) * 2 / NFFT;
Fn=(0:NFFT-1) * NFFT / FS;
figure;plot(Fn,abs(Signal_source_Freq));
Signal_Power = Signal_source_time*Signal_source_time'/length(Signal_source_time);%单位:W

%% Transport Channel 
% h_Amplitude_1 = 0.7;
% h_Amplitude_2 = 0.5;
% h_Amplitude_3 = 0.35;
h_Amplitude = [0.9 -0.25 0.7 0.5 -0.15 0.35];%0.6;%[0.5 0.3];%
h_Timedelay = [0.2e-2 0.6e-2 0.75e-2,1e-2 1.1e-2 1.35e-2];%2e-2;%[0.3e-2 2e-2];
channel_time = 3e-2;
[CohenChannel,CohenChannel_time] = CohenChannel(FS,channel_time, h_Amplitude, h_Timedelay);
figure;plot(CohenChannel_time,CohenChannel);
% h_Timedelay_1 = 1e-2;
% h_Timedelay_2 = 2.2e-2;
% h_Timedelay_3 = 3.6e-2;
% R = 9e6;
% c= 3e8;
% h_Timedelay = R / c;
Signal_channel_time = conv(Signal_source_time,CohenChannel);
t_channel = (1:length(Signal_channel_time))*Delta_T;
figure;plot(t_channel,real(Signal_channel_time));
Noise_Power = 20;%单位:W
Channel_num = 1;
Noise_Gaussian = wgn(length(Signal_channel_time),Channel_num,Noise_Power,'linear');
t_Receive = t_channel;
Signal_Receive_time = Signal_channel_time + Noise_Gaussian';
figure;plot(t_Receive,real(Signal_Receive_time));
xlabel('t/s');ylabel('Amplitude/V');
title('Signal receive');
Signal_Receive_Freq = fft(Signal_Receive_time,NFFT) * 2 / NFFT;
figure;plot(Fn,abs(Signal_Receive_Freq));
Noise_Power_cal = Noise_Gaussian'*Noise_Gaussian/length(Noise_Gaussian);
SNR = 10*log10(Signal_Power/Noise_Power);
Noise_Var = var(Noise_Gaussian);
Noise_Mean = mean(Noise_Gaussian);
%%  Copy Correlator
CopyCorrelator = Signal_source_time;
CopyCorrelator_out = xcorr(Signal_Receive_time,CopyCorrelator);
CopyCorrelator_time_out = (1:length(CopyCorrelator_out))*Delta_T;
figure;plot(CopyCorrelator_time_out,abs(CopyCorrelator_out));






