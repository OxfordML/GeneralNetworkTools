function build_LFR_parameter_file(N,kavg,kmax,gamma,beta,mu,minc,maxc)

fid = fopen('parameters.dat','w');

fprintf(fid,'%d\n',N);
fprintf(fid,'%f\n',kavg);
fprintf(fid,'%d\n',kmax);
fprintf(fid,'%f\n',gamma);
fprintf(fid,'%f\n',beta);
fprintf(fid,'%f\n',mu);
fprintf(fid,'%d\n',minc);
fprintf(fid,'%d\n',maxc);

fclose(fid);


end