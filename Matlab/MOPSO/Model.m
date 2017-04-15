function z=Model(x)
n_n=[0.92 0.92 0.92 0.92]; %����Ч��
n_d=0.95; %��������Ч��
n_w=0.9; %�ֱ߼�����Ч��
r=0.753; %���ֹ����뾶
w1=0.438; %1��λ������
w2=0.218; %2��λ������
w3=0.344; %3��������
w4=0;

m = 22300;     % ����������kg��
g = 9.8;      % �������ٶȣ�g*m/s^2�� 
G = m*g;      % ��������G=mg��(N)
f_gundong = 0.02;    % �����Ĺ�������ϵ��
Cd = 2;           % ��������ϵ��
A = 10.457;             % ӭ���������������ʻ�����ͶӰ���(m^2)

K = 1.05;            % ������������,��Ȩϵ����
du=0.05;%����
rou = 7.0;           % ȼ���ضȣ�N/L��
Ttq_max = 922;       % �����������ת��(N.m)��
v0=Ttq_max*r*0.377/x(5)/x(1);%���ת�ص��Ӧ���ٶ�[һ��]
P_power1=0; % ���빦�������ܹ��� 
P_Ft1=0; %�������������ܹ���
P_power2=0; % ���빦�������ܹ��� 
P_Ft2=0; %�������������ܹ���
P_power3=0; % ���빦�������ܹ��� 
P_Ft3=0; %�������������ܹ���
P_power4=0; % ���빦�������ܹ��� 
P_Ft4=0; %�������������ܹ���
abE=0;%Ч��
abQ = 0; % ������
n=0:10:2400;
p=Turbine(x(6));
for i=1:4
    T{i}=Curve_engineout(n,p{i});
    Fd{i}=T{i}.*x(4)*x(i)*n_n(i)*n_d*n_w/r;%��i����������
    vx{i}=0.377*r*n./x(5)/x(i);
end
vv=0:0.1:vx{4}(length(vx{4}));%���������ٶ�
F_resistance=G*f_gundong+Cd*A*vv.^2/21.15;%������������
aax{4}=intp(vx{4},Fd{4},vv,F_resistance/100);
for i=1:3
    aax{i}=intp(vx{i},Fd{i},vx{i+1},Fd{i+1});
end
for v = 0.05:du:aax{4}(1)
    if v<=aax{1}(1)
        delta = 1.06+0.04*x(1).^2;  % ������ת��������ϵ��
        ne = v*x(5)*x(1)/0.377/r;  % ת�٣�r/min��
        Pe = ( G*f_gundong*v/3600 + Cd*A*v.^3/76140 + delta*m*v*du/3600)/n_n(1)*n_d*n_w;
        Me=Curve_engineout(ne,p{i}); % ������ת��(N.m)
        Ft = Me*x(1)*x(5)*n_n(1)*n_d*n_w/r;  % ������������
        Ff = G*f_gundong;        % �����Ĺ�������
        if v<=v0
             P_power1=P_power1+0.377*2240*716*n_n(1)*n_d*n_w/v0*du;
             P_Ft1=P_Ft1+Ft*du;
        else
             P_power1=P_power1+0.377*2240*716*n_n(1)*n_d*n_w/v*du;
             P_Ft1=P_Ft1+Ft*du;
       end
    elseif v>aax{1}(1) && v<=aax{2}(1)
        delta = 1.06+0.04*x(2).^2;  % ������ת��������ϵ��
        ne = v*x(5)*x(2)/0.377/r;  % ת�٣�r/min��
        Pe = ( G*f_gundong*v/3600 + Cd*A*v.^3/76140 + delta*m*v*du/3600)/n_n(2)*n_d*n_w;
        Me=Curve_engineout(ne,p{i}); % ������ת��(N.m)
        Ft = Me*x(2)*x(5)*n_n(2)*n_d*n_w/r;  % ������������
        Ff = G*f_gundong;        % �����Ĺ�������
        P_power2=P_power2+0.377*2240*716*n_n(2)*n_d*n_w/v*du;
        P_Ft2=P_Ft2+Ft*du;
     elseif v>aax{2}(1) && v<=aax{3}(1)
        delta = 1.06+0.04*x(3).^2;  % ������ת��������ϵ��
        ne = v*x(5)*x(3)/0.377/r;  % ת�٣�r/min��
        Pe = ( G*f_gundong*v/3600 + Cd*A*v.^3/76140 + delta*m*v*du/3600)/n_n(3)*n_d*n_w;
        Me=Curve_engineout(ne,p{i}); % ������ת��(N.m)
        Ft = Me*x(3)*x(5)*n_n(3)*n_d*n_w/r;  % ������������
        Ff = G*f_gundong;        % �����Ĺ�������
        P_power3=P_power3+0.377*2240*716*n_n(3)*n_d*n_w/v*du;
        P_Ft3=P_Ft3+Ft*du;
     elseif v>aax{3}(1) && v<=aax{4}(1)
        delta = 1.06+0.04*x(4).^2;  % ������ת��������ϵ�� 
        ne = v*x(5)*x(4)/0.377/r;  % ת�٣�r/min��
        Pe = ( G*f_gundong*v/3600 + Cd*A*v.^3/76140 + delta*m*v*du/3600)/n_n(4)*n_d*n_w;
        Me=Curve_engineout(ne,p{i}); % ������ת��(N.m)
        Ft = Me*x(4)*x(5)*n_n(4)*n_d*n_w/r;  % ������������
        Ff = G*f_gundong;        % �����Ĺ�������
        P_power4=P_power4+0.377*2240*716*n_n(4)*n_d*n_w/v*du;
        P_Ft4=P_Ft4+Ft*du;
    end
    ge_ne_pe=Curve_fuelcode(ne,Me);
    % f1(x)�����Է�Ŀ�꺯��������������ʧ�ʣ�
    abE=w1*(P_power1-P_Ft1)/P_power1+w2*(P_power2-P_Ft2)/P_power2+w3*(P_power3-P_Ft3)/P_power3+w4*(P_power4-P_Ft4)/P_power4;   
    % f23(x)�����Է�Ŀ�꺯��  
    delta_S = (v + v+du)/2;  % ��λ����
    abQ = abQ + K*Pe*ge_ne_pe*delta_S./102./v./rou; % ������    
end
zz=getconstraints(@constraint,x); % ������Լ��
z = [abE+zz abQ+zz];