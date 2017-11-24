%% ����lgtmԴ��������ϲ���ʵ��
% ����ע���
% ���ǽ������������ϣ����п��ܳ�����λ�۵����������UNwrapһ�£�
% (���֮һ�ǣ��õ�����λ����û����λ���۵������ǽ���angle����֮����λ�����������۵�)
% �õ���λ����phase_matrix������phase_matrix���¹���CSI����������λ����Ӧ����һ����
clc;clear all;
csi_trace = read_bf_file('3.5-30-5.dat');
num_package = length(csi_trace);
fprintf('mumber_package = %d\n', num_package);
csis = cell(num_package, 1);
%%
for ii = 1:num_package
    csi_entry = csi_trace{ii};
    temp = get_scaled_csi(csi_entry);
    temp = temp(1, :, :);
    csis{ii} = squeeze(temp).'; % 30*3
end
%%
index = 10;
csi_matrix = csis{index}; % 30*3
csi_matrix1 = csis{index+1}; % 30*3
delta_f = (40 * 10^6) / 30;
[mcsi_matrix, mcsiphase00] = spotfi_algorithm_1(csi_matrix.', delta_f);
[mcsi_matrix1, mcsiphase11] = spotfi_algorithm_1(csi_matrix1.', delta_f);
%% plot CSI phase with linear fit
figure('Name', 'CSI phase with linear fit');
unwrapd_csi = unwrap(angle(csi_matrix), pi, 1);
subplot(221); plot(unwrapd_csi, ':');
grid on; hold on;
unwrapd_csi1 = unwrap(angle(csi_matrix1), pi, 1);
plot(unwrapd_csi1);
hold off;
title('unwrapped CSI phase');
legend('show');
%% plot unwrapped CSI phase difference
pdifference = unwrapd_csi - unwrapd_csi1;
subplot(222); plot(pdifference);
grid on;
title('CSI phase difference');
%% plot CSI phase with linear fit
mcsiphase = unwrap(angle(mcsi_matrix.') , pi, 1);
subplot(223); plot(mcsiphase, ':');
grid on; hold on;
mcsiphase1 = unwrap(angle(mcsi_matrix1.') , pi, 1);
plot(mcsiphase1);
title('CSI phase with linear fit');
%% plot CSI phase diference with linear fit
pdifference1 = mcsiphase - mcsiphase1;
subplot(224); plot(pdifference1);
grid on;
title('CSI phase diference with linear fit');
%% plot CSI phase with linear transformation
figure('Name', 'plot phase directly from phase_matrix');
subplot(211); plot(mcsiphase00.', ':');
grid on; hold on;
plot(mcsiphase11.');
title('CSI phase with linear transformation');
%% plot CSI phase diference with linear transform
pdifference = mcsiphase00.' - mcsiphase11.';
subplot(212); plot(pdifference);
grid on;
title('CSI phase diference with linear transformation');