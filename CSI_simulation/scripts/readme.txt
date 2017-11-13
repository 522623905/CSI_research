# %%
# % The MIT License (MIT)
# % Copyright (c) 2017 Wu Zhiguo <wuzhiguo@bupt.edu.cn>
# % 
# % Permission is hereby granted, free of charge, to any person obtaining a 
# % copy of this software and associated documentation files (the "Software"), 
# % to deal in the Software without restriction, including without limitation 
# % the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# % and/or sell copies of the Software, and to permit persons to whom the 
# % Software is furnished to do so, subject to the following conditions:
# % 
# % The above copyright notice and this permission notice shall be included 
# % in all copies or substantial portions of the Software.
# % 
# % THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
# % OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# % FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# % AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
# % LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
# % FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
# % DEALINGS IN THE SOFTWARE.
# %
# %% Some useful scripts for csi collecting
# % 
# % Developed by Wu Zhiguo(Beijing University of Post and Telecommunication)
# % QQ group for discusion: 366102075
# % EMAIL:1600682324@qq.com wuzhiguo@bupt.edu.cn
# % Github: https://github.com/wuzhiguocarter/Awesome-WiFi-CSI-Research
# % Blog: http://www.jianshu.com/c/6e0897ba0cec [WiFi CSI Based Indoor Localization]

�÷�һ������ģʽ
�ɼ�CSI��ͬ���洢���ļ�,ÿ��������һ���µ��ļ����ļ�����ʱ����Զ�����
sudo ./callEveryMin.sh
�ɼ��ļ��Ĳο�Ŀ¼��ͼ������Ŀ¼��tree.txt
ע�⣺
1. �ýű�����client_mode.sh, log2file.sh�Լ�linux-80211n-csitool-supplementary/netlink�ļ����µ�log_to_file��ִ���ļ�
2. ʹ��ǰ��Ҫ���õĲ���
��1��callEveryMin.sh
AP	����Intel 5300Ҫ���ӵ�AP����
Interval����ping����ʱ����
IP	����·����IP��ַ
Attribute�����ɼ�csi�ļ���ǰ׺
��2��log2file.sh
rootDir	��������ɼ���csi�ļ�����·��


�÷�����ʵʱ���ӻ�ģʽ
�ɼ�CSI����ͨ��socketsͨ����Matlab���ӣ�ʵʱ���ӻ�

step1: ��Realtime-processing-for-csitool/network/read_bf_socket.m������linux-80211n-csitool-supplementary/netlink�ļ��£�����������read_bf_socket.m�������ȴ�����

step2: �ɼ�CSI
sudo ./realtime_csi_collecting

step3: ͨ��TCP��CSI������matlab��������read_bf_socket��CSI���ӻ�����
sudo ./log_to_server <ip> <port>

ע�⣺
1. ��ģʽ��ҪRealtime-processing-for-csitool��֧�֣��������https://github.com/lubingxian/Realtime-processing-for-csitool
2. ���ظù��ߣ���Ҫ��netlink�ļ����±���log_to_file������ֱ�Ӱѱ���õĿ�ִ���ļ������������ʹ��


