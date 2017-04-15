function DoCycle(imputfile,outputfile,driver,power,object)
    Driver_Group = {'ljk' 'wjs' 'jgh'};
    Object_Group = {'cinder','soil','sand','iron'};
    Power_Group =  {'slight' 'middle' 'heavy'};
    for i=driver:driver
        for j=object:object
            for k=power:power
                Driver = Driver_Group{i};
                Power = Power_Group{k};
                Object= Object_Group{j};
                File = strcat(Object,'-',Power,'-',Driver,'.xlsx');
                File = strcat(imputfile,'\',File);
                data = xlsread(File);
                FindCycle(data,Driver,Object,Power,outputfile);
                clear data
            end
        end
    end
end