clear all;   close all; clf; format short
 set(0,'DefaultAxesFontSize',15)
 
 nx_samp = 10 ;
n_dim = 2  ;
seed = NaN(1,n_dim) ;

nrun = 1;
nseed = NaN(nrun,n_dim);
nmetric = NaN(nrun,1) ;

for irun = 1:nrun
    
 seed = rand(1,n_dim) ;
 nseed(irun,:) = seed ;
 [x_samp] = sample_gen_FITH(nx_samp,n_dim,seed) ;
 l_samp = 'rand' ; % 'rand' 'sobol' 'niederreiter' 'LHC' 'fith' 'halton'
 % [x_samp] = sample_gen(nx_samp,n_dim,l_samp,0,23);


l_metric='maxmin' ; % 'project' 'maxmin'
[metric] =  sample_metric(x_samp,l_metric,1) ;
nmetric(irun,1) = metric ;

end

% best run 
[bmetric ibest] = min(nmetric)

seed = nseed(ibest,:)
%[x_samp] = sample_gen_FITH(nx_samp,n_dim,seed) ;

figure
sample_plot( x_samp,'best','red',0.0 )