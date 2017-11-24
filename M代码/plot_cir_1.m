ONE_PACKAGE = 1;
if ONE_PACKAGE
    index = 10;
    csi = csis{index};
    cir = ifft(csi);
    abscirdata = abs(cir);
    max_cir = max(abscirdata, [], 1); % cir_dataÿһ�е����ֵ
    cir_f = zeros(30, 3); % 30*3
    for i = 1 : size(cir, 2) % % ���cirֵС�ڷ�ֵ��0.5�����򽫶�Ӧ��cir�޳���
        for j = 1: size(cir, 1)
            if abscirdata(j, i) >= max_cir(i)*0.3
                cir_f(j, i) = cir(j, i);
            end
        end
    end
    csi_f = fft(cir_f);
    figure('Name', 'one package......');
    subplot(221); plot(db(abs(csi)));
    subplot(222); bar(abs(cir));
    subplot(223); plot(db(abs(csi_f)));
    subplot(224); bar(abs(cir_f));
end