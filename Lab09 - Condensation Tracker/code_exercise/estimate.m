function meanState = estimate(particles,particles_w)
%ESTIMATE should estimate the mean state given the particles and their weights

meanState = (particles' * particles_w)'; % size Nx1

end

