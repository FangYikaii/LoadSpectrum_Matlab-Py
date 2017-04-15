function f = initialize_variables(N, M, V, min_range, max_range)
min = min_range;
max = max_range;
K = M + V;
f = zeros(N,K);  
for i = 1 : N
    for j = 1 : V
        f(i,j) = min(j) + (max(j) - min(j))*rand(1);
    end
    f(i,V + 1: K) = Model(f(i,1:V));
end
