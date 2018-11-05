function [t_exact,errs,ts]=time_voronoi

%n is the number of time we test
% n=2;
% T is the matrix to count the time
% T=zeros(2,n);
% e=zeros(1,n);

for npts=1:7
    for dim=2:6
        for qmc_pwr=1:12
            disp([npts,dim,qmc_pwr])
            pt_count = 2^npts;
            [t_exact(npts,dim,qmc_pwr),errs(npts,dim,qmc_pwr,:),ts(npts,dim,qmc_pwr,:)]=test_voronoi(dim,pt_count,qmc_pwr);
        end
    end
end


% fileID=fopen('time.txt','w');
% fprintf(fileID,'%f %f\n',T);
% fclose(fileID);
%
% fileID=fopen('err.txt','w');
% fprintf(fileID,'%f\n',e);
% fclose(fileID);