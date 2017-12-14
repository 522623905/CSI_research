%{
�ֱ����3���ߵ�CFR��������ͼ
3���ߵ�����ȡƽ����Ȼ���ٻ�����ͼ
%}
filePath = 'F:\netlink\training_distance\';
dirInfo = dir(fullfile(filePath, '*.dat'));
fileList = {dirInfo.name}.'; % fileList��һ��cell����
npkgs = 100;
EnCfr = zeros(3, npkgs, length(fileList));
AGC = zeros(npkgs, length(fileList));
%%
for indFile = 1:length(fileList)  % for ÿһ�� .dat �ļ�
    mainComp = zeros(3, npkgs);
    csi_trace = read_bf_file([filePath, fileList{indFile}]);
    agc = zeros(npkgs, 1);
    for indPkg = 1:npkgs
        csi_entry = csi_trace{indPkg};
        %% AGC
        agc(indPkg) = csi_entry.agc;
        %% scaled csi
        csi = get_scaled_csi(csi_entry);
        csi = squeeze(csi(1, :, :)); % 3*30
        Ecsi = mean(abs(csi), 2);
        mainComp(:, indPkg) = Ecsi;
    end
    AGC(:, indFile) = agc;
    EnCfr(:, :, indFile) = mainComp;
end
%%
PLOT_CFR = 1;
xdata = [1:0.5:4.5];
if PLOT_CFR
    ant1 = db(squeeze(EnCfr(1, :, :)), 'pow') - AGC;
    ant2 = db(squeeze(EnCfr(2, :, :)), 'pow') - AGC;
    ant3 = db(squeeze(EnCfr(3, :, :)), 'pow') - AGC;
    figure('Name', 'ant 1', 'NumberTitle', 'off');
    boxplot(ant1, xdata); grid on; title('����1 CFR');
    figure('Name', 'ant2', 'NumberTitle', 'off');
    boxplot(ant2, xdata); grid on; title('����2 CFR');
    figure('Name', 'ant 3' , 'NumberTitle', 'off');
    boxplot(ant3, xdata); grid on; title('����3 CFR');
end
ant = (ant1 + ant2 + ant3) / 3;
figure; boxplot(ant, xdata); grid on; title('3����CFR��ƽ��');







    
        