function CSI_Configure
%CONFIGURE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

%%
global degree2radian radian2degree twoPi LIGHTSPEED lambda
global Nrx ant_dist
global paths theta tau isCoherent CoherentPaths
global fc Nc Delta_f BW
global SNR samples
global PLOT_MUSIC_AOA PLOT_MUSIC_TOF
global SAVE_FIGURE
global USE_NumOfSignalsEstimation
global isRealSignal

isRealSignal = false;

USE_NumOfSignalsEstimation = true;

PLOT_MUSIC_AOA = true;
PLOT_MUSIC_TOF = true;
SAVE_FIGURE = false;

degree2radian = pi/180;             % deg -> rad
radian2degree = 180/pi;
twoPi = 2*pi;


%% �źŲ���
% ����ʵ�ź�
LIGHTSPEED = 3e8;                   % ���� 3*10^8 [m/s]
if ~isRealSignal
    fc = 5.8e9;                         % 5.8GHz
    lambda = LIGHTSPEED/fc;             % Լ3cm

    Nc = 30;                            % number of subcarriers ����Ϊ2
    BW = 40e6;                          % Bandwidth = 20MHz
    Delta_f = BW/Nc;                    % ���ز�Ƶ�ʼ��

    SNR = 10;                           % input SNR (dB) 10dB �����źŹ������������ʵ�10��,10lg10
    samples = 100;                      % ������ 500�� 200

    %% �ྶ��������
    paths = 3;
    if paths == 3
        theta = [-40 10 30];                % ����AoA[deg]
        tau = [73 18 43]*1e-9;              % ����ToA[ns]
    elseif paths == 5
        % �ྶ���� 5·�źţ� ��ע�� -40deg,10ns�͵ڶ���·���ź����Էֿ�
        theta = [-60 -25 10 30 60];         % ����AoA[deg]
        tau = [40 5 50 20 70]*1e-9;         % ����ToA[ns]
    end
end





isCoherent = true;

%{
isCoherent = false;
�Ƿ�����źţ�Gamma = randn(paths,samples)+randn(paths,samples)*1j;
������ź� option�� non-smoothing

isCoherent = true;
����ź� �������Ƿ�����ź�
option�� smoothing ���� non-smoothing
%}





if isCoherent
    if paths <= 3
        CoherentPaths = 1; % �͵�һ��·����ɵ�·������
    elseif paths >=5
        CoherentPaths = 2;
    end
else
    CoherentPaths = 0;
end

if ~isRealSignal
%% ���в���
Nrx = 3;
ant_dist = lambda/2;                % space = lambda/2 [m]

save 'para.mat'
% �����еı�����������para.mat �ļ���
global param  % ��para����Ϊȫ�ֱ���
param = load('para.mat');
end

end

