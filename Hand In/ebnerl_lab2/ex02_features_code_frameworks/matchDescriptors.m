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
        %matchesOneway = matches
        
    elseif strcmp(matching, 'mutual')
        matches = [];
        
        for i=1:size(descr1,2); %for each descriptor in 'descr1'...
            ssd_min = Inf; %initialize ssd_min
            for j=1:size(descr2,2) % ... we need to check every descriptor in 'descr2'
                
                ssd_ij = ssd(descr1(:,i), descr2(:,j));
                
                if ssd_ij < ssd_min
                    ssd_min = ssd_ij; %if 
                    onewayMatch = [i;j];
                end
                
            end
            
            % At this point we found the best match for the i-th descriptor in descr1. If the one way match is [i; j], then we check for j-th descriptor in descr2 if the i-th descriptor in descr1 is also the best match
            ssd_min = Inf;
            for k=1:size(descr1,2)
                ssd_kj = ssd(descr1(:,k),descr2(:,onewayMatch(2)));
                if ssd_kj < ssd_min
                    ssd_min = ssd_kj;
                    reverseMatch = [k;onewayMatch(2)];
                end
            end
            if (reverseMatch == onewayMatch)
                matches = [matches, reverseMatch];
            end

            
        end
        %matchesMutual = matches
    elseif strcmp(matching, 'ratio')
        
        thresholdRatio = 0.5;
        matches = [];
        
        
        for i=1:size(descr1,2); %for each descriptor in 'descr1'...
            ssdMatrix = [];
            for j=1:size(descr2,2) % ... we need to check every descriptor in 'descr2'

                ssd_ij = ssd(descr1(:,i), descr2(:,j));
                ssdMatrix = [ssdMatrix, ssd_ij]; %store all ssd in matrix
              
            end
            ssdMatrix = ssdMatrix;
            [minValues, minIndices] = mink(ssdMatrix, 2); %get the two smalles values with their indices
                
            if (minValues(1)/minValues(2)) < thresholdRatio
                matches = [matches, [i;minIndices(1)]];
            end
        end
        %matchesRatio = matches
    else
        error('Unknown matching type.');
    end
end

function distances = ssd(descr1, descr2)
    
    distances = sum( pdist2(descr1',descr2','squaredeuclidean') );

end