%Write by Joey
%aoa_packet_data:ÿ�����ݰ���aoa������ÿ�����ݰ���musicƵ�׵õ��Ĳ����Ӧ��aoa
%tof_packet_data:ÿ�����ݰ���tof������ÿ�����ݰ���musicƵ�׵õ��Ĳ����Ӧ��tof
%output_top_aoaos:ǰ5�����п�����ֱ��·����AOA
function [aoa_packet_data,tof_packet_data,output_top_aoas] = run_spotfi(filepath)
    antenna_distance = 0.06;  %���߾���
    frequency = 5.825 * 10^9;  %Ƶ��
    sub_freq_delta = (20 * 10^6) /30;  %���ز����
    
    csi_trace = readfile(filepath);
    num_packets = floor(length(csi_trace)/1);
    sampled_csi_trace = csi_sampling(csi_trace, num_packets, 1, length(csi_trace));
    [aoa_packet_data,tof_packet_data,output_top_aoas] = spotfi(sampled_csi_trace, frequency, sub_freq_delta, antenna_distance);
end

%Ϊʲô���в�����
%tau = result(1);���������������ģ�
% ��������������°벿��