%%
y = round(rand(1,10000)*100);
yMax=max(y);
yMin=min(y);
x=linspace(yMin,yMax,1000);
yy=hist(y,x);  % ͳ�Ƶ���ֵĸ���
yy=yy / length(y); % ����������Ϊ����
subplot(221);
bar(x,yy);
subplot(222);
hist(y,x);
%%
meanval = 0;
var = 3;
cnt = 10000;
data = normrnd(meanval, var, [1, cnt]);
% data = rand(1,1000);
% data = round(data);
n = linspace(min(data), max(data), 10);
subplot(223);
hist(data,1000);
%%
meanval = 5;
var = 1;
cnt = 10000;
data = normrnd(meanval, var, [1, cnt]);
% data = round(data); % ȡ�����������ݵĶ�����
n = linspace(min(data), max(data), 10000);
subplot(224);
hist(data,n);