function percentage = bow_recognition_multi(histograms,labels,vBoWPos,vBoWNeg, classifierFunction)
  
   image_count = size(histograms,1); 
   pos = 0;
   neg = 0;
    for i = 1:image_count
		% classify each histogram
        % disp(['Classifying image ', num2str(i), '/', num2str(image_count)])
        l = classifierFunction(histograms(i,:),vBoWPos,vBoWNeg);

        % compare the result to the respective label
        if (l == labels(i)) % positive
            pos = pos + 1;
        else %negative
            neg = neg + 1;
        end
    end
    
    percentage = pos/image_count;
    disp(['Percentage of correctly classified images:' num2str(percentage)]);
   
end
  
