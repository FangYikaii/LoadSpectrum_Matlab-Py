function chromosome=nsga_2(pop,gen) 
[M, V, min_range, max_range] = objective_description_function();

%% Initialize the population
% Population is initialized with random values which are within the specified range. 
% Each chromosome[染色体] consists of the decision variables. 
% Also the value of the objective functions【目标函数】, rank【秩】 and crowding distance【拥挤程度】 information is also added to the chromosome vector
% but only the elements of the vector 【有着决策变量的元素】which has the decision variables are operated upon to
% perform the genetic operations like corssover and mutation.【跨越，突变】
chromosome = initialize_variables(pop, M, V, min_range, max_range); % chromosome :pop X (M+V)
%% Sort the initialized population
% Sort the population using non-domination-sort. This returns two columns
% for each individual which are the rank and the crowding distance
% corresponding to their position in the front they belong. At this stage
% the rank and the crowding distance for each chromosome is added to the
% chromosome vector for easy of computation.
chromosome = non_domination_sort_mod(chromosome, M, V); % chromosome input : M+V; chromosome output: M+V+2

%% Start the evolution process
% The following are performed in each generation
% * Select the parents which are fit for reproduction
% * Perfrom crossover and Mutation operator on the selected parents
% * Perform Selection from the parents and the offsprings
% * Replace the unfit individuals with the fit individuals to maintain a
%   constant population size.

for i = 1 : gen
    fprintf('%d generations completed\n',i);
    % Select the parents
    % Parents are selected for reproduction to generate offspring. The
    % original NSGA-II uses a binary tournament selection based on the
    % crowded-comparision operator. The arguments are 
    % pool - size of the mating pool. It is common to have this to be half the
    %        population size.
    % tour - Tournament size. Original NSGA-II uses a binary tournament
    %        selection, but to see the effect of tournament size this is kept
    %        arbitary, to be choosen by the user.
    pool = round(pop/2);
    tour = 2; % tout <= 5 noticed by zzb 
    % Selection process
    % A binary tournament selection is employed in NSGA-II. In a binary
    % tournament selection process two individuals are selected at random
    % and their fitness is compared. The individual with better fitness is
    % selcted as a parent. Tournament selection is carried out until the
    % pool size is filled. Basically a pool size is the number of parents
    % to be selected. The input arguments to the function
    % tournament_selection are chromosome, pool, tour. The function uses
    % only the information from last two elements in the chromosome vector.
    % The last element has the crowding distance information while the
    % penultimate element has the rank information. Selection is based on
    % rank and if individuals with same rank are encountered, crowding
    % distance is compared. A lower rank and higher crowding distance is
    % the selection criteria.
    parent_chromosome = tournament_selection(chromosome, pool, tour); % chromosome: M+V+2; parent_chromosome: M+V+2
    
    % Perfrom crossover and Mutation operator
    % The original NSGA-II algorithm uses Simulated Binary Crossover (SBX) and
    % Polynomial  mutation. Crossover probability pc = 0.9 and mutation
    % probability is pm = 1/n, where n is the number of decision variables.
    % Both real-coded GA and binary-coded GA are implemented in the original
    % algorithm, while in this program only the real-coded GA is considered.
    % The distribution indeices for crossover and mutation operators as mu = 20
    % and mum = 20 respectively.
    mu = 20;
    mum = 20;
    offspring_chromosome = genetic_operator(parent_chromosome, ...
        M, V, mu, mum, min_range, max_range); % parent_chromosome: M+V+2; offspring_chromosome: M+V
    
    % Intermediate population  中间种群
    % Intermediate population is the combined population of parents and
    % 是父代和偏移带的结合，是之前的两倍
    % offsprings of the current generation. The population size is two
    % times the initial population.
    
    main_pop = size(chromosome,1);                       % modified by zzb
    offspring_pop = size(offspring_chromosome,1);        % modified by zzb
    % temp is a dummy variable.
    % clear temp
    % intermediate_chromosome is a concatenation of current population and
    % the offspring population.
    % intermediate_chromosome(1:main_pop,:) = chromosome; % modified by zzb
    intermediate_chromosome(1:main_pop,1 : M + V) = chromosome(:,1 : M + V); % modified by zzb
    intermediate_chromosome(main_pop + 1 : main_pop + offspring_pop,1 : M + V) = ...
        offspring_chromosome;
    
    % Non-domination-sort of intermediate population
    % The intermediate population is sorted again based on non-domination sort
    % before the replacement operator is performed on the intermediate
    % population.
    intermediate_chromosome = ...
        non_domination_sort_mod(intermediate_chromosome, M, V); % intermediate_chromosome input : M+V; intermediate_chromosome output: M+V+2
    
    % Perform Selection
    % Once the intermediate population is sorted only the best solution is
    % selected based on it rank and crowding distance. Each front is filled in
    % ascending order until the addition of population size is reached. The
    % last front is included in the population based on the individuals with
    % least crowding distance
    chromosome = replace_chromosome(intermediate_chromosome, M, V, pop); % intermediate_chromosome: M+V+2; chromosome: M+V+2
    
    if ~mod(i,100)   % modified by zzb
       clc;
       fprintf('%d generations completed\n',i);
    end
end

%% Result
% Save the result in ASCII text format.
save solution.txt chromosome -ASCII;
end
    
