%% ************************************************************************
%����˵����
%   ��λ��ֵ�˲�
%   input_yΪ�����������
%   mΪ���ݸ���
%   output_yΪ����˲�Ч��
%����˵����
%   2015��6�� by materjay at XMU
%% ************************************************************************
%��Ҫ����
function output_y = medianmean(input_y, m)
n=length(input_y);
k=n/10;
for i=1:k
    mean_y(i)=0;
    for j=1:m
        mean_y(i)=mean_y(i)+input_y((i-1)*10+j);
    end
    output_y(i)=trimmean(mean_y(i),0.4);            %�޳�ͷ��2����β��2��
end
end
