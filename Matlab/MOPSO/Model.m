function z=Model(x)
n_n=[0.92 0.92 0.92 0.92]; %各档效率
n_d=0.95; %主减速器效率
n_w=0.9; %轮边减速器效率
r=0.753; %车轮滚动半径
w1=0.438; %1档位利用率
w2=0.218; %2档位利用率
w3=0.344; %3档利用率
w4=0;

m = 22300;     % 整车质量（kg）
g = 9.8;      % 重力加速度（g*m/s^2） 
G = m*g;      % 汽车重力G=mg，(N)
f_gundong = 0.02;    % 汽车的滚动阻力系数
Cd = 2;           % 空气阻力系数
A = 10.457;             % 迎风面积，即汽车行驶方向的投影面积(m^2)

K = 1.05;            % 考虑连续加速,加权系数；
du=0.05;%步长
rou = 7.0;           % 燃油重度，N/L；
Ttq_max = 922;       % 发动机的最大转矩(N.m)；
v0=Ttq_max*r*0.377/x(5)/x(1);%最大转矩点对应的速度[一档]
P_power1=0; % 理想功率曲线总功率 
P_Ft1=0; %驱动特性曲线总功率
P_power2=0; % 理想功率曲线总功率 
P_Ft2=0; %驱动特性曲线总功率
P_power3=0; % 理想功率曲线总功率 
P_Ft3=0; %驱动特性曲线总功率
P_power4=0; % 理想功率曲线总功率 
P_Ft4=0; %驱动特性曲线总功率
abE=0;%效率
abQ = 0; % 耗油量
n=0:10:2400;
p=Turbine(x(6));
for i=1:4
    T{i}=Curve_engineout(n,p{i});
    Fd{i}=T{i}.*x(4)*x(i)*n_n(i)*n_d*n_w/r;%第i档的驱动力
    vx{i}=0.377*r*n./x(5)/x(i);
end
vv=0:0.1:vx{4}(length(vx{4}));%整个过程速度
F_resistance=G*f_gundong+Cd*A*vv.^2/21.15;%工作阻力曲线
aax{4}=intp(vx{4},Fd{4},vv,F_resistance/100);
for i=1:3
    aax{i}=intp(vx{i},Fd{i},vx{i+1},Fd{i+1});
end
for v = 0.05:du:aax{4}(1)
    if v<=aax{1}(1)
        delta = 1.06+0.04*x(1).^2;  % 汽车旋转质量换算系数
        ne = v*x(5)*x(1)/0.377/r;  % 转速（r/min）
        Pe = ( G*f_gundong*v/3600 + Cd*A*v.^3/76140 + delta*m*v*du/3600)/n_n(1)*n_d*n_w;
        Me=Curve_engineout(ne,p{i}); % 发动机转矩(N.m)
        Ft = Me*x(1)*x(5)*n_n(1)*n_d*n_w/r;  % 汽车的驱动力
        Ff = G*f_gundong;        % 汽车的滚动阻力
        if v<=v0
             P_power1=P_power1+0.377*2240*716*n_n(1)*n_d*n_w/v0*du;
             P_Ft1=P_Ft1+Ft*du;
        else
             P_power1=P_power1+0.377*2240*716*n_n(1)*n_d*n_w/v*du;
             P_Ft1=P_Ft1+Ft*du;
       end
    elseif v>aax{1}(1) && v<=aax{2}(1)
        delta = 1.06+0.04*x(2).^2;  % 汽车旋转质量换算系数
        ne = v*x(5)*x(2)/0.377/r;  % 转速（r/min）
        Pe = ( G*f_gundong*v/3600 + Cd*A*v.^3/76140 + delta*m*v*du/3600)/n_n(2)*n_d*n_w;
        Me=Curve_engineout(ne,p{i}); % 发动机转矩(N.m)
        Ft = Me*x(2)*x(5)*n_n(2)*n_d*n_w/r;  % 汽车的驱动力
        Ff = G*f_gundong;        % 汽车的滚动阻力
        P_power2=P_power2+0.377*2240*716*n_n(2)*n_d*n_w/v*du;
        P_Ft2=P_Ft2+Ft*du;
     elseif v>aax{2}(1) && v<=aax{3}(1)
        delta = 1.06+0.04*x(3).^2;  % 汽车旋转质量换算系数
        ne = v*x(5)*x(3)/0.377/r;  % 转速（r/min）
        Pe = ( G*f_gundong*v/3600 + Cd*A*v.^3/76140 + delta*m*v*du/3600)/n_n(3)*n_d*n_w;
        Me=Curve_engineout(ne,p{i}); % 发动机转矩(N.m)
        Ft = Me*x(3)*x(5)*n_n(3)*n_d*n_w/r;  % 汽车的驱动力
        Ff = G*f_gundong;        % 汽车的滚动阻力
        P_power3=P_power3+0.377*2240*716*n_n(3)*n_d*n_w/v*du;
        P_Ft3=P_Ft3+Ft*du;
     elseif v>aax{3}(1) && v<=aax{4}(1)
        delta = 1.06+0.04*x(4).^2;  % 汽车旋转质量换算系数 
        ne = v*x(5)*x(4)/0.377/r;  % 转速（r/min）
        Pe = ( G*f_gundong*v/3600 + Cd*A*v.^3/76140 + delta*m*v*du/3600)/n_n(4)*n_d*n_w;
        Me=Curve_engineout(ne,p{i}); % 发动机转矩(N.m)
        Ft = Me*x(4)*x(5)*n_n(4)*n_d*n_w/r;  % 汽车的驱动力
        Ff = G*f_gundong;        % 汽车的滚动阻力
        P_power4=P_power4+0.377*2240*716*n_n(4)*n_d*n_w/v*du;
        P_Ft4=P_Ft4+Ft*du;
    end
    ge_ne_pe=Curve_fuelcode(ne,Me);
    % f1(x)动力性分目标函数（驱动功率损失率）
    abE=w1*(P_power1-P_Ft1)/P_power1+w2*(P_power2-P_Ft2)/P_power2+w3*(P_power3-P_Ft3)/P_power3+w4*(P_power4-P_Ft4)/P_power4;   
    % f23(x)经济性分目标函数  
    delta_S = (v + v+du)/2;  % 单位距离
    abQ = abQ + K*Pe*ge_ne_pe*delta_S./102./v./rou; % 耗油量    
end
zz=getconstraints(@constraint,x); % 非线性约束
z = [abE+zz abQ+zz];