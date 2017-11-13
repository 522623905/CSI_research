%%% DOA estimation by  spatial smoothing or modified spatial smoothing
% Developed by xiaofei zhang (�Ͼ����պ����ѧ ���ӹ���ϵ ��С�ɣ�
% EMAIL:zhangxiaofei@nuaa.edu.cn
clear all;
close all;
SNR = 10;
derad = pi/180; % deg -> rad
radeg = 180/pi;
twpi = 2*pi;
Melm = 7; %��Ԫ��
kelm = 6;  % ������Ԫ��
dd = 0.5; % ���߾���
d=0:dd:(Melm-1)*dd;
theta = [-50 0 30 45 60];
paths = length(theta); % ��Դ�� 
samples = 100; % ������
A=exp(-j*twpi*d.'*sin(theta*derad)); % ������� 7*3
coherentPath = 2;
S0=randn(paths-coherentPath, samples);
ComplexConst = randn+1j*randn;
S = [S0; ComplexConst*repmat(S0(1, :), coherentPath, 1)];  % ����źţ���˥��ϵ��
X0 = A*S;
X=awgn(X0, SNR, 'measured'); % ����CSI�����߽��յ�����
Rxxm=X*X'/samples; % ��Э�������
issp = 2;
%%
% spatial smoothing music
if issp == 1
  Rxx = ssp(Rxxm, kelm); % ֻ�����Խ��ߵ�����������
elseif issp == 2
  Rxx = mssp(Rxxm, kelm); % ˫��ƽ����ʽ
else
  Rxx = Rxxm;
  kelm = Melm;
end
% Rxx
[EV,D]=eig(Rxx);
EVA=diag(D)'; 
[EVA,I]=sort(EVA);
EVA
EVA=fliplr(EVA);
EV=fliplr(EV(:,I));

% ����
for iang = 1:361
        angle(iang) = (iang - 181) / 2;
        phim = derad*angle(iang);
        a = exp(-j*twpi*d(1:kelm)*sin(phim)).'; % �����ĵ���ʸ��
        % ����ʸ��Ҫ���������Ͷ��룬���;���ԭ����M*paths�ģ���Ϊ�����˿ռ�ƽ��(�������п׾�������Э�������ά�Ƚ���)
        % �������ڵ���ʸ����ά�Ȳ���M������size(d(1: kelm)), kelm��ƽ����Э��������ά�ȣ�Ҳ���������Ԫ��
        L = paths; % ��Դ��
        En = EV(:, L+1:kelm); % �����ӿռ�
        SP(iang) = (a'*a) / (a'*En*En'*a);
end
   
SP = abs(SP);
SPmax = max(SP);
SP=10*log10(SP/SPmax);
%SP=SP/SPmax;
figure(1);
h=plot(angle, SP);
set(h,'Linewidth',2)
xlabel('angle (degree)')
ylabel('magnitude (dB)')
axis([-90 90 -60 0])
set(gca, 'XTick',[-90:10:90], 'YTick',[-60:10:0])
grid on; hold on;
legend('ƽ��MUSIC');

 