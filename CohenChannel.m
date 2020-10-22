function [CohenChannel,CohenChannel_time] = CohenChannel(Sample_Freq,channel_time, h_Amplitude, h_Timedelay)
%Sample_Freq : 采样频率
% channel_time : 信道系统函数冲激响应长度
% h_Amplitude : 相干信道中冲激函数幅度
% h_Timedelay : 相干信道中冲激函数时延
% CohenChannel : 相干信道系统函数冲激响应


Delta_T = 1 / Sample_Freq;
channel_Time = (1:channel_time / Delta_T) * Delta_T;
CohenChannel = zeros(1,length(channel_Time));
for h_Timedelay_num = 1:length(h_Timedelay)
    h_tao = ceil(h_Timedelay(h_Timedelay_num)/Delta_T);
    CohenChannel(h_tao) = h_Amplitude(h_Timedelay_num);
end
CohenChannel_time = channel_Time;
end