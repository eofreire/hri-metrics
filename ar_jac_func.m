function ar_jac_ref = ar_jac_func(referent, npart)

  % Initialize the Jaccard consensus value (delta_ref)
  delta_ref = 0;

  % Loop through each pair of participants
  for i = 1:npart
    for j = i+1:npart % number of participants
      % Find the unique gestures performed by participant i
      gestures_i = unique(referent(referent(:, 1) == i, 2));

      % Find the unique gestures performed by participant j
      gestures_j = unique(referent(referent(:, 1) == j, 2));

      % Calculate the intersection and union of the gestures
      [num_inter, ~] = size(intersect(gestures_i, gestures_j));
      [num_union, ~] = size(union(gestures_i, gestures_j));

      % Calculate the Jaccard similarity
      delta = num_inter / num_union;

      % Accumulate the Jaccard similarity values
      delta_ref = delta_ref + delta;
    endfor
  endfor

  % Normalize the Jaccard consensus value across all participant pairs
  ar_jac_ref = delta_ref / (npart * (npart - 1) / 2);
endfunction

