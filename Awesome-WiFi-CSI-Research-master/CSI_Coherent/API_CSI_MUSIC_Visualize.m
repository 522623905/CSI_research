
%% Xt��Smooth_CSI
function [Pmusic] = API_CSI_MUSIC_Visualize(Xt,...
			samples, paths, Nrx, ant_dist, fc, Nc, Delta_f, option)
if strcmp(option,'non-smoothing')
    Rxx = Xt*Xt'/samples; % 90*90
elseif strcmp(option,'smoothing')
    Rxx = zeros(size(Xt,1)); % Xtά���� 30x32x1025 Rxx��ά����
    for isamples = 1:samples
        Xt_squeeze = squeeze(Xt(:,:,isamples)); % 30*32 ȡ����isamples�����ݰ�(��Ƭ)
        Rxx = Rxx + Xt_squeeze*Xt_squeeze'; % 30*30
    end
    Rxx = Rxx/samples;  %������ݰ������
end

[eigvec_mat, diag_mat_of_eigval] = eig(Rxx); % ����������������������ֵ�ԽǾ���
eigval = diag(diag_mat_of_eigval);     % ȡ��������ֵ
% [sorted_eigval,IndexVector]=sort(eigval);        % ������ֵ�������򣬲�����index vector
% % ���������������е���˳�򣬵���ԭ��Ϊ���������ֵ��Ӧ����������������
% % ����������������ֵ���н������У�������ֵ����key����������������value
% eigvec_mat=fliplr(eigvec_mat(:,IndexVector)); 

[sorted_eigval,IndexVector] = sort(eigval,'descend');
%Ĭ������������ascend������ָ����������descend���Ծ����н������򣬱���ԭ��������
eigvec_mat = eigvec_mat(:,IndexVector); 
% ��eigvec_mat�����ÿһ�а���IndexVector���������µ���


%% ��Դ������
global USE_NumOfSignalsEstimation

if ~USE_NumOfSignalsEstimation
    L = paths;  % ��ʹ����Դ�����ƣ�ֱ����Ϊ����
else
    % 'AIC','MDL','HQ','EGM1','EGM2'
    algo_option = 'EGM1';  % �����㷨
    L = util_getNumOfSignals(sorted_eigval,samples,algo_option);
	L = L;
	
	% samples�൱���ж��ٸ����ݰ���CSI����
    fprintf('\nUsing %s NumOfSignalsEstimation, Estimate Paths is %d\n',algo_option, L);
end
%% ����MUSICα��
aoa = -90:1:90;       % -90~90 [deg]
tof = (0:1:100)*1e-9; % 1~100 [ns]

