function [costs,rep_costs]=mopso(nPop,nRep,MaxIt)
    %% Problem Definition
    global par_ig1 par_ig2 par_ig3 par_ig4 par_io par_turbineD;
    CostFunction=@(x) Model(x);
    nVar=6;
    VarMin=[par_ig1-0.3 par_ig2-0.3 par_ig3-0.2 par_ig4-0.1 par_io-0.5 par_turbineD-0.03];
    VarMax=[par_ig1+0.3 par_ig2+0.3 par_ig3+0.2 par_ig4+0.1 par_io+0.5 par_turbineD+0.03];
    VarSize=[1 nVar];

    VelMax=(VarMax-VarMin)/10;

    %% MOPSO Settings
    phi1=2.05;  %2.05
    phi2=2.05;
    phi=phi1+phi2;
    chi=2/(phi-2+sqrt(phi^2-4*phi));

    w=chi;              % Inertia Weight  惯性权重
    wdamp=1;            % Inertia Weight Damping Ratio 惯性权重阻尼比
    c1=chi*phi1;        % Personal Learning Coefficient  个体学习系数
    c2=chi*phi2;        % Global Learning Coefficient   群体学习系数

    alpha=0.05;  % Grid Inflation Parameter  网格扩张参数 0.1

    nGrid=5;   % Number of Grids per each Dimension  每个维度网格数目  10

    beta=4;     % Leader Selection Pressure Parameter 领导选择压力参数  4

    gamma=2;    % Extra (to be deleted) Repository Member Selection Pressure 额外被删除的库成员参数

    %% Initialization  初始化
    % 初始化，空集
    particle=CreateEmptyParticle(nPop);
    % 1:100
    for i=1:nPop
        % 速度
        particle(i).Velocity=0;
        % 位置
        particle(i).Position=unifrnd(VarMin,VarMax,VarSize);
        % 目标函数
        particle(i).Cost=CostFunction(particle(i).Position);
        % 最佳位置
        particle(i).Best.Position=particle(i).Position;
        % 最佳目标函数
        particle(i).Best.Cost=particle(i).Cost;
    end
    % 
    particle=DetermineDomination(particle);
    % 精英集
    rep=GetNonDominatedParticles(particle);
    % 精英集目标函数
    rep_costs=GetCosts(rep);
    G=CreateHypercubes(rep_costs,nGrid,alpha);

    for i=1:numel(rep)
        [rep(i).GridIndex, rep(i).GridSubIndex]=GetGridIndex(rep(i),G);
    end

    %% MOPSO Main Loop

    for it=1:MaxIt
        for i=1:nPop
            rep_h=SelectLeader(rep,beta);
            % 重要，更新速度和位置
            particle(i).Velocity=w*particle(i).Velocity ...
                                 +c1*rand*(particle(i).Best.Position - particle(i).Position) ...
                                 +c2*rand*(rep_h.Position -  particle(i).Position);
            %
            particle(i).Velocity=min(max(particle(i).Velocity,-VelMax),+VelMax);
            % 位置=位置+速度
            particle(i).Position=particle(i).Position + particle(i).Velocity;

            flag=(particle(i).Position<VarMin | particle(i).Position>VarMax);
            particle(i).Velocity(flag)=-particle(i).Velocity(flag);

            particle(i).Position=min(max(particle(i).Position,VarMin),VarMax);

            particle(i).Cost=CostFunction(particle(i).Position);

            if Dominates(particle(i),particle(i).Best)
                particle(i).Best.Position=particle(i).Position;
                particle(i).Best.Cost=particle(i).Cost;

            elseif ~Dominates(particle(i).Best,particle(i))
                if rand<0.5
                    particle(i).Best.Position=particle(i).Position;
                    particle(i).Best.Cost=particle(i).Cost;
                end
            end

        end

        particle=DetermineDomination(particle);
        nd_particle=GetNonDominatedParticles(particle);
        % 增加到 精英集
        rep=[rep
             nd_particle];
        % 决定支配
        rep=DetermineDomination(rep);
        % 获得非支配粒子
        rep=GetNonDominatedParticles(rep);

        for i=1:numel(rep)
            [rep(i).GridIndex, rep(i).GridSubIndex]=GetGridIndex(rep(i),G);
        end

        % 如果精英解集的大小超过了既定大小，则剔除精英集合的劣解
        if numel(rep)>nRep
            % 多余粒子数
            EXTRA=numel(rep)-nRep;
            % 剔除粒子后的解集
            rep=DeleteFromRep(rep,EXTRA,gamma);
            % 目标函数值【精英解集】
            rep_costs=GetCosts(rep);
            G=CreateHypercubes(rep_costs,nGrid,alpha);

        end

        disp(['Iteration ' num2str(it) ': Number of Repository Particles = ' num2str(numel(rep))]);  

        % 权重 = 权重*惯性权重阻尼
        w=w*wdamp;
    end

    %% Results

    costs=GetCosts(particle);
    rep_costs=GetCosts(rep);


