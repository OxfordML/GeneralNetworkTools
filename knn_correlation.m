function output = knn_correlation(A)
degrees = degree(A);
max_degree = max(degrees);

degrees = sort(intersect(degrees,1:1:max_degree));

knns = zeros(length(degrees),1);

for i=1:length(degrees)
    knns(i) = knn_k(A,degrees(i));
end

scatter(degrees,knns);
end