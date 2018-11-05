clc
clearvars

ds = [2 4 5];
pts = [25 50 100];
for i = 1:length(ds)
    for j = 1:length(pts)

        sdata = rand(ds(i), pts(j));
        begin = tic;
        areas = voronoiVolumes(sdata)
        ts(j) = toc(begin);

        figure(1)
        subplot(length(ds),length(pts),(i-1)*length(ds)+j);
        hist(areas,20);
        xlabel('volume');
        drawnow
    end
end
figure(2)
plot(pts, ts,'*')
xlabel('n points')
ylabel('time in secs to calc voronoi')