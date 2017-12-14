%%
filePath = 'F:\netlink\training_distance\';
dirInfo = dir(fullfile(filePath, '*.dat'));
fileList = {dirInfo.name}.'; % fileList��һ��cell����
npkgs = 100;
EnComp = cell(length(fileList), 1);
EnFilterComp = cell(length(fileList), 1);
EnOrigComp = cell(length(fileList), 1);
numOfComp = 3;
%%
for indFile = 1:length(fileList)  % for ÿһ�� .dat �ļ�
    mainComp = zeros(3, numOfComp, npkgs); % 3 antennas * numOfComp * npkgs;
    mainFilterComp = zeros(3, numOfComp, npkgs);
    mainOrigComp = zeros(3, numOfComp, npkgs);
    csi_trace = read_bf_file([filePath, fileList{indFile}]);
    for indPkg = 1:npkgs % ��ÿһ��csi_trace, ���ĵ�һ�� 3 * numOfComp * npkgs�ľ���
        csi_entry = csi_trace{indPkg};
        csi = get_scaled_csi(csi_entry);
        csi = squeeze(csi(1, :, :)); % 3*30
        cir = abs(ifft(csi, [], 2)); % ���н���ifft
        [e, ~] = sort(cir, 2, 'descend');
        mainComp(:, :, indPkg) = e(:, [1: numOfComp]); % 3*numOfComp ȡ�������ǰnumOfComp����������
        %% ��λ���֮���csi����
        [mcsi, ~] = spotfi_algorithm_1(csi); % 3*30
        filterCir = abs(ifft(mcsi, [], 2));
        [me, i] = sort(filterCir, 2, 'descend');
        mainFilterComp(:, :, indPkg) = me(:, [1: numOfComp]); % 3*numOfComp ȡ�������ǰnumOfComp����������
        %%
        origCsi = csi_entry.csi;
        origCsi = squeeze(origCsi);
        oriCir = abs(ifft(origCsi, [], 2)); % ���н���ifft
        [oe, ~] = sort(oriCir, 2, 'descend');
        mainOrigComp(:, :, indPkg) = oe(:, [1: numOfComp]); % 3*numOfComp ȡ�������ǰnumOfComp����������
    end
    EnComp{indFile} = mainComp;
    EnFilterComp{indFile} = mainFilterComp;
    EnOrigComp{indFile} = mainOrigComp;
end
%% ������ͼ����
%{
indComp = 1;
boxPlotData = zeros(npkgs, length(fileList), 3);  % ���� * �ļ���(����) * 3����
for indFile = 1:length(fileList)
    mainComp = EnFilterComp{indFile};
    tmpBoxData = squeeze(mainComp(:, indComp, :));
    boxPlotData(:, indFile, :) = tmpBoxData.';
end
indAnt = 1;
data = squeeze(boxPlotData(:, :, indAnt));
%%
xdata = [1:length(fileList)]*0.6;
boxplot(data, xdata); title('Distance Estimation'); grid on;
%}
%%
sumEnergy = zeros(3, npkgs, length(fileList));
sumFilterEnergy = zeros(3, npkgs, length(fileList));
sumOriEnergy = zeros(3, npkgs, length(fileList));
for indFile = 1:length(fileList)  % for ÿһ�� .dat �ļ�
    tmpEn = EnComp{indFile}; % 3 antennas * numOfComp * npkgs;
    tmp1 = squeeze(sum(tmpEn, 2));
    sumEnergy(:, :, indFile) = tmp1;
    %%
    filterTmpEn = EnFilterComp{indFile}; % 3 antennas * numOfComp * npkgs;
    tmp2 = squeeze(sum(filterTmpEn, 2));
    sumFilterEnergy(:, :, indFile) = tmp2;
    %%
    oriTmpEn = EnOrigComp{indFile}; % 3 antennas * numOfComp * npkgs;
    tmp3 = squeeze(sum(oriTmpEn, 2));
    sumOriEnergy(:, :, indFile) = tmp3;
end
%%
indAnt = 1;
xdata = [1:length(fileList)]*0.6;
data1 = squeeze(sumEnergy(indAnt, :, :));
data2 = squeeze(sumOriEnergy(indAnt, :, :));
subplot(211); boxplot(data1, xdata); title('Distance Estimation'); grid on;
subplot(212); boxplot(data2, xdata); title('Distance Estimation'); grid on;





    
        