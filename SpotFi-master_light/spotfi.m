
function [Pmusics, eigenvalue] = spotfi(csi_trace,...
	frequency, sub_freq_delta, antenna_distance, theta, tau)
	if nargin < 5
		theta = -90:1:90;
		tau = 0:(1.0 * 10^-9):(100 * 10^-9);
	end
    
    num_packets = length(csi_trace);
	num_packets = 10; % Ϊ�˼ӿ�ִ�е��ٶȣ���ѡȡ20��packages 

	Pmusics = cell(num_packets, 1);
	eigenvalue = cell(num_packets, 1);
	smoothed_sanitized_csi = zeros(30, 32);
    for packet_index = 1:num_packets
        csi_entry = csi_trace{packet_index};
        csi = get_scaled_csi(csi_entry);
        csi = csi(1, :, :); % Remove the single element dimension
        csi = squeeze(csi); % 3*30
		csi = csi([1 2 3], :);  % ������2������3���ݽ����û�

        
		% Sanitize ToFs with Algorithm 1
		sanitized_csi = spotfi_algorithm_1(csi, sub_freq_delta); % 3*30
		% [sanitized_csi, ~] = linear_transform_qh(csi);
		% [sanitized_csi, ~] = linear_transform_qh_modify(csi);
		% [sanitized_csi, ~] = linear_fit_spotifi(csi, sub_freq_delta);
		
        % [sanitized_csi, ~] = linear_transform_monalisa(csi);
		% [sanitized_csi, linear_fit_csi_phase] = linear_fit(csi); % ���н���ǹ���
		
		smoothed_sanitized_csi = smooth_csi(sanitized_csi);  % ԭʼƽ����ʽ
		% smoothed_sanitized_csi = smooth_csi_light(sanitized_csi);  % ˫��ƽ����ʽ

        [Pmusics{packet_index}, eigenvalue{packet_index}] = aoa_tof_music(...
               smoothed_sanitized_csi, antenna_distance, frequency, sub_freq_delta, theta, tau);
        fprintf('%d\n',packet_index);
    end

end