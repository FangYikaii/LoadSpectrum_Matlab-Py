%%
%С����ֵȥ��
%%
function output_y=Waveletthresholdx(input_y,input_level,input_waveletbasis,input_thresholdalgorithm,input_sorh)

%ʹ��С�������źŽ���level��ֽ�
[C,L]=wavedec(input_y,input_level,input_waveletbasis);

for i=1:input_level
    %�ӷֽ�ϵ��[C,L]������ȡ��N���Ƶ����ϵ��   ��app�ǽ��ƣ���Ƶ��
    CA{i}=appcoef(C,L,input_waveletbasis,i);
end

for i=1:input_level
    %�ӷֽ�ϵ��[C,L]������ȡ��N���Ƶϸ��ϵ��   ��det��ϸ�ڣ���Ƶ��
    CD{i}=detcoef(C,L,i);
end

for i=1:input_level
    %��ȡ��ֵ
    THR{i}=thselect(CD{i},input_thresholdalgorithm);
end

for i=1:input_level
    %��Ƶ����ϵ���ķ�ֵ����     
    CDSOFT{i}=newwthresh(CD{i},input_sorh,THR{i});
end

%ԭ���һ���Ƶ����ϵ���봦���ĸ�Ƶ����ϵ����������
c_newthreshold=CA{input_level};

for i=input_level:-1:1
    c_newthreshold=[c_newthreshold CDSOFT{i}];
end

%�ع��źţ��õ��˲����
output_y=waverec(c_newthreshold,L,input_waveletbasis);

end
