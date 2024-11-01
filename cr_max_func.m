function cr_max_ref = cr_max_func(referent, npart)
  % Identify unique gestures performed by the referent
  gestures_ref = unique(referent(:, 2));

  % Determine the number of different gestures
  [dif_gestures, ~] = size(gestures_ref);

  % Initialize the maximum consensus value (delta_ref)
  delta_ref = 0;

  % Loop through each pair of participants
  for i = 1:npart
    for j = i+1:npart % number of participants
      % Find the unique gestures performed by participant i
      gestures_i = unique(referent(referent(:, 1) == i, 2));

      % Find the unique gestures performed by participant j
      gestures_j = unique(referent(referent(:, 1) == j, 2));

      % Get the number of gestures performed by participants i and j
      [num_gestures_i, ~] = size(gestures_i);
      [num_gestures_j, ~] = size(gestures_j);

      % Check if both participants performed the same number of gestures
      if num_gestures_i == num_gestures_j
        % Check if the gestures performed are identical
        if all(gestures_i == gestures_j)
          delta_ref = delta_ref + 1; % Increment count for identical gesture sets
        endif
      endif
    endfor
  endfor

  % Normalize the maximum consensus value across all participant pairs
  cr_max_ref = delta_ref / (npart * (npart - 1) / 2);
endfunction

