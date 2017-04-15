function FindCycle(data,Driver,Object,Power,outputfile)
    PressureOrginValue_TIME=(data(:,1))';
    PressureOrginValue_GZB=(data(:,2))';
    PressureOrginValue_DBDQ=(data(:,3))';
    PressureOrginValue_ZDDQ=(data(:,7))';    
    %% ******************************************************************************************************************************************
    %% �ɵ��ڲ���
    %% ******************************************************************************************************************************************
    %�غ��׼�Ȩ�ں�ǰƽ���˲���������
    SMOOTHFILTERINGTIME=1;     %������ 
    %����ʱ��ε���ȡ���ʱ�� ��λ0.1s
    MINICONTINUOUSTIME=50;    %�ɵ��� 

    %���ݶ�ֵ��������ʱ��εĳ��ȵľ������ģ����й�һ�������,��ȡ��һ����ҵ��(��ֵ1)����0.5��ֵ,����ҵ��(��ֵ0)����0.2
    MINNORIMALVALUE_HIGH=0.6;   %�ɵ���
    MINNORIMALVALUE_LOW=0.2;
    %��ҵ�ε���һ�ν���ʱ�������һ�ο�ʼʱ������С����
    MINENDTOSTART =10;
    %% ******************************************************************************************************************************************
    %% ���ݲ���Ƶ����100HzתΪ10Hz��������λ��ֵ�˲����д���
    %% ******************************************************************************************************************************************
    % ��λ��ֵ�˲�
    n=length(PressureOrginValue_TIME)/10;
    for j=1:n
        Pressure10HzValue_TIME{1}(j)=0.1+(j-1)*0.1;
    end    
    Pressure10HzValue_GZB=medianmean(PressureOrginValue_GZB, 10);    
    Pressure10HzValue_DBDQ=medianmean(PressureOrginValue_DBDQ, 10);
    Pressure10HzValue_ZDDQ=medianmean(PressureOrginValue_ZDDQ, 10);
    %% ******************************************************************************************************************************************
    %% �غ������ݹ�һ������
    %% ******************************************************************************************************************************************
    PressureNormialValue_TIME=Pressure10HzValue_TIME;
    PressureNormialValue_GZB=mapminmax( Pressure10HzValue_GZB,0,1);     
    PressureNormialValue_DBDQ=mapminmax( Pressure10HzValue_DBDQ,0,1);
    PressureNormialValue_ZDDQ=mapminmax( Pressure10HzValue_ZDDQ,0,1);     

    %% ******************************************************************************************************************************************
    %% �غ��������˲�����
    %% ******************************************************************************************************************************************
    % ƽ���˲�����
     PressureFilteringValue{1}=PressureNormialValue_TIME{1};
     PressureFilteringValue{2}=SmoothingFiltering(PressureNormialValue_GZB, 7, 1, SMOOTHFILTERINGTIME);     
     PressureFilteringValue{3}=SmoothingFiltering(PressureNormialValue_DBDQ, 7, 1, SMOOTHFILTERINGTIME);
     PressureFilteringValue{4}=SmoothingFiltering(PressureNormialValue_ZDDQ, 7, 1, SMOOTHFILTERINGTIME);  
    %% ******************************************************************************************************************************************
    %% �غ�������ģ��������
    %% ******************************************************************************************************************************************
    %% ģ��������
    PressureFuzzyValue{1}=PressureFilteringValue{1};
    % �����ͱ�ѹ��
    for j=1:length(PressureFilteringValue{2});
        if(PressureFilteringValue{2}(j)>0.4)
           PressureFuzzyValue{2}(j)=1;
        elseif (PressureFilteringValue{2}(j)>0.3)
           PressureFuzzyValue{2}(j)=2*(5*PressureFilteringValue{2}(j)-1)^2;
        elseif (PressureFilteringValue{2}(j)>0.2)
           PressureFuzzyValue{2}(j)=1-2*(5*PressureFilteringValue{2}(j)-2)^2;        
        else
           PressureFuzzyValue{2}(j)=0;        
        end
    end

    % ���۴�ǻѹ��
    for j=1:length(PressureFilteringValue{3});
        if(PressureFilteringValue{3}(j)>0.4)
           PressureFuzzyValue{3}(j)=1;
        elseif (PressureFilteringValue{3}(j)>0.3)
           PressureFuzzyValue{3}(j)=2*(5*PressureFilteringValue{3}(j)-1)^2;
        elseif (PressureFilteringValue{3}(j)>0.2)
           PressureFuzzyValue{3}(j)=1-2*(5*PressureFilteringValue{3}(j)-2)^2;        
        else
           PressureFuzzyValue{3}(j)=0;        
        end
    end

    for j=1:length(PressureFilteringValue{4});
        if(PressureFilteringValue{4}(j)>0.4)
           PressureFuzzyValue{4}(j)=1;
        elseif (PressureFilteringValue{4}(j)>0.3)
           PressureFuzzyValue{4}(j)=2*(5*PressureFilteringValue{4}(j)-1)^2;
        elseif (PressureFilteringValue{4}(j)>0.2)
           PressureFuzzyValue{4}(j)=1-2*(5*PressureFilteringValue{4}(j)-2)^2;        
        else
           PressureFuzzyValue{4}(j)=0;        
        end
    end    

    %% ģ������ -1 0 1

    for j=1:length(PressureFilteringValue{2});

        % �����ͱ�ѹ��
        if PressureFuzzyValue{2}(j)>0.75
            PressureFuzzyValue{2}(j)=1;
        elseif PressureFuzzyValue{2}(j)<0.25
            PressureFuzzyValue{2}(j)=-1;
        else
            PressureFuzzyValue{2}(j)=0;
        end

        % ���۴�ǻѹ��        
        if PressureFuzzyValue{3}(j)>0.75
            PressureFuzzyValue{3}(j)=1;
        elseif PressureFuzzyValue{3}(j)<0.25
            PressureFuzzyValue{3}(j)=-1;
        else
            PressureFuzzyValue{3}(j)=0;
        end 

        % ת����ǻѹ��           
        if PressureFuzzyValue{4}(j)>0.75
            PressureFuzzyValue{4}(j)=1;
        elseif PressureFuzzyValue{4}(j)<0.25
            PressureFuzzyValue{4}(j)=-1;
        else
            PressureFuzzyValue{4}(j)=0;
        end 

    end    

    %% ******************************************************************************************************************************************
    %% �غ������ݼ�Ȩ�ں�,����ֵ������ 1 -- ��ҵ  0 -- ����ҵ
    %% ******************************************************************************************************************************************

    for i=1:1


        % ��Ȩƽ������
        PressureWeightingValue{1}=PressureFuzzyValue{1};
    %     ����ѹ����Ȩ��ֵ    
    %     PressureWeightingValue{2}=(PressureFuzzyValue{2}+PressureFuzzyValue{3}+PressureFuzzyValue{4})/3;
        % ����ѹ����Ȩ��ֵ
    %     PressureWeightingValue{2}=(PressureFuzzyValue{3}+PressureFuzzyValue{4})/2; 
        % һ��ѹ����Ȩ��ֵ
        PressureWeightingValue{2}=PressureFuzzyValue{4};     


        %��ֵ������
        for j=1:length(PressureWeightingValue{1})
            if(PressureWeightingValue{2}(j)>0)
               PressureWeightingValue{2}(j)=1;
            elseif (PressureWeightingValue{2}(j)<=0)  
               PressureWeightingValue{2}(j)=0;       
            end
        end   
    end

    %% ******************************************************************************************************************************************
    %% ��ֵ��������ʱ��εĳ�����ȡ   ���޸ı���>MINICONTINUOUSTIME(50��5s����)��Ϊ����ֵ
    %% ******************************************************************************************************************************************

    % ͳ�ƶ�ֵ���������ʱ��εĳ���
    n=length(PressureWeightingValue{1});
    %��ʱ����
    mi=1;
    mj=1;
    ms=PressureWeightingValue{2}(1);
    for j=2:n
        if(PressureWeightingValue{2}(j)==ms)
            mi=mi+1;    
        else
            statistical_value(mj)=ms;            %��¼ͳ�Ƶ�ֵ����Ӧ��ʱ�䳤�ȡ���ʼʱ��㡢����ʱ���
            if mi>= MINICONTINUOUSTIME
               statistical_length(mj)=mi;   
            else
               statistical_length(mj)=0; 
            end
            statistical_starttime(mj)=PressureWeightingValue{1}(j-mi);    
            statistical_endtime(mj)=PressureWeightingValue{1}(j);              
            mj=mj+1;
            ms=PressureWeightingValue{2}(j);
            mi=1;
        end       
    end  
    % ����ֵ����1��0�ĳ��ȷ���
    n=length(statistical_value);
    for j=1:n
        statistical_1_length(j)=statistical_length(j);
        statistical_0_length(j)=statistical_length(j); 
        if(statistical_value(j)==1)
            statistical_0_length(j)=0;         %������ֵ����
        else
            statistical_1_length(j)=0;           %������ֵ����
        end       
    end
    statistical_1_value=statistical_value;
    statistical_0_value=statistical_value;    
    statistical_1_endtime=statistical_endtime;
    statistical_0_endtime=statistical_endtime;       
    statistical_1_starttime=statistical_starttime;
    statistical_0_starttime=statistical_starttime;

    %% ******************************************************************************************************************************************
    %% ��ֵ��������ʱ��εĳ��ȵľ������� 
    %% ******************************************************************************************************************************************

    % Ѱ�Ҿ�������
    mi=1;
    mj=1;
    for j=1:length(statistical_1_endtime)

        if statistical_1_length(j)>0
            x1(mi)=1;
            y1(mi)=statistical_1_length(j);
            mi=mi+1;
        end
        if statistical_0_length(j)>0
            x0(mj)=2;
            y0(mj)=statistical_0_length(j);
            mj=mj+1;
        end
    end      
    centervalue1=[x1;y1]';
    centervalue0=[x0;y0]';  
    [idy1 centery1]=DIYKmeans(centervalue1,1);  
    [idy0 centery0]=DIYKmeans(centervalue0,1);
    %% ******************************************************************************************************************************************
    %% ���ݶ�ֵ��������ʱ��εĳ��ȵľ������ģ����й�һ������ 
    %% ******************************************************************************************************************************************
    statistical_1_Normallength=Normalization_MaxMin(statistical_1_length, centery1(:,2), 0);
    statistical_0_Normallength=Normalization_MaxMin(statistical_0_length, centery0(:,2), 0);    
    %% ******************************************************************************************************************************************
    %% ���ݶ�ֵ��������ʱ��εĳ��ȵľ������ģ����й�һ�������,��ȡ��һ����ҵ��(��ֵ1)����0.5��ֵ,����ҵ��(��ֵ0)����0.2 
    %% ******************************************************************************************************************************************
    mi=1;
    for j=1:length(statistical_1_Normallength)
        if statistical_1_Normallength(j)> MINNORIMALVALUE_HIGH   %��ȡ��ҵ��
            statistical_1_NormalBiggerlength(mi)=statistical_1_Normallength(j);
            statistical_1_NormalBiggerendtime(mi)=statistical_1_endtime(j);
            statistical_1_NormalBiggerstarttime(mi)=statistical_1_starttime(j);            
            mi=mi+1;
        end      
    end
    mi=1;  
    for j=1:length(statistical_0_Normallength)
        if statistical_0_Normallength(j)> MINNORIMALVALUE_LOW    %��ȡ����ҵ��
            statistical_0_NormalBiggerlength(mi)=statistical_0_Normallength(j);
            statistical_0_NormalBiggerendtime(mi)=statistical_0_endtime(j);
            statistical_0_NormalBiggerstarttime(mi)=statistical_0_starttime(j);
            mi=mi+1;
        end      
    end      
    %% ******************************************************************************************************************************************
    %% �ϲ���ҵ�������ڸ���ԭ���µ�ԭ�����������Σ��ֱ�Ϊ�������ε��߶�
    %% ******************************************************************************************************************************************
    n=length(statistical_1_NormalBiggerlength);
    % Ѱ�Ҳ�����Ҫ��ļ���
    for j=1:n-1
        if (statistical_1_NormalBiggerstarttime(j+1)-statistical_1_NormalBiggerendtime(j))<MINENDTOSTART %��һ�ν����㵽��һ�ο�ʼ�����С��Ҫ����
            statistical_1_NormalBiggerendstart(j)=0;
        else
            statistical_1_NormalBiggerendstart(j)=1;
        end
    end
    % �ϲ����Ժϲ��������߶�
    mi=1;
    statistical_1_NormalBiggerNewstarttime(mi)=statistical_1_NormalBiggerstarttime(mi);   
    statistical_1_NormalBiggerNewlength(mi)=statistical_1_NormalBiggerlength(mi);
    for j=1:n-1
       if statistical_1_NormalBiggerendstart(j) == 1
           statistical_1_NormalBiggerNewendtime(mi)=statistical_1_NormalBiggerendtime(j);
           mi=mi+1;
           statistical_1_NormalBiggerNewstarttime(mi)=statistical_1_NormalBiggerstarttime(j+1);  
           statistical_1_NormalBiggerNewlength(mi)=statistical_1_NormalBiggerlength(j+1);
       end      
    end
    statistical_1_NormalBiggerNewendtime(mi)=statistical_1_NormalBiggerendtime(n);
    statistical_1_NormalBiggerNewlength(mi)=statistical_1_NormalBiggerlength(n);  
    clear statistical_1_NormalBiggerendtime;
    clear statistical_1_NormalBiggerstarttime;
    clear statistical_1_NormalBiggerlength;   
    statistical_1_NormalBiggerendtime=statistical_1_NormalBiggerNewendtime;
    statistical_1_NormalBiggerstarttime=statistical_1_NormalBiggerNewstarttime;
    statistical_1_NormalBiggerlength=statistical_1_NormalBiggerNewlength;  
    %% ******************************************************************************************************************************************
    %% ������ҵ�����ҵ����ʱ��λ�����ҵѭ������ 
    %% ******************************************************************************************************************************************
    % ����ҵ������Ϊ��׼�����Ȳ������ұߵķ���ҵ������㣬���ߵ��е���Ϊ���εķֽ�� 
    for mi=1:(length(statistical_1_NormalBiggerendtime)-1)
        for mj=1:length(statistical_0_NormalBiggerendtime)
           if statistical_1_NormalBiggerendtime(mi)<statistical_0_NormalBiggerendtime(mj)
               SegmentedTimePoint(mi)=(statistical_1_NormalBiggerendtime(mi)+statistical_0_NormalBiggerendtime(mj))/2;
               SegmentedTimePointValue(mi)=1;   
               break;
           end        
        end   
    end
    %% ******************************************************************************************************************************************
    %% ������ҵѭ������������ȡ
    %% ******************************************************************************************************************************************
    % ԭʼ�����ܸ���
    [n,width]=size(data);
    % �ֶε����
    m=length(SegmentedTimePoint);
    % �ֶ���ʼ��
    mk=1;
    % ǰN-1��������ȡ
    for mi=1:m
        for mj=mk:n
            % ��ȡ��������
            if PressureOrginValue_TIME(mj)<SegmentedTimePoint(mi)
                data_out{mi}(mj-mk+1,:)=data(mj,:);
            else
                mk=round(SegmentedTimePoint(mi)*100);
                break;
            end           
        end      
    end
    % ��N��������ȡ   
    mk=round(SegmentedTimePoint(m)*100);
    for mj=mk:n
        data_out{m+1}(mj-mk+1,:)=data(mj,:); 
    end 
    %% ******************************************************************************************************************************************
    %% �������ݿ�
    %% ******************************************************************************************************************************************
    
    FileTextName = strcat(outputfile,'\',Object, '-', Power, '-', Driver);
    mkdir(FileTextName);
    for i=1:length(data_out)
        name{i}=strcat(FileTextName,'\',num2str(i));
        csvwrite([name{i} '.csv'] ,data_out{i});
    end
end