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

    w=chi;              % Inertia Weight  ����Ȩ��
    wdamp=1;            % Inertia Weight Damping Ratio ����Ȩ�������
    c1=chi*phi1;        % Personal Learning Coefficient  ����ѧϰϵ��
    c2=chi*phi2;        % Global Learning Coefficient   Ⱥ��ѧϰϵ��

    alpha=0.05;  % Grid Inflation Parameter  �������Ų��� 0.1

    nGrid=5;   % Number of Grids per each Dimension  ÿ��ά��������Ŀ  10

    beta=4;     % Leader Selection Pressure Parameter �쵼ѡ��ѹ������  4

    gamma=2;    % Extra (to be deleted) Repository Member Selection Pressure ���ⱻɾ���Ŀ��Ա����

    %% Initialization  ��ʼ��
    % ��ʼ�����ռ�
    particle=CreateEmptyParticle(nPop);
    % 1:100
    for i=1:nPop
        % �ٶ�
        particle(i).Velocity=0;
        % λ��
        particle(i).Position=unifrnd(VarMin,VarMax,VarSize);
        % Ŀ�꺯��
        particle(i).Cost=CostFunction(particle(i).Position);
        % ���λ��
        particle(i).Best.Position=particle(i).Position;
        % ���Ŀ�꺯��
        particle(i).Best.Cost=particle(i).Cost;
    end
    % 
    particle=DetermineDomination(particle);
    % ��Ӣ��
    rep=GetNonDominatedParticles(particle);
    % ��Ӣ��Ŀ�꺯��
    rep_costs=GetCosts(rep);
    G=CreateHypercubes(rep_costs,nGrid,alpha);

    for i=1:numel(rep)
        [rep(i).GridIndex, rep(i).GridSubIndex]=GetGridIndex(rep(i),G);
    end

    %% MOPSO Main Loop

    for it=1:MaxIt
        for i=1:nPop
            rep_h=SelectLeader(rep,beta);
            % ��Ҫ�������ٶȺ�λ��
            particle(i).Velocity=w*particle(i).Velocity ...
                                 +c1*rand*(particle(i).Best.Position - particle(i).Position) ...
                                 +c2*rand*(rep_h.Position -  particle(i).Position);
            %
            particle(i).Velocity=min(max(particle(i).Velocity,-VelMax),+VelMax);
            % λ��=λ��+�ٶ�
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
        % ���ӵ� ��Ӣ��
        rep=[rep
             nd_particle];
        % ����֧��
        rep=DetermineDomination(rep);
        % ��÷�֧������
        rep=GetNonDominatedParticles(rep);

        for i=1:numel(rep)
            [rep(i).GridIndex, rep(i).GridSubIndex]=GetGridIndex(rep(i),G);
        end

        % �����Ӣ�⼯�Ĵ�С�����˼ȶ���С�����޳���Ӣ���ϵ��ӽ�
        if numel(rep)>nRep
            % ����������
            EXTRA=numel(rep)-nRep;
            % �޳����Ӻ�Ľ⼯
            rep=DeleteFromRep(rep,EXTRA,gamma);
            % Ŀ�꺯��ֵ����Ӣ�⼯��
            rep_costs=GetCosts(rep);
            G=CreateHypercubes(rep_costs,nGrid,alpha);

        end

        disp(['Iteration ' num2str(it) ': Number of Repository Particles = ' num2str(numel(rep))]);  

        % Ȩ�� = Ȩ��*����Ȩ������
        w=w*wdamp;
    end

    %% Results

    costs=GetCosts(particle);
    rep_costs=GetCosts(rep);


