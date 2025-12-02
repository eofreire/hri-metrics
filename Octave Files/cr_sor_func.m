function cr_sor_ref = cr_sor_func(referent, npart)
  % Identify unique gestures performed by the referent
  gestures_ref = unique(referent(:, 2));

  % Determine the number of different gestures
  [dif_gestures, ~] = size(gestures_ref);

  % Initialize the consensus value (delta_ref)
  delta_ref = 0;

  % Loop through each pair of participants
  for i = 1:npart
    for j = i+1:npart
      % Find the unique gestures performed by participant i
      gestures_i = unique(referent(referent(:, 1) == i, 2));

      % Find the unique gestures performed by participant j
      gestures_j = unique(referent(referent(:, 1) == j, 2));

      % Get the number of gestures performed by participants i and j
      [num_gestures_i, ~] = size(gestures_i);
      [num_gestures_j, ~] = size(gestures_j);

      % Find the number of common gestures between participants i and j
      [num_inter, ~] = size(intersect(gestures_i, gestures_j));

      % Calculate the Sørensen-Dice coefficient (delta) for this pair of participants
      delta = (2 * num_inter) / (num_gestures_i + num_gestures_j);

      % Accumulate the consensus value
      delta_ref = delta_ref + delta;
    endfor
  endfor

  % Normalize the consensus value across all participant pairs
  cr_sor_ref = delta_ref / (npart * (npart - 1) / 2);
endfunction

