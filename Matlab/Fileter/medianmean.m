%% ************************************************************************
%程序说明：
%   中位均值滤波
%   input_y为被处理的数据
%   m为数据个数
%   output_y为最后滤波效果
%更新说明：
%   2015年6月 by materjay at XMU
%% ************************************************************************
%主要程序：
function output_y = medianmean(input_y, m)
n=length(input_y);
k=n/10;
for i=1:k
    mean_y(i)=0;
    for j=1:m
        mean_y(i)=mean_y(i)+input_y((i-1)*10+j);
    end
    output_y(i)=trimmean(mean_y(i),0.4);            %剔除头部2个，尾部2个
end
end
