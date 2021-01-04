function sLabel = bow_recognition_nearest(histogram,vBoWPos,vBoWNeg)
  
  % Find the nearest neighbor (using knnsearch) in the positive and negative sets
  % and decide based on this neighbor
  
  % compute distance from hist to closest neighbor in positive training set
  [~, DistPos] = knnsearch(vBoWPos, histogram);
  
  % compute distance from hist to closest neighbor in negative training set
  [~, DistNeg] = knnsearch(vBoWNeg, histogram);

  
  if (DistPos<DistNeg) % if histogram is closer to positive test set, the image is classified as car
    sLabel = 1;
  else
    sLabel = 0;
  end
  
end
