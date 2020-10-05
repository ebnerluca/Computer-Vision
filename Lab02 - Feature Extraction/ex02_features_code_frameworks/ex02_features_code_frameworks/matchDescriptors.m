% Match descriptors.
%
% Input:
%   descr1        - k x q descriptor of first image
%   descr2        - k x q' descriptor of second image
%   matching      - matching type ('one-way', 'mutual', 'ratio')
%   
% Output:
%   matches       - 2 x m matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, matching)
    distances = ssd(descr1, descr2);
    
    if strcmp(matching, 'one-way')
        
        matches = [];
        
        for i=1:size(descr1,2); %for each descriptor in 'descr1'...
            ssd_min = Inf; %initialize ssd_min
            for j=1:size(descr2,2) % ... we need to check every descriptor in 'descr2'
                
                ssd_ij = ssd(descr1(:,i), descr2(:,j));
                
                if ssd_ij < ssd_min
                    ssd_min = ssd_ij; %if 
                    bestMatch = j;
                end
                
            end
            matches = [matches, [i;bestMatch]];
        end
    elseif strcmp(matching, 'mutual')
        error('Not implemented.');
    elseif strcmp(matching, 'ratio')
        error('Not implemented.');
    else
        error('Unknown matching type.');
    end
end

function distances = ssd(descr1, descr2)
    
    distances = sum( pdist2(descr1',descr2','squaredeuclidean') );

end