function fy=fun(x)
% 目标函数，就是帖子里说的f(x1,x2,...,xn)，这是根据您的实际情况需要修改的。
global par_lamda1 par_lamda2 par_lamda3;
global par_wig1 par_wig2 par_wig3 par_wig4;
global fun_fuel;
global fun_turbine;
global par_turbineD par_carM par_loadM par_A par_fair par_froll par_r par_nengine par_nio par_nig; 
global par_fai par_pmaxP par_pmaxN par_pmaxT par_tmaxN par_tmaxP par_tmaxT par_Iw par_If par_rou;
global par_ig1 par_ig2 par_ig3 par_ig4 par_io;

n_n=par_nig; %各档效率
n_d=par_nio; %主减速器效率
n_w=par_nengine; %
r=par_r; %车轮滚动半径
Iw=par_Iw;%车轮转动惯量
If=par_If;%涡轮转动惯量

w1=par_wig1;
w2=par_wig2;
w3=par_wig3;
w4=par_wig4;

m =par_carM+par_loadM;     % 整车质量（kg）
g = 9.8;      % 重力加速度（g*m/s^2） 
G = m*g;      % 汽车重力G=mg，(N)
f_gundong = par_froll;    % 汽车的滚动阻力系数
Cd = par_fair;           % 空气阻力系数
A = par_A;             % 迎风面积，即汽车行驶方向的投影面积(m^2)

K = 1.05;            % 考虑连续加速,加权系数；
du=0.1;%步长
rou = par_rou;           % 燃油重度，N/L；

n_ttt0=par_tmaxN;%最大转矩点对应转速
io=par_io;%主减速比
ig=[par_ig1 par_ig2 par_ig3 par_ig4];%变速比
v0=n_ttt0*r*0.377/io/ig(1);%最大转矩点对应的速度[一档]

P_power1=0; % 理想功率曲线总功率 
P_Ft1=0; %驱动特性曲线总功率

P_power2=0; % 理想功率曲线总功率 
P_Ft2=0; %驱动特性曲线总功率

P_power3=0; % 理想功率曲线总功率 
P_Ft3=0; %驱动特性曲线总功率

P_power4=0; % 理想功率曲线总功率 
P_Ft4=0; %驱动特性曲线总功率

abE=0;%效率
abTT = 0; % 时间
abQ = 0; % 耗油量

a=[par_ig1 par_ig2 par_ig3 par_ig4 par_io];%变速比
a(2)=x(1);
a(3)=x(2);
n=0:10:2400;
T=fun_turbine(1)*n+fun_turbine(2);
for i=1:4
    Fd{i}=T.*a(5)*a(i)*n_n*n_d*n_w/r;%第i档的驱动力
    vx{i}=0.377*r*n./a(5)/a(i);
end
vv=0:0.1:vx{4}(length(vx{4}));%整个过程速度
F_resistance=G*f_gundong+Cd*A*vv.^2/21.15;%工作阻力曲线
aax{4}=intp(vx{4},Fd{4},vv,F_resistance);
for i=1:3
    aax{i}=intp(vx{i},Fd{i},vx{i+1},Fd{i+1});
