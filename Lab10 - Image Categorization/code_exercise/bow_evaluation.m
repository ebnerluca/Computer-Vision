%
% BAG OF WORDS RECOGNITION EXERCISE
% Alex Mansfield and Bogdan Alexe, HS 2011
% Denys Rozumnyi, HS 2019

clear all;
close all;

sizeCodebook = [50, 100, 150, 200, 250, 300, 350, 400, 450, 500];
num_runs = 10; %how many times we run with each codebook size

percentages_nearest = zeros(length(sizeCodebook), num_runs);
percentages_bayes = zeros(length(sizeCodebook), num_runs);

mean_percentages_nearest = zeros(length(sizeCodebook),1);
mean_percentages_bayes = zeros(length(sizeCodebook),1);

codebook_index = 1;
for k = sizeCodebook
    for i=1:num_runs
        
        %training
        disp(['creating codebook of size ', num2str(k), ', run ', num2str(i),'/', num2str(num_runs)]);
        % sizeCodebook = 400;
        vCenters = create_codebook('../data/cars-training-pos','../data/cars-training-neg',k);
        %keyboard;
        disp('processing positve training images');
        vBoWPos = create_bow_histograms('../data/cars-training-pos',vCenters);
        disp('processing negative training images');
        vBoWNeg = create_bow_histograms('../data/cars-training-neg',vCenters);
        %vBoWPos_test = vBoWPos;
        %vBoWNeg_test = vBoWNeg;
        %keyboard;
        disp('processing positve testing images');
        vBoWPos_test = create_bow_histograms('../data/cars-testing-pos',vCenters);
        disp('processing negative testing images');
        vBoWNeg_test = create_bow_histograms('../data/cars-testing-neg',vCenters);

        nrPos = size(vBoWPos_test,1);
        nrNeg = size(vBoWNeg_test,1);

        test_histograms = [vBoWPos_test;vBoWNeg_test];
        labels = [ones(nrPos,1);zeros(nrNeg,1)];

        disp('______________________________________')
        disp('Nearest Neighbor classifier')
        percentages_nearest(codebook_index,i) = bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_nearest);
        mean_percentages_nearest(codebook_index) = mean_percentages_nearest(codebook_index) + percentages_nearest(codebook_index,i);
        disp('______________________________________')
        disp('Bayesian classifier')
        percentages_bayes(codebook_index,i) = bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_bayes);
        mean_percentages_bayes(codebook_index) = mean_percentages_bayes(codebook_index) + percentages_bayes(codebook_index,i);
        disp('______________________________________')
        
        figure(100);
        plot(k,percentages_nearest(codebook_index,i),'bx'); hold on;
        plot(k,percentages_bayes(codebook_index,i),'rx'); hold on;
    
    end
    
    mean_percentages_nearest(codebook_index) = mean_percentages_nearest(codebook_index) / num_runs;
    mean_percentages_bayes(codebook_index) = mean_percentages_bayes(codebook_index) / num_runs;
    codebook_index = codebook_index + 1;

end

figure(100);
plot(sizeCodebook,mean_percentages_nearest,'b','linewidth',1); grid on; hold on;
plot(sizeCodebook,mean_percentages_bayes,'r','linewidth',1);
xlabel('Codebook size k');
ylabel('Accuracy [%]')
legend('Accuracy for Nearest Neighbor Classification',...
       'Accuracy for Bayes Classification');
title('Variation of accuracy with codebook size')


