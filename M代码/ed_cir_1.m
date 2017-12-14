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
        agc = csi_entry.agc;
        %%
        csi = get_scaled_csi(csi_entry);
        csi = squeeze(csi(1, :, :)); % 3*30
        cir = abs(ifft(csi, [], 2)) - csi_entry.agc; % ���н���ifft
        [e, ~] = sort(cir, 2, 'descend');
        mainComp(:, :, indPkg) = e(:, [1: numOfComp]); % 3*numOfComp ȡ�������ǰnumOfComp����������
        %% ��λ���֮���csi����
        [mcsi, ~] = spotfi_algorithm_1(csi); % 3*30
        filterCir = abs(ifft(mcsi, [], 2)) - csi_entry.agc;
        [me, i] = sort(filterCir, 2, 'descend');
        mainFilterComp(:, :, indPkg) = me(:, [1: numOfComp]); % 3*numOfComp ȡ�������ǰnumOfComp����������
        %%
        origCsi = csi_entry.csi;
        origCsi = squeeze(origCsi);  % ��ȥ�Զ��������
        oriCir = abs(ifft(origCsi, [], 2)) - csi_entry.agc; % ���н���ifft
        %%
        [oe, ~] = sort(oriCir, 2, 'descend');
        mainOrigComp(:, :, indPkg) = oe(:, [1: numOfComp]); % 3*numOfComp ȡ�������ǰnumOfComp����������
    end
    EnComp{indFile} = mainComp;
    EnFilterComp{indFile} = mainFilterComp;
    EnOrigComp{indFile} = mainOrigComp;
end
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
%{
��������֮���������˸���ͣ�˲������!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%}
PLOT_3_ANTENNA_SUM = 1;
if PLOT_3_ANTENNA_SUM
    xdata = [1:length(fileList)]*0.5 + 0.5;
    figure('Name', 'sumEnergy');
    d1 = sum(sumEnergy, 1);
    data1 = squeeze(d1);
    boxplot(data1, xdata); title('Distance Estimation with Scaled CSI'); grid on;

    figure('Name', 'sumFilterEnergy');
    d2 = sum(sumFilterEnergy, 1);
    data2 = squeeze(d2);
    boxplot(data2, xdata); title('Distance Estimation with Filter CSI'); grid on;

    figure('Name', 'sumOriEnergy');
    d3 = sum(sumOriEnergy, 1);
    data3= squeeze(d3);
    boxplot(data3, xdata); title('Distance Estimation'); grid on;
end




    
        