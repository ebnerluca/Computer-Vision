function particles_w = observe(particles, frame, H, W, hist_bin, hist_target, sigma_observe)

% initialize weights
N = size(particles, 1);
particles_w = zeros(N, 1);

for i=1:N % iterate over particles
    
    % box corners
    xMin = particles(i,1) - W/2;
    xMax = particles(i,1) + W/2;
    yMin = particles(i,2) - H/2;
    yMax = particles(i,2) + H/2;
    
    % compute histogram of particle
    hist = color_histogram(xMin, yMin, xMax, yMax, frame, hist_bin);
    
    % compare to target histogram
    diff = chi2_cost(hist, hist_target);
    
    % compute particle weight
    particles_w(i) = (1 / (sqrt(2*pi)*sigma_observe)) * exp(-diff^2 / (2*sigma_observe^2));
    
end

% make sure weights sum up to 1
particles_w = particles_w / sum(particles_w);

end

