%{
ԭʼ��CIR���ȣ���ֵ�б䶯��Ӧ���Ǻܲ��ȶ��ģ�
����������ϴ���֮����ȱ�ú��ȶ���
%}
clc; clear all;
delta_f = (40 * 10^6) /30;  % ���ز����
csi_trace = read_bf_file('logjsb.dat');
npkg = length(csi_trace);
csis = cell(npkg, 1);
cirs = cell(npkg, 1);

%% get csi
for ind = 1:npkg
    csi_entry = csi_trace{ind};
    tempcir = get_scaled_csi(csi_entry);
    tempcir = tempcir(1, :, :); % extract only one antenna data
    csis{ind} = squeeze(tempcir).'; % 30*3
end
for ind = 1: npkg
    csi = csis{ind};	% 30 * 3
    cirs{ind} = abs(ifft(csi));  % ����ط�����abs����任��ʱ����޷�����
     %cirs{ind} = ifft(csi);
end
%%
ampl = zeros(npkg, 1);
antenna = 1;
for i = 1:npkg
    ampl(i) = max(cirs{i}(:, antenna));
end
figure('Name', 'ampl');
bar(ampl,0.5, 'FaceColor',[.42 .55 .13]); grid on; title('origin cir');