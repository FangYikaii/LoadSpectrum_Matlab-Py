function y=ExtractCycle(data,Driver,Object,Power,number,outputfile)
    %% ******************************************************************************************************************************************
    %% 可调节参数
    %% ******************************************************************************************************************************************
    %载荷谱加权融合前平滑滤波迭代次数
    SMOOTHFILTERINGTIME=100;     %可调整 
    % 载荷谱作业循环段中转斗压力的曲线变化率计算--计算间隔 即几点求一次变化率
    INTERVALPOINTS=5;
    %转斗大腔压力变化率的提取值
    EXTRACTCHANGERATE=0.5;
    %动臂大腔进行迭代滤波次数（求A1和A4点)
    %原生土 铁矿石  细沙
    SMOOTHFILTERINGTIME2=10;     %可调整 
    for j=1:1                   
        PressureCycleOriginValue{1}{j}=(data(:,1))';
        PressureCycleOriginValue{2}{j}=(data(:,2))';
        PressureCycleOriginValue{3}{j}=(data(:,3))';    
        PressureCycleOriginValue{4}{j}=(data(:,4))';         
    end
    %% ******************************************************************************************************************************************
    %将各作业循环段的采样频率由100Hz降到10Hz
    %% ******************************************************************************************************************************************
    for j=1:length(PressureCycleOriginValue{1})
        n=length(PressureCycleOriginValue{1}{j})/10; 
    for mi=1:n
        PressureCycle10HzValue{1}{j}(mi)=0.1+(mi-1)*0.1;         
    end
    PressureCycle10HzValue{2}{j}=medianmean(PressureCycleOriginValue{2}{j}, 10);    
    PressureCycle10HzValue{3}{j}=medianmean(PressureCycleOriginValue{3}{j}, 10);
    PressureCycle10HzValue{4}{j}=medianmean(PressureCycleOriginValue{4}{j}, 10);        
    end
    %% ******************************************************************************************************************************************
    %% 载荷谱作业循环段数据归一化处理
    %% ******************************************************************************************************************************************
    for j=1:length(PressureCycle10HzValue{1})
    % 归一化处理
     PressureCycleNormialValue{1}{j}=PressureCycle10HzValue{1}{j};
     PressureCycleNormialValue{2}{j}=mapminmax( PressureCycle10HzValue{2}{j},0,1);     
     PressureCycleNormialValue{3}{j}=mapminmax( PressureCycle10HzValue{3}{j},0,1);
     PressureCycleNormialValue{4}{j}=mapminmax( PressureCycle10HzValue{4}{j},0,1);
    end
    %% ******************************************************************************************************************************************
    %% 载荷谱作业循环段数据滤波处理
    %% ******************************************************************************************************************************************
    % 平滑滤波处理
    for j=1:length(PressureCycleNormialValue{1})
     PressureCycleFilteringValue{1}{j}=PressureCycleNormialValue{1}{j};
     PressureCycleFilteringValue{2}{j}=SmoothingFiltering(PressureCycleNormialValue{2}{j}, 7, 1, SMOOTHFILTERINGTIME);     
     PressureCycleFilteringValue{3}{j}=SmoothingFiltering(PressureCycleNormialValue{3}{j}, 7, 1, SMOOTHFILTERINGTIME);
     PressureCycleFilteringValue{4}{j}=SmoothingFiltering(PressureCycleNormialValue{4}{j}, 7, 1, SMOOTHFILTERINGTIME);
    end 
    %% ******************************************************************************************************************************************
    %% 载荷谱作业循环段中转斗压力的最大极大值点提取（值与坐标）
    %% ******************************************************************************************************************************************
    %寻找极大值点
    for j=1:length(PressureCycleFilteringValue{1})
     [multmaxY{j},multmaxXpoint{j}]=pickpeaks(PressureCycleFilteringValue{4}{j}');
    end   
    %寻找最大的极大值点
    for j=1:length(PressureCycleFilteringValue{1})
     onlyMAXY(j)=0;
     onlyMAXX(j)=0;
     for mi=1:length(multmaxY{j})
         if multmaxY{j}(mi)>onlyMAXY(j)
             onlyMAXY(j)=multmaxY{j}(mi);
             onlyMAXX(j)=PressureCycleFilteringValue{1}{j}(multmaxXpoint{j}(mi));
         end
     end
    end    
    %% ******************************************************************************************************************************************
    %% 载荷谱作业循环段中转斗压力的曲线变化率计算--归一化后的数据  求取有效作业段A2A3
    %% ******************************************************************************************************************************************
    %对归一化后数据计算变化率  
    n=length(PressureCycleNormialValue{4});  
    mj=1;
    for j=1:n
    for mi=1:(length(PressureCycleNormialValue{4}{j})-INTERVALPOINTS)
        %计算变化率
        DataChangeRateY{j}(mi)=((PressureCycleNormialValue{4}{j}(mi+INTERVALPOINTS)-PressureCycleNormialValue{4}{j}(mi))/0.1)/INTERVALPOINTS;
        DataChangeRateX{j}(mi)=PressureCycleNormialValue{1}{j}(mi);
        %提取变化率较大的值  EXTRACTCHANGERATE
        if  DataChangeRateY{j}(mi) > EXTRACTCHANGERATE
            DataBiggerChangeRateY{j}(mj) = DataChangeRateY{j}(mi);
            DataBiggerChangeRateX{j}(mj)=DataChangeRateX{j}(mi);
            mj=mj+1;
        elseif DataChangeRateY{j}(mi) < -EXTRACTCHANGERATE
            DataBiggerChangeRateY{j}(mj) = DataChangeRateY{j}(mi);
            DataBiggerChangeRateX{j}(mj)=DataChangeRateX{j}(mi);
            mj=mj+1;           
        end
    end
    end 
    %寻找转斗大腔压力最大的极大值点左边第一个变化率最大的极大值点，右边第一个变化率最小的极小值点
    for j=1:length(DataBiggerChangeRateX)
    %寻找搜索的起始点
    n=length(DataBiggerChangeRateX{j});
    for mi=1:n
       if DataBiggerChangeRateX{j}(mi) > onlyMAXX(j)
          DataChangeRateFindMiddleX(j)=mi;                    
          break;
       end   
    end
    %搜索左变化率最大的极大值点
    DataChangeRateLeftMaxY(j)=DataBiggerChangeRateY{j}(DataChangeRateFindMiddleX(j));
    n=DataChangeRateFindMiddleX(j);
    for mi=n:-1:1
        if DataBiggerChangeRateY{j}(mi) > 0
           if DataChangeRateLeftMaxY(j) <= DataBiggerChangeRateY{j}(mi)
              DataChangeRateLeftMaxY(j) = DataBiggerChangeRateY{j}(mi);
              DataChangeRateLeftMaxX(j) = DataBiggerChangeRateX{j}(mi);
           else
               break;
           end  
        end
    end
    %搜索右变化率最小的极小值点
    n=DataChangeRateFindMiddleX(j);
    m=length(DataBiggerChangeRateX{j});
    DataChangeRateRightMaxY(j)=DataBiggerChangeRateY{j}(DataChangeRateFindMiddleX(j));
    for mi=n:1:m
        if DataBiggerChangeRateY{j}(mi) < 0
           if DataChangeRateRightMaxY(j) >= DataBiggerChangeRateY{j}(mi)
              DataChangeRateRightMaxY(j) = DataBiggerChangeRateY{j}(mi);
              DataChangeRateRightMaxX(j) = DataBiggerChangeRateX{j}(mi);
           else
               break;
           end  
        end
    end       
    end

    for j=1:length(PressureCycleNormialValue{1})
        %有效作业段A2A3确定
        n=round(DataChangeRateLeftMaxX(j)/0.1)+INTERVALPOINTS;
        PressureCycleA2ValueX(j)=PressureCycleNormialValue{1}{j}(n);
        PressureCycleA2ValueY(j)=PressureCycleNormialValue{4}{j}(n);   
        n=round(DataChangeRateRightMaxX(j)/0.1);        
        PressureCycleA3ValueX(j)=PressureCycleNormialValue{1}{j}(n);
        PressureCycleA3ValueY(j)=PressureCycleNormialValue{4}{j}(n);        
    end
    %% ******************************************************************************************************************************************
    %% 载荷谱作业循环段中动臂大腔压力的归一化后数据确定 A1和A4点。
    %% ******************************************************************************************************************************************
    % end
    % 平滑滤波处理
    for j=1:length(PressureCycleNormialValue{1})
     BoomLargeChamberFilteringPressure{j}=SmoothingFiltering(PressureCycleNormialValue{3}{j}, 7, 1, SMOOTHFILTERINGTIME2);
    end 
    %寻找极小值点
    n=length(PressureCycleNormialValue{1});
    for j=1:n
    [multminY{j},multminXpoint{j}]=pickpeaks((-BoomLargeChamberFilteringPressure{j})');
    %寻找重载运输段A2A3中动臂大腔压力的最小极小值点
    Min_BoomLargeChamberFilteringPressure(j)=BoomLargeChamberFilteringPressure{j}(round(PressureCycleA2ValueX(j)*10));       %A2点动臂大腔值作为起始搜索点
    Min_BoomLargeChamberFilteringPressure_t(j)= PressureCycleNormialValue{1}{j}(round(PressureCycleA2ValueX(j)*10));
    for mi=1:(length(multminY{j}))
        %只寻找坐标在A2和A3的区间的值
       if (PressureCycleNormialValue{1}{j}(multminXpoint{j}(mi))>PressureCycleA2ValueX(j)) &&  ( PressureCycleNormialValue{1}{j}(multminXpoint{j}(mi)) < PressureCycleA3ValueX(j))
            if (-multminY{j}(mi))<Min_BoomLargeChamberFilteringPressure(j)
                Min_BoomLargeChamberFilteringPressure(j)=-multminY{j}(mi);
                Min_BoomLargeChamberFilteringPressure_t(j)= PressureCycleNormialValue{1}{j}(multminXpoint{j}(mi));
            end
       end
    end  

    end   

    %寻找 start - A2 和 end - A3 之间，比最小极小值点还小的所有极小值点
    n=length(PressureCycleFilteringValue{1});
    for j=1:n
     kki=1;
     kkj=1;
    for mi=1:(length(multminY{j}))       
       %左边值小于中间最小的极小值点的值 
       if PressureCycleNormialValue{1}{j}(multminXpoint{j}(mi))<=Min_BoomLargeChamberFilteringPressure_t(j)                                   
            if (-multminY{j}(mi))<Min_BoomLargeChamberFilteringPressure(j)
                MultMiniSA2_BoomLargeChamberFilteringPressure{j}(kki)=-multminY{j}(mi);
                MultMiniSA2_BoomLargeChamberFilteringPressure_t{j}(kki)=PressureCycleNormialValue{1}{j}(multminXpoint{j}(mi));
                kki=kki+1;
            end    
       end

       %右边值小于中间最小的极小值点的值
       if PressureCycleNormialValue{1}{j}(multminXpoint{j}(mi))>=Min_BoomLargeChamberFilteringPressure_t(j)                                 
            if (-multminY{j}(mi))<Min_BoomLargeChamberFilteringPressure(j)
                MultMiniA3E_BoomLargeChamberFilteringPressure{j}(kkj)=-multminY{j}(mi);
                MultMiniA3E_BoomLargeChamberFilteringPressure_t{j}(kkj)=PressureCycleNormialValue{1}{j}(multminXpoint{j}(mi));
                kkj=kkj+1;
            end    
       end       
    end
    %检测是否找到符合条件的极小值，如果没找到，直接以最后一个点或起始点作为极小值之一

    if kki==1
        MultMiniSA2_BoomLargeChamberFilteringPressure{j}(kki)=PressureCycleNormialValue{1}{j}(1);  
        MultMiniSA2_BoomLargeChamberFilteringPressure_t{j}(kki)=PressureCycleNormialValue{3}{j}(1);          
    end

    if kkj==1
        mm=length(PressureCycleNormialValue{1}{j});            
        MultMiniA3E_BoomLargeChamberFilteringPressure{j}(kkj)=PressureCycleNormialValue{3}{j}(mm);  
        MultMiniA3E_BoomLargeChamberFilteringPressure_t{j}(kkj)=PressureCycleNormialValue{1}{j}(mm);      
    end   


    %距离中间最小的极值点，左边最近点
    nn=length(MultMiniSA2_BoomLargeChamberFilteringPressure_t{j});
    PressureCycleA1ValueX(j)=MultMiniSA2_BoomLargeChamberFilteringPressure_t{j}(1);
    PressureCycleA1ValueY(j)=MultMiniSA2_BoomLargeChamberFilteringPressure{j}(1);
    for mi=2:nn                                                 
        if MultMiniSA2_BoomLargeChamberFilteringPressure_t{j}(mi) > PressureCycleA1ValueX(j)
            PressureCycleA1ValueX(j)=MultMiniSA2_BoomLargeChamberFilteringPressure_t{j}(mi);
            PressureCycleA1ValueY(j)=MultMiniSA2_BoomLargeChamberFilteringPressure{j}(mi);
        end
    end

    %距离中间最小的极值点，右边最近点
    nn=length(MultMiniA3E_BoomLargeChamberFilteringPressure_t{j});
    PressureCycleA4ValueX(j)=MultMiniA3E_BoomLargeChamberFilteringPressure_t{j}(1);
    PressureCycleA4ValueY(j)=MultMiniA3E_BoomLargeChamberFilteringPressure{j}(1);
    for mi=2:nn                                                 
        if MultMiniA3E_BoomLargeChamberFilteringPressure_t{j}(mi) < PressureCycleA4ValueX(j)
            PressureCycleA4ValueX(j)=MultMiniA3E_BoomLargeChamberFilteringPressure_t{j}(mi);
            PressureCycleA4ValueY(j)=MultMiniA3E_BoomLargeChamberFilteringPressure{j}(mi);
        end
    end
    end
    %% ******************************************************************************************************************************************
    %% 载荷谱作业循环段中 A1A2 A2A3 A3A4 各段数据输出
    %% ******************************************************************************************************************************************
    % A1A2 A2A3 A3A4 各段数据提取   
    Tstart=1;
    Tend=round(PressureCycleA1ValueX(j)*100);
    for mi=(Tstart):(Tend)
        data_a1(mi-Tstart+1,:)=data(mi,:);
    end

    Tstart=round(PressureCycleA1ValueX(j)*100);
    Tend=round(PressureCycleA2ValueX(j)*100);
    for mi=(Tstart):(Tend)
        data_a2(mi-Tstart+1,:)=data(mi,:);
    end

    Tstart=round(PressureCycleA2ValueX(j)*100);
    Tend=round(PressureCycleA3ValueX(j)*100);
    for mi=(Tstart):(Tend)
        data_a3(mi-Tstart+1,:)=data(mi,:);
    end

    Tstart=round(PressureCycleA3ValueX(j)*100);
    Tend=round(PressureCycleA4ValueX(j)*100);
    for mi=(Tstart):(Tend)
        data_a4(mi-Tstart+1,:)=data(mi,:);
    end

     Tstart=round(PressureCycleA4ValueX(j)*100);
     Tend=length(PressureCycleOriginValue{1}{j});
     for mi=(Tstart):(Tend)
        data_a5(mi-Tstart+1,:)=data(mi,:);
     end
     
    FileTextName = strcat(outputfile,'\',Object, '-', Power, '-', Driver);
    mkdir(FileTextName);
    
    csvwrite([strcat(FileTextName,'\',num2str(number)) '-a1.csv'],data_a1);
    clear data_a1
    csvwrite([strcat(FileTextName,'\',num2str(number)) '-a2.csv'],data_a2);
    clear data_a1
    csvwrite([strcat(FileTextName,'\',num2str(number)) '-a3.csv'],data_a3);
    clear data_a1
    csvwrite([strcat(FileTextName,'\',num2str(number)) '-a4.csv'],data_a4);
    clear data_a1
    csvwrite([strcat(FileTextName,'\',num2str(number)) '-a5.csv'],data_a5);
    clear data_a1
end

