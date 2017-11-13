%{
  ʵ����ۣ�
    - ��������������ۺ�Ӱ��AoA��ToF�ķֱ��ʡ�׼ȷ��
    - �����������������£��������ToF�ֱ���
    - �����������������£���Ԫ������AoA�ķֱ���
    - ���п׾� l = (Nrx-1)*ant_dist
    - ant_dis���ȡlambda/2����ʱ�ɻ�ȡ�������п׾�
    - ��Դ��L���Ʋ�׼�����AoA��ToF��ɺܴ�����һ�����߶�һ�������У�
    - MUSIC�㷨ֻ�����ڷ������Դ
%}


%{
isCoherent = false;
�Ƿ�����źţ�Gamma = randn(paths,samples)+randn(paths,samples)*1j;
������ź� option�� non-smoothing


isCoherent = true;
����ź� �������Ƿ�����ź�
option�� smoothing ���� non-smoothing
����źźͷ�����ź��ڹ��� CSI���ݵ�ʱ���ǲ�ͬ��
%}


clc;clear;close all;

%% ȫ�ֲ�������
CSI_Configure();

global isRealSignal


%% ����ȫ�ֲ���
global Nrx ant_dist
global paths theta tau  
global fc Nc Delta_f
global SNR samples
global param

if ~isRealSignal %����ʵ�ź�
    disp('Display All Global Paramters: ');
    param
    %% ���õĶྶAoA��ToF��Ϣ
    fprintf('True ToF and AoA of all paths: \n');
    for ipath = 1:paths
        disp(['path ' num2str(ipath) ': (AoA, ToF) = (' num2str(theta(ipath)) ...
            ' [deg], ' num2str(tau(ipath)*1e9) ' [ns])' ]);
    end

    global CoherentPaths
    fprintf('\n%d from %d paths are coherent\n', CoherentPaths+1, paths);
end


global isCoherent 
isSmoothing = true;


if isSmoothing
    option = 'smoothing';
else
    option = 'non-smoothing';
end
% ��ɽ���ƽ��������ɲ�����ƽ��
% option = 'non-smoothing';

if ~isRealSignal % ����ʵ�ź�
%% ���ɹ۲����CSI�͵�������A,ģ������
    [Smooth_CSI,A] = API_CSI_Generator(theta, tau, paths, ...
                            Nrx,ant_dist,samples, ...
                            fc,Nc,Delta_f,SNR,option);
else % ʹ����ʵ����
    %CSI = load('smoothed_csi.mat'); % load���ص���һ���ṹ��
   % Smooth_CSI = CSI.smoothed_csi_to_save;
    CSI = load('smoothed_sanitized_csi.mat');
    Smooth_CSI = CSI.smoothed_sanitized_csi_to_save;
    samples = size(Smooth_CSI,3);
    paths = -1;
    Nrx = 3;
    ant_dist = 0.10;
    fc = 5.32 * 10^9; %  5.785 * 10^9
    Nc = 30;
    Delta_f = (40 * 10^6) / 30;
end
%% ����MUSICα�ף�Ѱ���׷壬����AoA��ToF�������ӻ�,��Ϊjpeg
[Pmusic] = API_CSI_MUSIC_Visualize(Smooth_CSI,samples,paths, Nrx,ant_dist, ...
                            fc,Nc,Delta_f,option);