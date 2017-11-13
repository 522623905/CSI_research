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
clc;clear;close all;

%% ȫ�ֲ�������
CSI_Configure();

%% ����ȫ�ֲ���
global Nrx ant_dist
global paths theta tau  
global fc Nc Delta_f
global SNR samples
global param

disp('Display All Global Paramters: ');
param
%% ���õĶྶAoA��ToF��Ϣ
fprintf('True ToF and AoA of all paths: \n');
for ipath = 1:paths
    disp(['path ' num2str(ipath) ': (AoA, ToF) = (' num2str(theta(ipath)) ...
        ' [deg], ' num2str(tau(ipath)*1e9) ' [ns])' ]);
end

%% ���ɹ۲����CSI�͵�������A
[CSI,A] = API_CSI_Generator(theta, tau, paths, ...
                            Nrx,ant_dist,samples, ...
                            fc,Nc,Delta_f,SNR);
                        
%% ����MUSICα�ף�Ѱ���׷壬����AoA��ToF�������ӻ�,��Ϊjpeg
API_CSI_MUSIC_Visualize(CSI,samples,paths, Nrx,ant_dist, ...
                            fc,Nc,Delta_f);
