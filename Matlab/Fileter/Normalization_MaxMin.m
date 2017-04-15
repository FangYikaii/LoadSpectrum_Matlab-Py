%% ************************************************************************
%程序说明：
%   归一化程序
%   x为被处理的数据
%   maxvalue为数据定义的最大值  minvalue 为数据定义的最小值
%   计算方法：y=(x-MinValue)/(MaxValue-MinValue) 
%   y为归一化后数据输出
%更新说明：
%   2015年6月 by materjay at XMU
%% ************************************************************************
%主要程序：
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