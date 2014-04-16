E = zeros(100,8);

for kout = 1:8 
    for i=1:100
        [A groups] = get_newman_random_graph(16-kout);
        [groupsNMF P] = run_commDetNMF(A,5,0);
        E(i,kout) = mean(get_entropy(P));
        
        progressbar( (i*kout) / 800)
    end
end

%plot(E)