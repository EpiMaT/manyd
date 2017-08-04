function [x_samp] = sample_gen_fith_1d(nx_samp,seed)
% generate a quasi=unifrom sample by filling in the biggest 
% gap in each projected dimension. 
% this code is not optimized!!

%just making it ED in x and y fails

% need to use a LHC sampling approach to get good samples. 


x_samp = NaN(nx_samp,1);
x_samp(1,:) = seed(1,:) ;

% x1 is the sorted 1d cordinates for the samples 
x1 = NaN(nx_samp+2,1);
dx = NaN(nx_samp+1,1);

x1(1,:) = 0;
x1(2,:) = seed ;
x1(3,:) = 1;
for i = 1:2;
        dx(i,1) = x1(i+1,1) - x1(i,1);
end
  
    

for ix = 4:nx_samp+2;
 
% x1 defined for i= 1:ix-1, dx defined for i=1:ix-2
    
         
   
    % find the largest gap note you are sorting a lot of NaN
    [~, imax] = max(dx(:,1)) ;
    
    % define the new point in the midpoint 
    xnew = 0.5*(x1(imax+1,1)+x1(imax,1)) ;
    
    % resort x1 and define new dx
    for i = ix:-1:imax+1 ;
        x1(i,1) = x1(i-1,1);
        dx(i,1) = dx(i-1,1);
    end
    x1(imax+1,1) = xnew;
     dx(imax,1) = 0.5*dx(imax,1);
     dx(imax+1,1) = dx(imax,1) ;
   
    
    x_samp(ix-2,1)=xnew; 
   
end
end

