
function [CSI,A] = API_CSI_Generator( theta, tau, paths, ...
                            Nrx,ant_dist,samples, ...
                            fc,Nc,Delta_f,SNR, option)
                        
if nargin == 10 || (nargin == 11 && strcmp(option, 'non-smoothing'))
	%����������90*paths�ľ����൱����90����Ԫ(3*30)
    A = zeros(Nrx*Nc,paths); % 90 * paths
    X = zeros(Nrx*Nc,samples); % 90 * samples
    CSI = zeros(Nrx*Nc,samples); % 90 * samples
	
elseif nargin == 11 && strcmp(option, 'smoothing')  % �Լ��޸ã�ԭ����'non-smoothing'
    sizeSubArray = ceil(Nrx/2)*ceil(Nc/2); % 30
    A = zeros(sizeSubArray,paths); % 30 * paths 
    nSubArray = ceil(Nrx/2)*(Nc-ceil(Nc/2)+1); % 32
    X = zeros(sizeSubArray,nSubArray,samples); % 30 * 32 * samples
    CSI = zeros(sizeSubArray,nSubArray,samples); % 30 * 32 * samples
end

% ����ʸ���Ĺ���Ҫ�����;��󡰶��롱������option�����������������Ĺ�����ʽ
for ipath = 1:paths
    A(:,ipath) = util_steering_aoa_tof(theta(ipath),tau(ipath), ...
                                        Nrx,ant_dist,fc,Nc,Delta_f, option);
end
% ���㵼��ʸ����ע�����������ɵ��źţ���������ʵ���źţ�·��������paths����֪��
% ��������������ĵ���ʸ���Ϳ���
% �������ʵ���ź�·������δ֪����ô�����õ�aoa�Լ�tofʸ��
% ����ÿ��aoa �Լ�tof �����ɵ���ʸ��
% aoa = -90:1:90;       % -90~90 [deg]
% tof = (0:1:100)*1e-9; % 1~100 [ns]

% isCoherent = true; ������ź�
% �ź���ɣ�Ƶ����ͬ����λ��㶨


% ���������źŴ���ʲô�� �����������CoherentPaths��(CoherentPaths·)����������صģ�
% ����ComplexConst�������ݵĵ�һ�У��������paths��(paths·�ź�)��ȫ������
% ƽ���Ͳ�ƽ�����Ǵ���ʲô��ƽ���������ɸ��������SubArray 32�� ����
% ����������ʲô�� ���ƴ���ͬ�����ز���
%{
Find all peaks of MUSIC spectrum: 
Calculated AoA: 28  30  33 [deg] 
Calculated ToF: 18  43  73 [ns]

Find Direct Path AoA and ToF: 
(AOA, ToF) =  (10 [deg], 18 [ns]) 

ע������Ĺ��ƽ����tof�ǰ�С����������򣬶�LOS��tofҲ�ǰ���ʱ���С��������
��LOStof�� Calculated ToF�У���	Calculated AoA�ļ������ǰ��սǶȴ�С�������
��δ������Ӧtofֵ�Ĵ�С�����LOS��AOA����Calculated AoA��
%}

global isCoherent CoherentPaths
if isCoherent % ���������Դ
    Gamma_temp = randn(paths - CoherentPaths, samples) + ...
		randn(paths - CoherentPaths, samples)*1j; % complex attuation(�������Դ)
    ComplexConst = randn+1j*randn;
    % �������һ���Ͷ���·���ź���ɵĽ����ź�
    if strcmp(option,'non-smoothing')
        Gamma = [Gamma_temp; ComplexConst*repmat(Gamma_temp(1,:),CoherentPaths,1)];
		% ���CoherentPaths����أ���
		% Gamma paths * samples
		 % ���ڷ�ƽ����1��paths * samples ������ƽ����ʽ��nSubArray��paths * samples����
    elseif strcmp(option,'smoothing')
	% ����ƽ���� nSubArray��paths * samples
        nSubArray = ceil(Nrx/2)*(Nc - ceil(Nc/2)+1); % 32 = 2*16
        Gamma = cell(nSubArray,1);
        for iSubArray = 1:nSubArray
            % ��ͬ�����˥���������ͬ���ĵ�˥�����
            Gamma_temp = randn(paths-CoherentPaths,samples) + ...
				randn(paths-CoherentPaths,samples)*1j; % complex attuation(�������Դ)
            ComplexConst = randn+1j*randn;
            Gamma{iSubArray} = [Gamma_temp; ComplexConst*repmat(Gamma_temp(1,:), CoherentPaths, 1)];
        end
    end
else
	% ������ź�Դ
    Gamma = randn(paths,samples)+randn(paths,samples)*1j; % complex attuation
end

global lambda
if nargin == 10 || (nargin == 11 && strcmp(option, 'non-smoothing'))
    X = A*Gamma; % 90*paths * paths*samples = 90*samples
    CSI =awgn(X,SNR,'measured'); % 90*samples
    save('CSI.mat','CSI', 'A');
	% ������CSI �Լ�A�����浽CSI.mat��
elseif nargin == 11 && strcmp(option, 'smoothing')
	% ����smoothing��CSI���ݵĹ��첻��ֱ��A F����� ����
    nSubArray = ceil(Nrx/2)*(Nc-ceil(Nc/2)+1); % 32
    beta = 2*pi*ant_dist*sin(theta)/lambda; %D beta�ĳ��Ⱦ���theta�ĳ��ȣ���pathsͬ����
    D = diag(exp(-1j*beta)); % paths * paths
    for iSubArray = 1: nSubArray
        if iSubArray <= nSubArray/2
            X(:,iSubArray,:) = A*D^(iSubArray-1)*Gamma{iSubArray};
			% 30*paths * paths*paths * paths*samples = 30*samples
			% ��һ���־��ǿռ�ƽ���������
        else
            Phi = exp(-1j*2*pi*1*ant_dist*sin(theta*pi/180)/lambda);
            D = D*diag(Phi);
            X(:,iSubArray,:) = A*D.^(iSubArray-1)*Gamma{iSubArray};
        end
        CSI(:,iSubArray,:) = awgn(squeeze(X(:,iSubArray,:)),SNR,'measured');
    end
    save('CSI.mat','CSI', 'A');
end
end