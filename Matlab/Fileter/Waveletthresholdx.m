%%
%小波阀值去噪
%%
function output_y=Waveletthresholdx(input_y,input_level,input_waveletbasis,input_thresholdalgorithm,input_sorh)

%使用小波基对信号进行level层分解
[C,L]=wavedec(input_y,input_level,input_waveletbasis);

for i=1:input_level
    %从分解系数[C,L]这种提取第N层低频近似系数   【app是近似，低频】
    CA{i}=appcoef(C,L,input_waveletbasis,i);
end

for i=1:input_level
    %从分解系数[C,L]这种提取第N层高频细节系数   【det是细节，高频】
    CD{i}=detcoef(C,L,i);
end

for i=1:input_level
    %提取阀值
    THR{i}=thselect(CD{i},input_thresholdalgorithm);
end

for i=1:input_level
    %高频近似系数的阀值处理     
    CDSOFT{i}=newwthresh(CD{i},input_sorh,THR{i});
end

%原最后一层低频近似系数与处理后的高频近似系数重组数组
c_newthreshold=CA{input_level};

for i=input_level:-1:1
    c_newthreshold=[c_newthreshold CDSOFT{i}];
end

%重构信号，得到滤波结果
output_y=waverec(c_newthreshold,L,input_waveletbasis);

end