end
for v = 0.05:0.05:aax{4}(1)
    if v<=aax{1}(1)
        delta = 1.06+0.04*x(1).^2;  % 汽车旋转质量换算系数
        ne = v*a(5)*a(1)/0.377/r;  % 转速（r/min）
        Pe = ( G*f_gundong*v/3600 + Cd*A*v.^3/76140 + delta*m*v*du/3600)/n_n*n_d*n_w;
        sgm=1+Iw/(m*r^2)+If*a(5)^2*a(1)^2*n_n*n_d*n_w/(m*r^2);
        Me=fun_turbine(1)*ne+fun_turbine(2); % 发动机转矩(N.m)
        Ft = Me*a(1)*a(5)*n_n*n_d*n_w/r;  % 汽车的驱动力
        Ff = G*f_gundong;        % 汽车的滚动阻力
        if v<=v0
            P_power1=P_power1+0.377*par_pmaxT*par_pmaxN*n_n*n_d*n_w/v0*du;
            P_Ft1=P_Ft1+Ft*du;
        else
            P_power1=P_power1+0.377*par_pmaxT*par_pmaxN*n_n*n_d*n_w/v*du;
            P_Ft1=P_Ft1+Ft*du;
        end
    elseif v>aax{1}(1) && v<=aax{2}(1)
        delta = 1.06+0.04*a(2).^2;  % 汽车旋转质量换算系数
        ne = v*a(5)*a(2)/0.377/r;  % 转速（r/min）
        Pe = ( G*f_gundong*v/3600 + Cd*A*v.^3/76140 + delta*m*v*du/3600)/n_n*n_d*n_w;
        sgm=1+Iw/(m*r^2)+If*a(5)^2*a(2)^2*n_n*n_d*n_w/(m*r^2);
        Me=fun_turbine(1)*ne+fun_turbine(2); % 发动机转矩(N.m)
        Ft = Me*a(2)*a(5)*n_n*n_d*n_w/r;  % 汽车的驱动力
        Ff = G*f_gundong;        % 汽车的滚动阻力
        P_power2=P_power2+0.377*2240*716*n_n*n_d*n_w/v*du;
        P_Ft2=P_Ft2+Ft*du;
     elseif v>aax{2}(1) && v<=aax{3}(1)
        delta = 1.06+0.04*a(3).^2;  % 汽车旋转质量换算系数
        ne = v*a(5)*a(3)/0.377/r;  % 转速（r/min）
        Pe = ( G*f_gundong*v/3600 + Cd*A*v.^3/76140 + delta*m*v*du/3600)/n_n*n_d*n_w;
        sgm=1+Iw/(m*r^2)+If*a(5)^2*a(3)^2*n_n*n_d*n_w/(m*r^2);
        Me=fun_turbine(1)*ne+fun_turbine(2); % 发动机转矩(N.m)
        Ft = Me*a(3)*a(5)*n_n*n_d*n_w/r;  % 汽车的驱动力
        Ff = G*f_gundong;        % 汽车的滚动阻力
        P_power3=P_power3+0.377*2240*716*n_n*n_d*n_w/v*du;
        P_Ft3=P_Ft3+Ft*du;
     elseif v>aax{3}(1) && v<=aax{4}(1)
        delta = 1.06+0.04*a(4).^2;  % 汽车旋转质量换算系数 
        ne = v*a(5)*a(4)/0.377/r;  % 转速（r/min）
        Pe = ( G*f_gundong*v/3600 + Cd*A*v.^3/76140 + delta*m*v*du/3600)/n_n*n_d*n_w;
        sgm=1+Iw/(m*r^2)+If*a(5)^2*a(4)^2*n_n*n_d*n_w/(m*r^2);
        Me=fun_turbine(1)*ne+fun_turbine(2); % 发动机转矩(N.m)
        Ft = Me*a(4)*a(5)*n_n*n_d*n_w/r;  % 汽车的驱动力
        Ff = G*f_gundong;        % 汽车的滚动阻力
        P_power4=P_power4+0.377*2240*716*n_n*n_d*n_w/v*du;
        P_Ft4=P_Ft4+Ft*du;
    end
 
    ge_ne_pe= fun_fuel(1)+fun_fuel(2)*ne.^2+fun_fuel(3)*ne+fun_fuel(4)*Me.^2+fun_fuel(5)*Me+fun_fuel(6)*ne*Me;
    
    Fw = Cd*A*v.^2/21.15;      % 汽车的空气阻力
    Fa=sgm*m*du;%加速阻力
 
    
    % f1(x)动力性分目标函数（驱动功率损失率）
    abE=w1*(P_power1-P_Ft1)/P_power1+w2*(P_power2-P_Ft2)/P_power2+w3*(P_power3-P_Ft3)/P_power3+w4*(P_power4-P_Ft4)/P_power4;
    % f2(x)动力性分目标函数（加速时间）
    abTT = abTT + delta*m*du/(Ft-Ff-Fw-Fa); % 从0到最大速度v_max所用时间 
    % f23(x)经济性分目标函数  
    delta_S = (v + v+du)/2;  % 单位距离
    abQ = abQ + K*Pe*ge_ne_pe*delta_S./102./v./rou; % 耗油量 
end
 fy = par_lamda1*abTT +par_lamda2*abE +par_lamda3*abQ;