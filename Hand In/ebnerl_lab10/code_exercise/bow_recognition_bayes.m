function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)


[muPos sigmaPos] = computeMeanStd(vBoWPos);
[muNeg sigmaNeg] = computeMeanStd(vBoWNeg);
%disp(['muPos, sigmaPos = ', num2str(muPos), num2str(sigmaPos)])
%disp(['muNeg, sigmaNeg = ', num2str(muNeg), num2str(sigmaNeg)])
%disp(['mean(sigmaPos) = ', num2str(mean(sigmaPos))])
%disp(['mean(sigmaNeg) = ', num2str(mean(sigmaNeg))])

% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words

num_visual_words = size(histogram,2);

log_p_pos = 0;
log_p_neg = 0;

for word=1:num_visual_words
   
    % log(p(car|histogram))
    log_p_pos_word = log( normpdf(histogram(word), muPos(word), sigmaPos(word)) );  % log of the probability that a visual word occurs exactly 'histogram(word)' times
    if( ~isnan(log_p_pos_word) )
        log_p_pos = log_p_pos + log_p_pos_word;
    end
    
    % log(p(nocar|histogram))
    log_p_neg_word = log( normpdf(histogram(word), muNeg(word), sigmaNeg(word)) ); 
    if( ~isnan(log_p_neg_word) )
        log_p_neg = log_p_neg + log_p_neg_word;
    end
    
end

label = 0;
if(log_p_pos > log_p_neg)
    label = 1;
end
    
end
