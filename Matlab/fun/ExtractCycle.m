function y=ExtractCycle(data,Driver,Object,Power,number,outputfile)
    %% ******************************************************************************************************************************************
    %% �ɵ��ڲ���
    %% ******************************************************************************************************************************************
    %�غ��׼�Ȩ�ں�ǰƽ���˲���������
    SMOOTHFILTERINGTIME=100;     %�ɵ��� 
    % �غ�����ҵѭ������ת��ѹ�������߱仯�ʼ���--������ ��������һ�α仯��
    INTERVALPOINTS=5;
    %ת����ǻѹ���仯�ʵ���ȡֵ
    EXTRACTCHANGERATE=0.5;
    %���۴�ǻ���е����˲���������A1��A4��)
    %ԭ���� ����ʯ  ϸɳ
    SMOOTHFILTERINGTIME2=10;     %�ɵ��� 
    for j=1:1                   
        PressureCycleOriginValue{1}{j}=(data(:,1))';
        PressureCycleOriginValue{2}{j}=(data(:,2))';
        PressureCycleOriginValue{3}{j}=(data(:,3))';    
        PressureCycleOriginValue{4}{j}=(data(:,4))';         
    end
    %% ******************************************************************************************************************************************
    %������ҵѭ���εĲ���Ƶ����100Hz����10Hz
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
    %% �غ�����ҵѭ�������ݹ�һ������
    %% ******************************************************************************************************************************************
    for j=1:length(PressureCycle10HzValue{1})
    % ��һ������
     PressureCycleNormialValue{1}{j}=PressureCycle10HzValue{1}{j};
     PressureCycleNormialValue{2}{j}=mapminmax( PressureCycle10HzValue{2}{j},0,1);     
     PressureCycleNormialValue{3}{j}=mapminmax( PressureCycle10HzValue{3}{j},0,1);
     PressureCycleNormialValue{4}{j}=mapminmax( PressureCycle10HzValue{4}{j},0,1);
    end
    %% ******************************************************************************************************************************************
    %% �غ�����ҵѭ���������˲�����
    %% ******************************************************************************************************************************************
    % ƽ���˲�����
    for j=1:length(PressureCycleNormialValue{1})
     PressureCycleFilteringValue{1}{j}=PressureCycleNormialValue{1}{j};
     PressureCycleFilteringValue{2}{j}=SmoothingFiltering(PressureCycleNormialValue{2}{j}, 7, 1, SMOOTHFILTERINGTIME);     
     PressureCycleFilteringValue{3}{j}=SmoothingFiltering(PressureCycleNormialValue{3}{j}, 7, 1, SMOOTHFILTERINGTIME);
     PressureCycleFilteringValue{4}{j}=SmoothingFiltering(PressureCycleNormialValue{4}{j}, 7, 1, SMOOTHFILTERINGTIME);
    end 
    %% ******************************************************************************************************************************************
    %% �غ�����ҵѭ������ת��ѹ������󼫴�ֵ����ȡ��ֵ�����꣩
    %% ******************************************************************************************************************************************
    %Ѱ�Ҽ���ֵ��
    for j=1:length(PressureCycleFilteringValue{1})
     [multmaxY{j},multmaxXpoint{j}]=pickpeaks(PressureCycleFilteringValue{4}{j}');
    end   
    %Ѱ�����ļ���ֵ��
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
    %% �غ�����ҵѭ������ת��ѹ�������߱仯�ʼ���--��һ���������  ��ȡ��Ч��ҵ��A2A3
    %% ******************************************************************************************************************************************
    %�Թ�һ�������ݼ���仯��  
    n=length(PressureCycleNormialValue{4});  
    mj=1;
    for j=1:n
    for mi=1:(length(PressureCycleNormialValue{4}{j})-INTERVALPOINTS)
        %����仯��
        DataChangeRateY{j}(mi)=((PressureCycleNormialValue{4}{j}(mi+INTERVALPOINTS)-PressureCycleNormialValue{4}{j}(mi))/0.1)/INTERVALPOINTS;
        DataChangeRateX{j}(mi)=PressureCycleNormialValue{1}{j}(mi);
        %��ȡ�仯�ʽϴ��ֵ  EXTRACTCHANGERATE
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
    %Ѱ��ת����ǻѹ�����ļ���ֵ����ߵ�һ���仯�����ļ���ֵ�㣬�ұߵ�һ���仯����С�ļ�Сֵ��
    for j=1:length(DataBiggerChangeRateX)
    %Ѱ����������ʼ��
    n=length(DataBiggerChangeRateX{j});
    for mi=1:n
       if DataBiggerChangeRateX{j}(mi) > onlyMAXX(j)
          DataChangeRateFindMiddleX(j)=mi;                    
          break;
       end   
    end
    %������仯�����ļ���ֵ��
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
    %�����ұ仯����С�ļ�Сֵ��
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
        %��Ч��ҵ��A2A3ȷ��
        n=round(DataChangeRateLeftMaxX(j)/0.1)+INTERVALPOINTS;
        PressureCycleA2ValueX(j)=PressureCycleNormialValue{1}{j}(n);
        PressureCycleA2ValueY(j)=PressureCycleNormialValue{4}{j}(n);   
        n=round(DataChangeRateRightMaxX(j)/0.1);        
        PressureCycleA3ValueX(j)=PressureCycleNormialValue{1}{j}(n);
        PressureCycleA3ValueY(j)=PressureCycleNormialValue{4}{j}(n);        
    end
    %% ******************************************************************************************************************************************
    %% �غ�����ҵѭ�����ж��۴�ǻѹ���Ĺ�һ��������ȷ�� A1��A4�㡣
    %% ******************************************************************************************************************************************
    % end
    % ƽ���˲�����
    for j=1:length(PressureCycleNormialValue{1})
     BoomLargeChamberFilteringPressure{j}=SmoothingFiltering(PressureCycleNormialValue{3}{j}, 7, 1, SMOOTHFILTERINGTIME2);
    end 
    %Ѱ�Ҽ�Сֵ��
    n=length(PressureCycleNormialValue{1});
    for j=1:n
    [multminY{j},multminXpoint{j}]=pickpeaks((-BoomLargeChamberFilteringPressure{j})');
    %Ѱ�����������A2A3�ж��۴�ǻѹ������С��Сֵ��
    Min_BoomLargeChamberFilteringPressure(j)=BoomLargeChamberFilteringPressure{j}(round(PressureCycleA2ValueX(j)*10));       %A2�㶯�۴�ǻֵ��Ϊ��ʼ������
    Min_BoomLargeChamberFilteringPressure_t(j)= PressureCycleNormialValue{1}{j}(round(PressureCycleA2ValueX(j)*10));
    for mi=1:(length(multminY{j}))
        %ֻѰ��������A2��A3�������ֵ
       if (PressureCycleNormialValue{1}{j}(multminXpoint{j}(mi))>PressureCycleA2ValueX(j)) &&  ( PressureCycleNormialValue{1}{j}(multminXpoint{j}(mi)) < PressureCycleA3ValueX(j))
            if (-multminY{j}(mi))<Min_BoomLargeChamberFilteringPressure(j)
                Min_BoomLargeChamberFilteringPressure(j)=-multminY{j}(mi);
                Min_BoomLargeChamberFilteringPressure_t(j)= PressureCycleNormialValue{1}{j}(multminXpoint{j}(mi));
            end
       end
    end  

    end   

    %Ѱ�� start - A2 �� end - A3 ֮�䣬����С��Сֵ�㻹С�����м�Сֵ��
    n=length(PressureCycleFilteringValue{1});
    for j=1:n
     kki=1;
     kkj=1;
    for mi=1:(length(multminY{j}))       
       %���ֵС���м���С�ļ�Сֵ���ֵ 
       if PressureCycleNormialValue{1}{j}(multminXpoint{j}(mi))<=Min_BoomLargeChamberFilteringPressure_t(j)                                   
            if (-multminY{j}(mi))<Min_BoomLargeChamberFilteringPressure(j)
                MultMiniSA2_BoomLargeChamberFilteringPressure{j}(kki)=-multminY{j}(mi);
                MultMiniSA2_BoomLargeChamberFilteringPressure_t{j}(kki)=PressureCycleNormialValue{1}{j}(multminXpoint{j}(mi));
                kki=kki+1;
            end    
       end

       %�ұ�ֵС���м���С�ļ�Сֵ���ֵ
       if PressureCycleNormialValue{1}{j}(multminXpoint{j}(mi))>=Min_BoomLargeChamberFilteringPressure_t(j)                                 
            if (-multminY{j}(mi))<Min_BoomLargeChamberFilteringPressure(j)
                MultMiniA3E_BoomLargeChamberFilteringPressure{j}(kkj)=-multminY{j}(mi);
                MultMiniA3E_BoomLargeChamberFilteringPressure_t{j}(kkj)=PressureCycleNormialValue{1}{j}(multminXpoint{j}(mi));
                kkj=kkj+1;
            end    
       end       
    end
    %����Ƿ��ҵ����������ļ�Сֵ�����û�ҵ���ֱ�������һ�������ʼ����Ϊ��Сֵ֮һ

    if kki==1
        MultMiniSA2_BoomLargeChamberFilteringPressure{j}(kki)=PressureCycleNormialValue{1}{j}(1);  
        MultMiniSA2_BoomLargeChamberFilteringPressure_t{j}(kki)=PressureCycleNormialValue{3}{j}(1);          
    end

    if kkj==1
        mm=length(PressureCycleNormialValue{1}{j});            
        MultMiniA3E_BoomLargeChamberFilteringPressure{j}(kkj)=PressureCycleNormialValue{3}{j}(mm);  
        MultMiniA3E_BoomLargeChamberFilteringPressure_t{j}(kkj)=PressureCycleNormialValue{1}{j}(mm);      
    end   


    %�����м���С�ļ�ֵ�㣬��������
    nn=length(MultMiniSA2_BoomLargeChamberFilteringPressure_t{j});
    PressureCycleA1ValueX(j)=MultMiniSA2_BoomLargeChamberFilteringPressure_t{j}(1);
    PressureCycleA1ValueY(j)=MultMiniSA2_BoomLargeChamberFilteringPressure{j}(1);
    for mi=2:nn                                                 
        if MultMiniSA2_BoomLargeChamberFilteringPressure_t{j}(mi) > PressureCycleA1ValueX(j)
            PressureCycleA1ValueX(j)=MultMiniSA2_BoomLargeChamberFilteringPressure_t{j}(mi);
            PressureCycleA1ValueY(j)=MultMiniSA2_BoomLargeChamberFilteringPressure{j}(mi);
        end
    end

    %�����м���С�ļ�ֵ�㣬�ұ������
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
    %% �غ�����ҵѭ������ A1A2 A2A3 A3A4 �����������
    %% ******************************************************************************************************************************************
    % A1A2 A2A3 A3A4 ����������ȡ   
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

