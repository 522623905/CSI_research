%{
ԭʼCFR��scaled CFR�Լ��˳��ྶ֮���CFR֮�䲢û��̫�������
һ��pkg�����ݷֱ�������
%}
filePath = 'F:\netlink\training_distance\';
dirInfo = dir(fullfile(filePath, '*.dat'));
fileList = {dirInfo.name}.'; % fileList��һ��cell����
npkgs = 100;
EnComp = cell(length(fileList), 1);
EnOrigComp = cell(length(fileList), 1);
EnFilterComp = cell(length(fileList), 1);
AGC = zeros(npkgs, length(fileList));
%%
for indFile = 1:length(fileList)  % for ÿһ�� .dat �ļ�
    mainComp = zeros(3, 30, npkgs); % 3 antennas * 30 * npkgs;
    mainOrigComp = zeros(3, 30, npkgs);
    mainFilterComp = zeros(3, 30, npkgs);
    csi_trace = read_bf_file([filePath, fileList{indFile}]);
    agc = zeros(npkgs, 1);
    for indPkg = 1:npkgs % ��ÿһ��csi_trace, ���ĵ�һ�� 3 * numOfComp * npkgs�ľ���
        csi_entry = csi_trace{indPkg};
        %% AGC
        agc(indPkg) = csi_entry.agc;
        %% scaled csi
        csi = get_scaled_csi(csi_entry);
        csi = squeeze(csi(1, :, :)); % 3*30
        mainComp(:, :, indPkg) = csi;
        %% ��λ���֮���csi����
        [mcsi] = alleviateMultiPath(csi, 0.25); % 3*30
        mainFilterComp(:, :, indPkg) = mcsi;
        %% original csi
        origCsi = csi_entry.csi;
        origCsi = squeeze(origCsi);
        mainOrigComp(:, :, indPkg) = origCsi;
    end
    AGC(:, indFile) = agc;
    EnComp{indFile} = mainComp;
    EnOrigComp{indFile} = mainOrigComp;
    EnFilterComp{indFile} = mainFilterComp;
end
%% ��csi��ֵ
cfrs = zeros(npkgs, length(fileList));
origCfrs = zeros(npkgs, length(fileList));
filterCfrs = zeros(npkgs, length(fileList));
for indFile = 1:length(fileList)
    csis = EnComp{indFile};
    cfr = zeros(npkgs, 1);
    origCsis = EnOrigComp{indFile};
    origCfr = zeros(npkgs, 1);
    filtercsi = EnFilterComp{indFile};
    filtercfr = zeros(npkgs, 1);
    for indPkg = 1: npkgs
        csi = csis(:, :, indPkg);
        csi_sq = csi.*conj(csi);
        csi_pwr = sum(csi_sq(:)) / 90;
        cfr(indPkg) = csi_pwr; %%
        %%
        origcsi = origCsis(:, :, indPkg);
        origcsi_sq = origcsi.*conj(origcsi);
        origcsi_pwr = sum(origcsi_sq(:)) / 90;
        origCfr(indPkg) = origcsi_pwr;
        %%
        fcsi = filtercsi(:, :, indPkg);
        fcsi_sq = fcsi.*conj(fcsi);
        fcsi_pwr = sum(fcsi_sq(:)) / 90;
        fCfr(indPkg) = fcsi_pwr;
    end
%     cfr = db(cfr, 'pow') - AGC(:, indFile);
    cfrs(:, indFile) = cfr;
    origCfrs(:, indFile) = origCfr;
    filterCfrs(:, indFile) = fCfr;
end
cfrs = db(cfrs, 'pow') - AGC;
origCfrs = db(origCfrs, 'pow') - AGC;
filterCfrs = db(filterCfrs, 'pow') - AGC;
%%
PLOT_SUM_CFR = 1;
xdata = [1:0.5:4.5];
if PLOT_SUM_CFR
    figure('Name', 'CSI��ֵ���', 'NumberTitle', 'off');
    boxplot(cfrs, xdata); grid on; title('CSI��ֵ���');
end
PLOT_SUM_ORIG_CFR = 1;
if PLOT_SUM_ORIG_CFR
    figure('Name', 'ԭʼCSI��ֵ���', 'NumberTitle', 'off');
    boxplot(origCfrs, xdata); grid on; title('ԭʼCSI��ֵ���');
end
PLOT_FILTER_CFR = 1;
if PLOT_FILTER_CFR
    figure('Name', 'ƽ��CSI��ֵ���', 'NumberTitle', 'off');
    boxplot(filterCfrs, xdata); grid on; title('ƽ��CSI��ֵ���');
end





    
        