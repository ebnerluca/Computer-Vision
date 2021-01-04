function [resampled_particles resampled_particles_w] = resample(particles, particles_w)
% RESAMPLE should resample the particles based on their weights (eq. 6.), and return
% these new particles along with their corresponding weights

% initialize resamples particles
N = size(particles,1);
resampled_particles = zeros(size(particles));
resampled_particles_w = zeros(size(particles_w));

% Resampling wheel
beta = 0; % beta indicates how far we've already travelled on the wheel
index = randi([1 N]); % start wheel at random position
max_w = max(particles_w); % max weight
for i=1:N % resampling the same amount of particles
 
    beta = beta + rand()*2*max_w; % guarantees that no particle is sampled twice in a row
    
    while(beta > particles_w(index))
        beta = beta - particles_w(index); % remaining way to go
        index = mod(index, N) + 1; % make sure to wrap around the index
    end

    resampled_particles(i,:) = particles(index,:);
    resampled_particles_w(i) = particles_w(index);
    
end

% weights must sum up to 1
resampled_particles_w = resampled_particles_w / sum(resampled_particles_w);

end

