function [x_samp] = sample_gen_fith(nx_samp,n_dim,x_seed)
%*****************************************************************************80
%
%% SAMPLE_GEN_FITH generate a quasi-uniform sample by filling in the biggest gap in each projected dimension  
%
%  Modified:
%
%    30 November 2011
%
%  Parameters:
%
%    Input, nx_samp, number of generated sample points.
%
%    Input, n_dim, dimension sample points are generated.
%
%    Input, x_seed, 

l_fith='maxmin';

if n_dim == 0 
    [x_samp] = sample_gen_fith_1d(nx_samp,x_seed) ;
    return
end

switch l_fith
      
    case 'project'
    %**** experiment project: 
    % project the points to the axis and generate the points one dimension at a
    % time.  ***** this gives a very poor LHC type distribution 

    % x1 is the sorted 1d cordinates for the samples 
    x_samp = NaN(nx_samp,n_dim);
    for id =1:n_dim
    x_samp(:,id)= sample_gen_fith_1d(nx_samp,x_seed(1,id)) ;
    end

      
    case 'maxmin' 
    % an expensive proceedure when there are lots of points. 
    % it can be used to start a process, then fill in the remaining points
    % with the project proceedure. 

    % it can also be used to add sample points to any list of samples, such
    % as adding a few points to a latin hypercube sample. 
    
    x_samp = NaN(nx_samp,n_dim);
    x_samp(1,:)= x_seed;
    % generate a bunch of point and pick the one furthest from all the existing
    % points
    n_new = 3^n_dim ; % size of space grows to the power of dim
    for ix = 2:nx_samp
        x_new = rand(n_new,n_dim);

        % compute the distances to all current points
        d = zeros(ix,n_new);

        % compute the distances to all current points
        for i1 = 1:n_new
            for i2 = 1:ix-1
                d(i2,i1)=norm(x_new(i1,:)-x_samp(i2,:));
            end
            % compute the distance to the nearest boundary
            % divide by the dimension so that the distance to the boundary scales
            % properly with the dimension.  Otherwise, there will be no points near
            % the boundary
            d(ix,i1)=min(min(x_new(i1,:)),min(1.-x_new(i1,:)))*n_dim;
        end

        min_d = min(d);
        [~ ,i_max] = max(min_d);
        x_samp(ix,:) = x_new(i_max,:) ;
    end

    case 'maxmin_LHC'
    %  this is an expensive proceedure when there are lots of points. 
    % it can be used to start a process, then fill in the remaining points
    % with the project proceedure. 
    
    % it can also be used to add sample points to any list of samples, such
    % as adding a few points to a latin hypercube sample. 
    
    x_samp = NaN(nx_samp,n_dim);
    x_samp(1,:)= x_seed;
    % generate a bunch of point and pick the one furthest from all the existing
    % points
    % n_new = 8*n_dim ;
    n_new = 3^n_dim ; % size of space grows to the power of dim
    for ix = 2:nx_samp
        x_new = rand(n_new,n_dim);

    % compute the distances to all current points
    d = zeros(ix,n_new);

    % compute the distances to all current points
    for i1 = 1:n_new
        for i2 = 1:ix-1
            d(i2,i1)=norm(x_new(i1,:)-x_samp(i2,:));
        end
        % compute the distance to the nearest boundary
        % divide by the dimension so that the distance to the boundary scales
        % properly with the dimension.  Otherwise, there will be no points near
        % the boundary
        d(ix,i1)=min(min(x_new(i1,:)),min(1.-x_new(i1,:)))*n_dim;
    end

    min_d = min(d);
    [~ ,i_max] = max(min_d);
    x_samp(ix,:) = x_new(i_max,:) ;

    %  projecting the samples to a LHC
    x_samp1 = NaN(ix,n_dim);
    for i=1:ix
        x_samp1(i,:)=x_samp(i,:);
    end
    l_adjust='LHC';
    [x_adjusted] = sample_adjust(x_samp1,l_adjust,1);
    for i=1:ix
        x_samp(i,:)=x_adjusted(i,:);
    end
    %}
    end


    otherwise
        error([l_fith,' not a case for sample_gen_fith']) 
    end

end


