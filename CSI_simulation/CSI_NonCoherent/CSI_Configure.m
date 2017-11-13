%CSI_Configure
% 
% Developed by Wu Zhiguo(Beijing University of Post and Telecommunication)
% QQ group for discusion: 366102075
% EMAIL:1600682324@qq.com wuzhiguo@bupt.edu.cn
% Github: https://github.com/wuzhiguocarter/Awesome-WiFi-CSI-Research
% Blog: http://www.jianshu.com/c/6e0897ba0cec [WiFi CSI Based Indoor Localization]
function CSI_Configure
%CONFIGURE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

%%
global degree2radian radian2degree twoPi LIGHTSPEED lambda
global Nrx ant_dist alpha
global paths theta tau  
global fc Nc Delta_f BW
global SNR samples
global PLOT_MUSIC_AOA PLOT_MUSIC_TOF
global SAVE_FIGURE isCoherent

PLOT_MUSIC_AOA = true;
PLOT_MUSIC_TOF = true;
SAVE_FIGURE = false;

degree2radian = pi/180;             % deg -> rad
radian2degree = 180/pi;
twoPi = 2*pi;
%% �źŲ���
LIGHTSPEED = 3e8;                   % ���� 3*10^8 [m/s]
fc = 5.8e9;                         % 5.8GHz
lambda = LIGHTSPEED/fc;             % Լ3cm

Nc = 30;                            % number of subcarriers ����Ϊ2
BW = 40e6;                          % Bandwidth = 20MHz
Delta_f = BW/Nc;                    % ���ز�Ƶ�ʼ��

SNR = 10;                           % input SNR (dB) 10dB �����źŹ������������ʵ�10��,10lg10
samples = 100;                      % ������ 500�� 200

%% �ྶ���� 3·�ź�
paths = 3;
    if paths == 3
        theta = [-40 10 30];                % ����AoA[deg]
        tau = [73 18 43]*1e-9;              % ����ToA[ns]
    elseif paths == 5
        % �ྶ���� 5·�źţ� ��ע�� -40deg,10ns�͵ڶ���·���ź����Էֿ�
        theta = [-60 -25 10 30 60];         % ����AoA[deg]
        tau = [40 5 50 20 70]*1e-9;         % ����ToA[ns]
end

isCoherent = false;
if isCoherent
    if paths <= 3
        CoherentPaths = 1; % �͵�һ��·����ɵ�·������
    elseif paths >=5
        CoherentPaths = 2;
    end
else
    CoherentPaths = 0;
end


%% ���в���
alpha = 1;
Nrx = floor(paths*alpha);           % ������Ԫ���������߸����� ����Ϊpaths+1
ant_dist = lambda/2;                % space = lambda/2 [m]

save 'para.mat'
global param
param = load('para.mat');
end

