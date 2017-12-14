%{
��CSI���ݵ���λ���в���200ns,4����������
the packet detection delay can span hundreds of nanoseconds for Intel 5300.
After compensating 4 sampling periods, i.e., 200 ns
%}
function [mcsi_matrix, phase_matrix] = linear_compensate_t(csi_matrix, t)  %������3*30��CSI����
    subcarriers_interval = 0.3125*10^6; % 312.5 khz
    cfreq = 5.745 * 10^9; % ����Ƶ��
    tmp = cfreq - (15*4-2)*subcarriers_interval;
    subind = 0:29;
    subcarriers_freq = subind*subcarriers_interval*4 + tmp; % �������ز���Ƶ��
    compensate_phase = exp(1i*2*pi*subcarriers_freq*t); % 1*30
    tmpcsi = csi_matrix.*[compensate_phase; compensate_phase; compensate_phase];
    mcsi_matrix = tmpcsi;
    phase_matrix = angle(tmpcsi);
end

