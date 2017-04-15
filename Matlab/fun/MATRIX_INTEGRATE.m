function [MAX_MEAN,MAX_AMPL,x,ENDMEAN,ENDAMPL]=MATRIX_INTEGRATE(matrix1,matrix2,u,sgm,xz,cd,yz)
    sumx(1)=sum(sum(matrix1));
    sumx(2)=sum(sum(matrix2));
    %外推系数
    N=1000000/sum(sumx);
    %外推频次
    sumx=sumx*N;
    for i=1:2
        %均值最大值
        Max_mean(i)=abs(u(i)+sgm(i)*(3));
        %幅值最大值
        Max_ampl(i)=abs(yz(i)+cd(i)*(-log(1/sumx(i)))^(1/xz(i)));
        %积分值
        MAX_MEAN{i}=[Max_mean(i),0.95*Max_mean(i),0.85*Max_mean(i),0.725*Max_mean(i),0.575*Max_mean(i),0.425*Max_mean(i),0.275*Max_mean(i),0.125*Max_mean(i),0];
        MAX_AMPL{i}=[Max_ampl(i),0.95*Max_ampl(i),0.85*Max_ampl(i),0.725*Max_ampl(i),0.575*Max_ampl(i),0.425*Max_ampl(i),0.275*Max_ampl(i),0.125*Max_ampl(i),0];

        for j=1:8
            MEAN_UP=MAX_MEAN{i}(j);
            MEAN_DOWN=MAX_MEAN{i}(j+1);
                for k=1:8

                    AMPL_UP=MAX_AMPL{i}(k);
                    AMPL_DOWN=MAX_AMPL{i}(k+1);
                    syms xx
                    syms yy
                    a{i}(j,k)=double(int(funmean(u(i),sgm(i),xx),MEAN_DOWN,MEAN_UP));
                    b{i}(j,k)=real(double(int(funampl(xz(i),cd(i),yz(i),yy),AMPL_DOWN,AMPL_UP)));

                    xxx{i}(j,k)=sumx(i)*a{i}(j,k)*b{i}(j,k);
                    x{i}(j,k)=round(xxx{i}(j,k));
                
                end
        end
    end

    for i=1:2
        ENDSUM{i}=0;
        for j=1:8
            TOTALSUM{i}=sum(sum(x{i}(:,:)));
            ENDSUM{i}=ENDSUM{i}+MAX_MEAN{i}(j)*sum(x{i}(j,:));    
            ENDAMPL{i}{j}=sum(x{i}(:,j));
        end
        ENDMEAN{i}=ENDSUM{i}/TOTALSUM{i};
    end    
end