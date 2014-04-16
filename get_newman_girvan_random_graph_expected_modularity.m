function Q = get_newman_girvan_random_graph_expected_modularity(kin)
Q = (128*kin*(1-(16^2)/(128*16/2)))/ (128*16);
end