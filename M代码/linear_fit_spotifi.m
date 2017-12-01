function [mcsi_matrix, mcsiphase] = linear_fit_spotifi(csi_matrix, delta_f)  %������3*30��CSI����
% ����spotifi�������������㷨��ʵ�ֵ�
% ��С���˷�	��ƫ���ƽ������С��ԭ��
% ����Ŀ�꺯��M����Ŀ�꺯���Բ�����ƫ���������Ϻ����ĸ�������
% MATLAB poltfit������Ҳ�Ǹ�����С���˷���˼�����������ϵ� (in a least-squares sense)
% faliure....
    R = abs(csi_matrix);
    csiphase = angle(csi_matrix);
    unwrap_csi = unwrap(csiphase, pi, 2);
    ant1 = unwrap_csi(1, :); % ĳ�����ߵ�����
    ant2 = unwrap_csi(2, :);
    ant3 = unwrap_csi(3, :);
    ptemp = 2*pi*delta_f;
    x1 = ptemp*linspace(0, 29, 30);  % �������������x1��x2��x3
    x2 = ptemp*linspace(0, 29, 30);
    x3 = ptemp*linspace(0, 29, 30);
    y1 = polyfit(x1, ant1, 1);
    y2 = polyfit(x2, ant2, 1);
    y3 = polyfit(x3, ant3, 1);
    d1 = y1(1); %�����ߵ����ݷֱ���ϵõ���б��a
    d2 = y2(1);
    d3 = y3(1);
    p1 = ant1 - x1*d1;
    p2 = ant2 - x2*d2;
    p3 = ant3 - x3*d3;
    mcsiphase = [p1; p2; p3];
    mcsi_matrix = R.*exp(1i*mcsiphase);
end
