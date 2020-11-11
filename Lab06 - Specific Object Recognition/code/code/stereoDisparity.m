function disp = stereoDisparity(img1, img2, dispRange)

% dispRange: range of possible disparity values
% --> not all values need to be checked

%img1 = double(img1);
%img2 = double(img2);

% average filter with window size 5
filter = fspecial('average', 10);

init = false;
for d = dispRange % search for best matching pixel within a given disparity range
    
    % difference in grey scale of img1 and shifted img2
    shift_diff = (img1 - shiftImage(img2, d)).^2;

    % apply average filter with window size
    filtered_diff = conv2(shift_diff, filter, 'same');
    
    % initialize variables disparity image
    if init==false
        init = true;
        best_diff = filtered_diff;
        disp = d*ones(size(best_diff));
    end
    
    % create boolean masks for updating best_diff and disparity image
    diff_mask = filtered_diff < best_diff; % mask entries are true for entries which are smaller
    inv_diff_mask = filtered_diff >= best_diff;
    
    % update best_diff
    best_diff = inv_diff_mask.*best_diff + diff_mask.*filtered_diff;
    
    % update disparity img
    disp = inv_diff_mask.*disp + diff_mask.*d;
      
end

end