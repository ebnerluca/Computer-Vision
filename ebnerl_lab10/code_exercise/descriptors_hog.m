function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    nCellsW = 4; % number of cells, hard coded so that descriptor dimension is 128
    nCellsH = 4; 

    w = cellWidth; % set cell dimensions
    h = cellHeight;   

    pw = w*nCellsW; % patch dimensions
    ph = h*nCellsH; % patch dimensions

    descriptors = zeros(size(vPoints,1),nBins*nCellsW*nCellsH); % one histogram for each of the 16 cells
    patches = zeros(size(vPoints,1),pw*ph); % image patches stored in rows    
    
    [grad_x,grad_y] = gradient(img);    
    Gdir = (atan2(grad_y, grad_x)); 
    
    bin_edges = linspace(-pi,pi,nBins+1);
    
    for i = [1:size(vPoints,1)] % for all local feature points
        
        % compute patch
        top_left = vPoints(i,:) - [(nCellsW/2)*w, (nCellsH/2)*h];
        patch_width = nCellsW * w;
        patch_height = nCellsH * h;
        patch = img( top_left(2):top_left(2)+patch_height-1, top_left(1):top_left(1)+patch_width-1 );
        patches(i,:) = patch(:);
        
        % compute cell histograms
        cell_histograms = zeros(nCellsW*nCellsH,8); % size N_cells x N_bins
        cell_idx = 1;
        for u=1:nCellsW
            for v=1:nCellsH
                
                top_left_cell = [top_left(1) + (u-1)*w, top_left(2) + (v-1)*h];
                cell_Gdir = Gdir(top_left_cell(2):top_left_cell(2)+h-1, top_left_cell(1):top_left_cell(1)+w-1);
                cell_histograms(cell_idx,:) = histcounts(cell_Gdir, bin_edges);
                cell_idx = cell_idx + 1;
                
            end
        end
        
        % concatenate cell histograms
        descriptors(i,:) = reshape(cell_histograms', [], 1);
    end % for all local feature points
        
end