En = eigvec_mat(:, L+1:size(Rxx, 1));
Pmusic = zeros(length(aoa),length(tof));
for iAoA = 1:length(aoa)
    for iToF = 1:length(tof)
        a = util_steering_aoa_tof(aoa(iAoA), tof(iToF), Nrx, ant_dist, fc, Nc, Delta_f, option);
		% ֱ���Һ�length(eigvec_mat) - L��,�������ռ�����
		% �����ռ���30* (length(eigvec_mat) - L) ***
		% ������ʸ����30 * 1
        %Pmusic(iAoA,iToF) = abs(1/(a'*(En*En')*a));
        % ��һ��MUSICα��
        Pmusic(iAoA,iToF) = abs((a'*a)/(a'*(En*En')*a));
    end
end

LOG_DATE = strrep(datestr(now,30),'T','');  % ʱ���ַ������滻���ַ�T

%% MUSIC_AOA_TOF���ӻ�
SPmax = max(max(Pmusic));
Pmusic = 10*log10(Pmusic/SPmax);
hMUSIC = figure('Name', 'MUSIC_AOA_TOF1', 'NumberTitle', 'off');
[meshAoA,meshToF] = meshgrid(aoa,tof);
mesh(meshAoA, meshToF*1e9, Pmusic');

xlabel('X Angle of Arrival in degrees[deg]');
ylabel('Y Time of Flight[ns]');
zlabel('Z Spectrum Peaks[dB]');
title('AoA and ToF Estimation from Modified MUSIC Algorithm');
axis([-90 90 0 100]);
view(3);
grid on; hold on;
fprintf('\nFind all peaks of MUSIC spectrum: \n');

%{
hMUSIC = figure('Name', 'MUSIC_AOA_TOF2', 'NumberTitle', 'off');
[meshAoA, meshToF] = meshgrid(aoa, tof);
mesh(meshToF*1e9, meshAoA, Pmusic');
% axis([-90 90 0 100]);
ylabel('Y Angle of Arrival in degrees[deg]')
xlabel('X Time of Flight[ns]')
zlabel('Z Spectrum Peaks[dB]')
title('AoA and ToF Estimation from Modified MUSIC Algorithm');
grid on; hold on;
fprintf('\nFind all peaks of MUSIC spectrum: \n');

hMUSIC = figure('Name', 'MUSIC_AOA_TOF3', 'NumberTitle', 'off');
[meshToF, meshAoA] = meshgrid(tof, aoa);
mesh(meshToF*1e9, meshAoA, Pmusic);
% axis([-90 90 0 100]);
ylabel('Y Angle of Arrival in degrees[deg]')
xlabel('X Time of Flight[ns]')
zlabel('Z Spectrum Peaks[dB]')
title('AoA and ToF Estimation from Modified MUSIC Algorithm');
grid on; hold on;
fprintf('\nFind all peaks of MUSIC spectrum: \n');
%}



global PLOT_MUSIC_AOA PLOT_MUSIC_TOF 
global SAVE_FIGURE
%% MUSIC_AOA���ӻ�
if 	PLOT_MUSIC_AOA
    num_computed_paths = L;
    figure_name_string = sprintf('MUSIC_AOA, Number of Paths: %d', num_computed_paths);
    figure('Name', figure_name_string, 'NumberTitle', 'off')

    PmusicEnvelope_AOA = zeros(length(aoa),1);
    for i = 1:length(aoa)
        PmusicEnvelope_AOA(i) = max(Pmusic(i,:)); 
		% �Ƕ����ֵ���ǰ��н����������ҵ��ǽǶ����ֵ�ĵİ���
    end

    plot(aoa, PmusicEnvelope_AOA, '-r')
    xlabel('x_Angle, \theta[deg]')
    ylabel('y_Spectrum function P(\theta, \tau)  / dB')
    title('AoA Estimation')
    grid on;grid minor;hold on;

   %% ��������·����AoA
    % ���򷵻�ǰpaths��ķ�ֵ��������
    [pktaoa,lctaoa]  = findpeaks(PmusicEnvelope_AOA,...
		'SortStr','descend','NPeaks',num_computed_paths);
	% findpeaks����һ����ֵ�Ͷ�Ӧ��¼һ��index����ֵ��index�Ƕ�Ӧ��
	% ������صĵ�lct�Ƿ�ֵ���±꣬���������ĽǶ�thetaֵ����ʹ�ýǶ�ʹ��aoa(lct)
	% ע������ط� PmusicEnvelope_AOA������������˷��ص�pkt�Լ�lctҲ��������
    % pkt�Ƿ�ֵ��lct�Ƿ�ֵ��PmusicEnvelope_AOA���ֵ�index
	% plot(lct,pkt,'o','MarkerSize',12)
    plot(aoa(lctaoa),pktaoa,'o','MarkerSize',12)
    % ���������ֵ������
	disp(['Calculated AoA: ' num2str(sort(round(aoa(lctaoa)),'ascend')) ' [deg] ']);
    
    if SAVE_FIGURE
        figureName = ['./figure/' LOG_DATE '_' 'MUSIC_AOA' '.jpg'];
        saveas(gcf,figureName);
    end
end

%% MUSIC_TOF���ӻ�
if 	PLOT_MUSIC_TOF
    figure_name_string = sprintf('MUSIC_TOF, %d paths', num_computed_paths);
    figure('Name', figure_name_string, 'NumberTitle', 'off');
    PmusicEnvelope_ToF = zeros(length(tof),1);
    for i = 1:length(tof)
        PmusicEnvelope_ToF(i) = max(Pmusic(:,i)); % ʱ���ֵ���ǰ��н�������
    end

    plot(tof*1e9, PmusicEnvelope_ToF, '-k')
    xlabel('ToF, \tau[ns]')
    ylabel('Spectrum function P(\theta, \tau)  / dB')
    title('ToF Estimation')
    grid on; grid minor; hold on;
   %% ��������·����ToF
    [pkttof, lcttof]  = findpeaks(PmusicEnvelope_ToF,...
		'SortStr', 'descend', 'NPeaks', num_computed_paths); % 'MinPeakHeight',-4
	% descend�ǶԷ�ֵ���н�������ģ���Ӧ��index��Ӧ�ı�
	% �ڶ��������д���
	% PmusicEnvelope_ToF��tof ��ֵ���緵��lct�պ���ʱ�䣬��Ϊ
	
    plot(tof(lcttof)*1e9, pkttof,'o','MarkerSize',12)
    disp(['Calculated ToF: ' num2str(sort(round(tof(lcttof)*1e9),'ascend')) ' [ns]'] );
	% disp(['Calculated ToF: ' num2str(sort(round(tau(lctof)),'ascend')) ' [ns] ']);
    
    if SAVE_FIGURE
        figureName = ['./figure/' LOG_DATE '_' 'MUSIC_TOF' '.jpg'];
        saveas(gcf,figureName);
    end
    
   %% ����ֱ�侶AoA��ToF
    fprintf('\nFind Direct Path AoA and ToF: \n')
    direct_path_tof_index = find(tof == tof(min(lcttof)));
	% ������PmusicEnvelope_ToF findpeaks�ĵ�һ����ֵ��index�� ������
    direct_path_tof = tof(min(lcttof))*1e9; % ��λ�� ns
	
    [~,direct_path_aoa_index] = max(Pmusic(:,direct_path_tof_index));
    direct_path_aoa = aoa(direct_path_aoa_index);
	% ����tof����Сֵ��ȷ��ΪLOS
	% ��һ����������ĳ��ֵ����index Pmusic(i, j)
	% ��plot��ͼ��ʱ�򣬻��Ƶ���index��Ӧ����ʵ��ֵ
	
    disp(['(AOA, ToF) =  ('  num2str(direct_path_aoa) ' [deg], '  ...
       num2str(direct_path_tof) ' [ns]) ']);

   %% ��MUSICα���б��ֱ�侶
    % set(groot,'CurrentFigure',hMUSIC);hold on;
    x_aoa = direct_path_aoa;
    y_tof = direct_path_tof;
    z_dB = Pmusic(direct_path_aoa_index,direct_path_tof_index);
	currentAxis = get(hMUSIC, 'CurrentAxes');
   % plot3(currentAxis, x_aoa,y_tof,z_dB,'o','MarkerSize',12);
	scatter3(currentAxis, x_aoa, y_tof, z_dB, 'filled', 'MarkerEdgeColor','r');
	
    txt = sprintf('Direct Path: \n( %d[deg], %d[ns])', ...
        round(direct_path_aoa), ...
        round(direct_path_tof));
     text(currentAxis, x_aoa,y_tof,txt);
	
    % ����figure hMUSICΪ��ǰ��ͼ

    figure(hMUSIC);
    view(-60,30);
    
    if SAVE_FIGURE
        figureName = ['./figure/' LOG_DATE '_' 'MUSIC_AOA_TOF' '.jpg'];
        saveas(gcf,figureName);
    end
end
end


