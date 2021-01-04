function particles = propagate(particles, sizeFrame, params)
%   PROPAGATE propagates the particles given the system prediction
%   model (matrix A) and the system model noise

% set A matrix and noise depending on model (no motion / const velocity)
if params.model == 0 % no motion
    A = eye(2);
    noise = normrnd(0,params.sigma_position, params.num_particles,2);
else
    A = [1, 0, 1, 0;
         0, 1, 0, 1;
         0, 0, 1, 0;
         0, 0, 0, 1];

    noise = [ normrnd(0,params.sigma_position, params.num_particles,2), normrnd(0,params.sigma_velocity, params.num_particles,2) ];
end

% propaget particles
particles = (A*particles')' + noise;

% bound particles inside frame
particles(:,1) = min( max(particles(:,1), 1), sizeFrame(2) );
particles(:,2) = min( max(particles(:,2), 1), sizeFrame(1) );

end

