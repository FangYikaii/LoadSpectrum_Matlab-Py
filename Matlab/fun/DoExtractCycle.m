function DoExtractCycle(imputfile,outputfile,driver,power,object)
    Driver_Group = {'ljk' 'wjs' 'jgh'};
    Object_Group = {'cinder','soil','sand','iron'};
    Power_Group =  {'slight' 'middle' 'heavy'};
    for i=driver:driver
        for j=object:object
            for k=power:power
                Driver = Driver_Group{i};
                Power = Power_Group{k};
                Object= Object_Group{j};
                FileName1 = imputfile;        
                FileName2 = strcat(Object,'-',Power,'-',Driver);
                FileName = strcat(FileName1,'\',FileName2);
                original = pwd;
                cd(FileName);
                DataMessage = dir(fullfile('*.csv'));
                for n=1:length(DataMessage)
                    data{n} = csvread([num2str(n) '.csv']);
                end
                cd(original);
                for n=1:length(DataMessage)
                    ExtractCycle(data{n},Driver,Object,Power,n,outputfile);
                end

                clear data
            end
        end
    end
end
