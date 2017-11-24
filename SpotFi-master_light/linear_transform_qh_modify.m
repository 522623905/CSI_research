function [mcsi_matrix, mcsiphase] = linear_transform_qh_modify(csi_matrix)  %������3*30��CSI����
% �����廪�Ŷ���������Ա任���㷨��ʵ�ֵ�
% PADS: Passive Detection of Moving Targets with Dynamic Speed using PHY Layer Information
    R = abs(csi_matrix);
    csiphase = angle(csi_matrix);
    unwrap_csi = unwrap(csiphase, pi, 2);
    k = -58:4:58;
    ant1 = unwrap_csi(1, :);
    ant2 = unwrap_csi(2, :);
    ant3 = unwrap_csi(3, :);
    a1 = (ant1(30) - ant1(1)) / (58*2);
    b1 = mean(ant1);
    a2 = (ant2(30) - ant2(1)) / (58*2);
    b2 = mean(ant2);
    a3 = (ant3(30) - ant3(1)) / (58*2);
    b3 = mean(ant3);
    a = mean([a1, a2, a3]);
    b = mean([b1, b2, b3]);
    mant1 = ant1 - a*k - b;
    mant2 = ant2 - a*k - b;
    mant3 = ant3 - a*k - b;
    mcsiphase = [mant1; mant2; mant3];
    mcsi_matrix = R.*exp(-1i*mcsiphase);
    %mcsi_matrix = R.*exp(1i*mcsiphase); % ��һ��
end
