function plot_voronoi

dim = 5;
npts = 32;
nruns = 100;

for q = 2:5
    tic
    parfor i = 1:nruns
        [t_exact(q,i),errs(q,i,:),ts(q,i,:)]=test_voronoi(dim,npts,q^dim);
    end
    toc
end
mean_errs = squeeze(mean(errs,2));
mean_ts = squeeze(mean(ts,2));

subplot(1,2,1)
semilogy(mean_errs,'*-');
title(sprintf('%d dimensions, %d voronoi cells, %d runs',dim,npts,nruns))
xlabel(sprintf('%d^x QMC points',dim))
ylabel('mean 2-norm error from true voronoi volume')
legend('niederreiter','rand','grid','edgegrid','1/n')

subplot(1,2,2)
semilogy(mean_ts,'*-');
title(sprintf('%d dimensions, %d voronoi cells, %d runs',dim,npts,nruns))
xlabel(sprintf('%d^x QMC points',dim))
ylabel('mean time in seconds')
legend('niederreiter','rand','grid','edgegrid','1/n')


% figure(2);
% plot(squeeze(errs(6,5,:,:)))
% semilogy(squeeze(errs(6,5,:,:)));
% title('5 dimensions, 2^6 voronoi cells')
% xlabel('2^x QMC points')
% ylabel('2-norm error from true voronoi volume')
% legend('niederreiter','rand','grid','edgegrid','1/n')

end