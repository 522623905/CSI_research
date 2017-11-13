%Write by Joey
%aoa_packet_data:ÿ�����ݰ���aoa������ÿ�����ݰ���musicƵ�׵õ��Ĳ����Ӧ��aoa
%tof_packet_data:ÿ�����ݰ���tof������ÿ�����ݰ���musicƵ�׵õ��Ĳ����Ӧ��tof
%output_top_aoaos:ǰ5�����п�����ֱ��·����AOA
function [aoa_packet_data,tof_packet_data,output_top_aoas, Pmusics, likelihood, likelihood_test] = run_spotfi(filepath)
    c = 3*10^8;
    frequency = 5.825 * 10^9;  %Ƶ��
    sub_freq_delta = (40 * 10^6) /30;  %���ز����
	lambda = c / frequency;
    antenna_distance = lambda / 2;
	
	fprintf('antenna_distance = %d\n', antenna_distance);
	
    csi_trace = readfile(filepath);
    num_packets = floor(length(csi_trace)/1);
    sampled_csi_trace = csi_sampling(csi_trace, num_packets, 1, length(csi_trace));
    [aoa_packet_data,tof_packet_data,output_top_aoas, Pmusics, likelihood, likelihood_test] = spotfi(sampled_csi_trace, frequency, sub_freq_delta, antenna_distance);
end

%Ϊʲô���в�����
%tau = result(1);���������������ģ�
% ��������������°벿��
% ����ӵ��p��AOA��ֵ����ô estimated_aoas �� p * 1
% estimated_tofs �� p * length(tau) �ľ���