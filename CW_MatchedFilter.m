clc;close all;clear;
%% CW signal source 
A = 1;
f = 10e3;
omega = 2*pi*f;
Phi = 0;%pi/3;
FS = 40e3;
Delta_T = 1/FS;
NFFT = FS;
t1 = (1:5e-3/Delta_T)*Delta_T;
t2 = (5e-3/Delta_T + 1:10e-3/Delta_T)*Delta_T;
t3 = (10e-3/Delta_T + 1:15e-3/Delta_T)*Delta_T;
t4 = (15e-3/Delta_T + 1:20e-3/Delta_T)*Delta_T;
signal_1 = A*cos(omega*t2+Phi);
signal_2 = A*cos(omega*t3+Phi);
t = [t1,t2];
Signal_source_time = [signal_1,zeros(1,length(t2))];
% t = [t1,t2,t3];
% Signal_source_time = [zeros(1,length(t1)),signal_1,zeros(1,length(t3))];
% t = [t1,t2,t3,t4];
% Signal_source_time = [signal_1,zeros(1,length(t2)),signal_2,zeros(1,length(t4))];
Signal_source_Freq = fft(Signal_source_time,NFFT);
Fn=(0:NFFT-1);
figure;
plot(t,Signal_source_time);
xlabel('t/s');ylabel('Amplitude/V');
title('Signal source')
figure;
plot(Fn,abs(Signal_source_Freq));


%% CW signal receive
R = 9e6;
c = 3e8;
t0 = R/c;
t_receive = [(1:t0/Delta_T)*Delta_T,t + t0];
Signal_arrival = [zeros(1,t0/Delta_T),Signal_source_time];
Signal_receive_time = awgn(Signal_arrival,-10,'measured');
Noise_arrival = Signal_receive_time - Signal_arrival;
Signal_receive_Freq = fft(Signal_receive_time,NFFT);
figure;
plot(t_receive,Signal_receive_time);
xlabel('t/s');ylabel('Amplitude/V');
title('Signal receive');
figure;
plot(t_receive,Noise_arrival);
xlabel('t/s');ylabel('Amplitude/V');
title('Noise arrival');
figure;
plot(Fn,abs(Signal_receive_Freq));

%%  Matched Filter
h_matched = [zeros(1,ceil((t0 - t(end))/Delta_T) + 1),Signal_source_time(end:-1:1)];
figure;plot((1:length(h_matched))*Delta_T,h_matched);
% h_matched = [zeros(1,ceil((t0 - t(end))/Delta_T)),zeros(1,ceil((t(end) - t1(end))/Delta_T)),signal(ceil((t0 - t1(end))/Delta_T):-1:ceil(t1(1)/Delta_T))];
H_matched = conj(Signal_source_Freq)*exp(-1i*2*pi*f*t0);
h_matched_time = fftshift(ifft(H_matched));
figure;plot(real(h_matched_time));
Signal_Deal = conv(Signal_receive_time,h_matched);
Signal_Deal_Freq = Signal_receive_Freq.*H_matched;
Signal_Deal_Time = fftshift(ifft(Signal_Deal_Freq));
figure;plot(real(Signal_Deal_Time));
t_receive = (1:length(Signal_Deal))*Delta_T;
figure;plot(t_receive,Signal_Deal);




