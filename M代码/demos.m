% ʵ�ֶ�ʱ���źŽ�����ɢ����Ҷ�任
function [Xk, base] = demos(xn)
N = length(xn);
n = 0:N-1;
k = 0:N-1;
Wn = exp(-1i*2*pi/N);
base = n'*k; % N*N
Wnnk = Wn.^base;
qq = Wnnk
Xk = xn*Wnnk';
end
% �Զ���ĺ������Դ�������һ���������м�ķ����෴������ģֵ���,������fft ����iffft