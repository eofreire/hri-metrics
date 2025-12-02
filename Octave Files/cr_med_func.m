function cr_med_ref = cr_med_func(referent, npart)
  % Identify unique gestures performed by the referent
  gestures_ref = unique(referent(:, 2));

  % Determine the number of different gestures
  [dif_gestures, ~] = size(gestures_ref);

  % Initialize the average consensus value (delta_ref)
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

      % Initialize the count of common gestures
      aux_ref = 0;

      % Check for common gestures between participants i and j
      for m = 1:num_gestures_i
        aux = find(gestures_j == gestures_i(m));
        if (~isempty(aux))
          aux_ref = aux_ref + 1; % Increment count for each common gesture
        endif
      endfor

      % Calculate the delta as the ratio of common gestures to the maximum gestures performed by either participant
      delta = aux_ref / max(num_gestures_i, num_gestures_j);

      % Accumulate the average consensus value
      delta_ref = delta_ref + delta;
    endfor
  endfor

  % Normalize the consensus value across all participant pairs
  cr_med_ref = delta_ref / (npart * (npart - 1) / 2);
endfunction

