function FindCycle(data,Driver,Object,Power,outputfile)
    PressureOrginValue_TIME=(data(:,1))';
    PressureOrginValue_GZB=(data(:,2))';
    PressureOrginValue_DBDQ=(data(:,3))';
    PressureOrginValue_ZDDQ=(data(:,7))';    
    %% ******************************************************************************************************************************************
    %% 可调节参数
    %% ******************************************************************************************************************************************
    %载荷谱加权融合前平滑滤波迭代次数
    SMOOTHFILTERINGTIME=1;     %不调整 
    %连续时间段的提取最短时间 单位0.1s
    MINICONTINUOUSTIME=50;    %可调整 

    %依据二值化后连续时间段的长度的聚类中心，进行归一化处理后,提取归一化作业段(高值1)大于0.5的值,非作业段(低值0)大于0.2
    MINNORIMALVALUE_HIGH=0.6;   %可调整
    MINNORIMALVALUE_LOW=0.2;
    %作业段的上一次结束时间点与下一次开始时间点的最小距离
    MINENDTOSTART =10;
    %% ******************************************************************************************************************************************
    %% 数据采样频率由100Hz转为10Hz，采用中位均值滤波进行处理
    %% ******************************************************************************************************************************************
    % 中位均值滤波
    n=length(PressureOrginValue_TIME)/10;
    for j=1:n
        Pressure10HzValue_TIME{1}(j)=0.1+(j-1)*0.1;
    end    
    Pressure10HzValue_GZB=medianmean(PressureOrginValue_GZB, 10);    
    Pressure10HzValue_DBDQ=medianmean(PressureOrginValue_DBDQ, 10);
    Pressure10HzValue_ZDDQ=medianmean(PressureOrginValue_ZDDQ, 10);
    %% ******************************************************************************************************************************************
    %% 载荷谱数据归一化处理
    %% ******************************************************************************************************************************************
    PressureNormialValue_TIME=Pressure10HzValue_TIME;
    PressureNormialValue_GZB=mapminmax( Pressure10HzValue_GZB,0,1);     
    PressureNormialValue_DBDQ=mapminmax( Pressure10HzValue_DBDQ,0,1);
    PressureNormialValue_ZDDQ=mapminmax( Pressure10HzValue_ZDDQ,0,1);     

    %% ******************************************************************************************************************************************
    %% 载荷谱数据滤波处理
    %% ******************************************************************************************************************************************
    % 平滑滤波处理
     PressureFilteringValue{1}=PressureNormialValue_TIME{1};
     PressureFilteringValue{2}=SmoothingFiltering(PressureNormialValue_GZB, 7, 1, SMOOTHFILTERINGTIME);     
     PressureFilteringValue{3}=SmoothingFiltering(PressureNormialValue_DBDQ, 7, 1, SMOOTHFILTERINGTIME);
     PressureFilteringValue{4}=SmoothingFiltering(PressureNormialValue_ZDDQ, 7, 1, SMOOTHFILTERINGTIME);  
    %% ******************************************************************************************************************************************
    %% 载荷谱数据模糊化处理
    %% ******************************************************************************************************************************************
    %% 模糊化处理
    PressureFuzzyValue{1}=PressureFilteringValue{1};
    % 工作油泵压力
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

    % 动臂大腔压力
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

    %% 模糊归类 -1 0 1

    for j=1:length(PressureFilteringValue{2});

        % 工作油泵压力
        if PressureFuzzyValue{2}(j)>0.75
            PressureFuzzyValue{2}(j)=1;
        elseif PressureFuzzyValue{2}(j)<0.25
            PressureFuzzyValue{2}(j)=-1;
        else
            PressureFuzzyValue{2}(j)=0;
        end

        % 动臂大腔压力        
        if PressureFuzzyValue{3}(j)>0.75
            PressureFuzzyValue{3}(j)=1;
        elseif PressureFuzzyValue{3}(j)<0.25
            PressureFuzzyValue{3}(j)=-1;
        else
            PressureFuzzyValue{3}(j)=0;
        end 

        % 转斗大腔压力           
        if PressureFuzzyValue{4}(j)>0.75
            PressureFuzzyValue{4}(j)=1;
        elseif PressureFuzzyValue{4}(j)<0.25
            PressureFuzzyValue{4}(j)=-1;
        else
            PressureFuzzyValue{4}(j)=0;
        end 

    end    

    %% ******************************************************************************************************************************************
    %% 载荷谱数据加权融合,并二值化处理 1 -- 作业  0 -- 非作业
    %% ******************************************************************************************************************************************

    for i=1:1


        % 加权平均处理
        PressureWeightingValue{1}=PressureFuzzyValue{1};
    %     三种压力加权均值    
    %     PressureWeightingValue{2}=(PressureFuzzyValue{2}+PressureFuzzyValue{3}+PressureFuzzyValue{4})/3;
        % 两种压力加权均值
    %     PressureWeightingValue{2}=(PressureFuzzyValue{3}+PressureFuzzyValue{4})/2; 
        % 一种压力加权均值
        PressureWeightingValue{2}=PressureFuzzyValue{4};     


        %二值化处理
        for j=1:length(PressureWeightingValue{1})
            if(PressureWeightingValue{2}(j)>0)
               PressureWeightingValue{2}(j)=1;
            elseif (PressureWeightingValue{2}(j)<=0)  
               PressureWeightingValue{2}(j)=0;       
            end
        end   
    end

    %% ******************************************************************************************************************************************
    %% 二值化后连续时间段的长度提取   可修改变量>MINICONTINUOUSTIME(50及5s以上)的为正常值
    %% ******************************************************************************************************************************************

    % 统计二值化后的连续时间段的长度
    n=length(PressureWeightingValue{1});
    %临时变量
    mi=1;
    mj=1;
    ms=PressureWeightingValue{2}(1);
    for j=2:n
        if(PressureWeightingValue{2}(j)==ms)
            mi=mi+1;    
        else
            statistical_value(mj)=ms;            %记录统计的值及对应的时间长度、起始时间点、结束时间点
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
    % 将二值化的1和0的长度分类
    n=length(statistical_value);
    for j=1:n
        statistical_1_length(j)=statistical_length(j);
        statistical_0_length(j)=statistical_length(j); 
        if(statistical_value(j)==1)
            statistical_0_length(j)=0;         %保留低值部分
        else
            statistical_1_length(j)=0;           %保留高值部分
        end       
    end
    statistical_1_value=statistical_value;
    statistical_0_value=statistical_value;    
    statistical_1_endtime=statistical_endtime;
    statistical_0_endtime=statistical_endtime;       
    statistical_1_starttime=statistical_starttime;
    statistical_0_starttime=statistical_starttime;

    %% ******************************************************************************************************************************************
    %% 二值化后连续时间段的长度的聚类中心 
    %% ******************************************************************************************************************************************

    % 寻找聚类中心
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
    %% 依据二值化后连续时间段的长度的聚类中心，进行归一化处理 
    %% ******************************************************************************************************************************************
    statistical_1_Normallength=Normalization_MaxMin(statistical_1_length, centery1(:,2), 0);
    statistical_0_Normallength=Normalization_MaxMin(statistical_0_length, centery0(:,2), 0);    
    %% ******************************************************************************************************************************************
    %% 依据二值化后连续时间段的长度的聚类中心，进行归一化处理后,提取归一化作业段(高值1)大于0.5的值,非作业段(低值0)大于0.2 
    %% ******************************************************************************************************************************************
    mi=1;
    for j=1:length(statistical_1_Normallength)
        if statistical_1_Normallength(j)> MINNORIMALVALUE_HIGH   %提取作业段
            statistical_1_NormalBiggerlength(mi)=statistical_1_Normallength(j);
            statistical_1_NormalBiggerendtime(mi)=statistical_1_endtime(j);
            statistical_1_NormalBiggerstarttime(mi)=statistical_1_starttime(j);            
            mi=mi+1;
        end      
    end
    mi=1;  
    for j=1:length(statistical_0_Normallength)
        if statistical_0_Normallength(j)> MINNORIMALVALUE_LOW    %提取非作业段
            statistical_0_NormalBiggerlength(mi)=statistical_0_Normallength(j);
            statistical_0_NormalBiggerendtime(mi)=statistical_0_endtime(j);
            statistical_0_NormalBiggerstarttime(mi)=statistical_0_starttime(j);
            mi=mi+1;
        end      
    end      
    %% ******************************************************************************************************************************************
    %% 合并作业段中由于个别原因导致的原本属于连续段，现变为不连续段的线段
    %% ******************************************************************************************************************************************
    n=length(statistical_1_NormalBiggerlength);
    % 寻找不符合要求的间距点
    for j=1:n-1
        if (statistical_1_NormalBiggerstarttime(j+1)-statistical_1_NormalBiggerendtime(j))<MINENDTOSTART %上一次结束点到下一次开始点的最小需要距离
            statistical_1_NormalBiggerendstart(j)=0;
        else
            statistical_1_NormalBiggerendstart(j)=1;
        end
    end
    % 合并可以合并的连续线段
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
    %% 根据作业与非作业连续时间段划分作业循环周期 
    %% ******************************************************************************************************************************************
    % 以作业段数量为标准，首先查找其右边的非作业段最近点，两者的中点作为各段的分解点 
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
    %% 单独作业循环周期数据提取
    %% ******************************************************************************************************************************************
    % 原始数据总个数
    [n,width]=size(data);
    % 分段点个数
    m=length(SegmentedTimePoint);
    % 分段起始点
    mk=1;
    % 前N-1段数据提取
    for mi=1:m
        for mj=mk:n
            % 提取各段数据
            if PressureOrginValue_TIME(mj)<SegmentedTimePoint(mi)
                data_out{mi}(mj-mk+1,:)=data(mj,:);
            else
                mk=round(SegmentedTimePoint(mi)*100);
                break;
            end           
        end      
    end
    % 第N段数据提取   
    mk=round(SegmentedTimePoint(m)*100);
    for mj=mk:n
        data_out{m+1}(mj-mk+1,:)=data(mj,:); 
    end 
    %% ******************************************************************************************************************************************
    %% 存入数据库
    %% ******************************************************************************************************************************************
    
    FileTextName = strcat(outputfile,'\',Object, '-', Power, '-', Driver);
    mkdir(FileTextName);
    for i=1:length(data_out)
        name{i}=strcat(FileTextName,'\',num2str(i));
        csvwrite([name{i} '.csv'] ,data_out{i});
    end
end