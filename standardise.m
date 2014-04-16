function s = standardise(v)
s = (v - mean(v))/std(v);
end