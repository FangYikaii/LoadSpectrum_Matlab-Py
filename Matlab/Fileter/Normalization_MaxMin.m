%% ************************************************************************
%����˵����
%   ��һ������
%   xΪ�����������
%   maxvalueΪ���ݶ�������ֵ  minvalue Ϊ���ݶ������Сֵ
%   ���㷽����y=(x-MinValue)/(MaxValue-MinValue) 
%   yΪ��һ�����������
%����˵����
%   2015��6�� by materjay at XMU
%% ************************************************************************
%��Ҫ����
function y = Normalization_MaxMin(x, MaxValue, MinValue)
	n=length(x);
    for i=1:n
        if x(i)>MaxValue
            y(i)=1;
        else
            y(i)=(x(i)-MinValue)/(MaxValue-MinValue);
        end
    end
end