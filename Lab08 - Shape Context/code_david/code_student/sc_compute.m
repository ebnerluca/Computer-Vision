function d = sc_compute(X, nbBins_theta, nbBins_r, smallest_r, biggest_r)

X = X';  % noticed after implementing that X comes in transposed...
n_points = size(X, 1);
d = cell(n_points, 1);  % each descriptor is stored in a cell corresponding to its point

% define bins (or rather bin edges)
bins_r = logspace(log10(smallest_r), log10(biggest_r), nbBins_r);
bins_r = [0, bins_r];  % account for inner most bin
%bins_theta = linspace(0, 2 * pi * (1 - 1 / nbBins_theta), nbBins_theta) - pi
bins_theta = linspace(-pi, pi, nbBins_theta+1);

% compute pairwise distance and normalize by mean
pairwise_dist = pdist(X);
mean_dist = sum(pairwise_dist) / size(pairwise_dist, 2);  % to normalize r
pairwise_dist = squareform(pairwise_dist);  % allow access via query point indices
pdist_normalized = pairwise_dist / mean_dist;

pairwise_theta = zeros(n_points, n_points);  % theta range is (-pi, pi]
for i=1:n_points
    for k=(i+1):n_points
        theta = atan2(X(k, 1) - X(i, 1), X(k, 2) - X(i, 2));
        pairwise_theta(i, k) = theta;
        
        % switching points k and i leads to 180° flip of theta, sign is
        % checked to stay consistent with the value range
        if theta < 0
            pairwise_theta(k, i) = theta + pi;
        else
            pairwise_theta(k, i) = theta - pi;
        end
    end    
end

% compute histograms for each point, making sure to not include itself
for i=1:n_points
    dists = pdist_normalized(i, :);
    indices = find(dists > 0);
    d{i} = histcounts2(dists(indices), pairwise_theta(i, indices), bins_r, bins_theta);
end

% debug

figure(51)  % don't you dare to mess with other figures
% subplot(1,2,1)
% histogram2('XBinEdges', bins_r,'YBinEdges', bins_theta, 'BinCounts', d{1}, 'ShowEmptyBins', 'on')
% xlabel('r')
% ylabel('theta')
% zlabel('count')
% set(gca, 'XScale', 'log')
% subplot(1, 2, 2)
h = bar3(d{1});
for i = 1:length(h)
     zdata = get(h(i),'Zdata');
     set(h(i),'Cdata',zdata)
end
colorbar
ylabel('r')
xlabel('theta')
zlabel('count')
set(gca, 'YTickLabel', [])
set(gca, 'XTickLabel', [])

figure(52)
imshow(d{1}, [])


end