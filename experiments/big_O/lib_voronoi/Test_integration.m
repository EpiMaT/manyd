function Test_integration
% using the basic test to see QMC points convergence rate and 

% f=@(x,y) x+y;
f=@(x,y,z,w) sin(2*x)+cos(3*y)+sin(z)+w;
% f=@(x,y,z,w) x+y+z+w;

exact=2;

d=4;
init=d*2^3;
nruns=20;
nnum=6;
Multiplyer=2^6;
err_mc=zeros(nnum,nruns);
err_qmc=zeros(nnum,nruns);
err_voro=zeros(nnum,nruns);
err_voro_exact=zeros(nnum,nruns);
% qmc_mat=i4_sobol_generate(d,2^15,randi(1000));

for i=1:nnum
    for j=1:nruns
        n=init*2^(i-1);
        mc_data=rand(n,d);
        sdata=sample_gen(n,d,'sobol',randi(1000));
% Voronoi volume as weight
%         w=voronoiVolumes(sdata);
        qmc_mat=sample_gen(Multiplyer*n,d,'sobol',randi(1000));
        w_exact=voronoiVolumes(sdata');
        w=voronoivol(qmc_mat,sdata);
        gdata=sdata;
        f_value=f(gdata(:,1),gdata(:,2),gdata(:,3),gdata(:,4));
        mc_int=sum(f(mc_data(:,1),mc_data(:,2),mc_data(:,3),mc_data(:,4)))/n;
        qmc_int=sum(f_value)/n;
        voro_int=w'*f_value;
        voro_exact=w_exact*f_value;
        err_qmc(i,j)=(abs(qmc_int-exact));
        err_voro(i,j)=(abs(voro_int-exact));
        err_voro_exact(i,j)=abs(voro_exact-exact);
        err_mc(i,j)=abs(mc_int-exact);
    end
end

err_mc(:,1)=log10(mean(err_mc,2));
err_qmc(:,1)=log10(mean(err_qmc,2));
err_voro(:,1)=log10(mean(err_voro,2));
err_voro_exact(:,1)=log10(mean(err_voro_exact,2));

plot(1:nnum,err_mc(:,1),'k',1:nnum,err_qmc(:,1),'b',1:nnum,err_voro(:,1),'r',1:nnum,err_voro_exact(:,1),'g')
xlabel(['log2(number of points) with ','Multiplyer is ',num2str(Multiplyer)]);
ylabel('log10(averge error of nruns)');
legend('MC error','QMC error','Voronoi error','Exact Voronoi error')

