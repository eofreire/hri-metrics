function cr_ref_med = cr_func_med(referent, npart)
  % Identify unique gestures performed by the referent
  gestures_ref = unique(referent(:, 2));

  % Determine the number of different gestures
  [dif_gestures, ~] = size(gestures_ref);

  % Initialize the median consensus value (delta_ref)
  delta_ref = 0;

  % Loop through each pair of participants
  for i = 1:npart
    for j = i+1:npart % number of participants
      % Find the unique gestures performed by participant i
      gestures_i = unique(referent(referent(:, 1) == i, 2));

      % Find the unique gestures performed by participant j
      gestures_j = unique(referent(referent(:, 1) == j, 2));

      % Determine the number of unique gestures for each participant
      [num_gestures_i, ~] = size(gestures_i);
      [num_gestures_j, ~] = size(gestures_j);

      % Initialize count for overlapping gestures
      aux_ref = 0;

      % Check for overlapping gestures
      for m = 1:num_gestures_i
        aux = find(gestures_j == gestures_i(m));
        if (~isempty(aux))
          aux_ref = aux_ref + 1; % Increment the count for overlapping gestures
        endif
      endfor

      % Calculate the delta as the ratio of overlapping gestures
      delta = aux_ref / max(num_gestures_i, num_gestures_j);

      % Accumulate the median consensus values
      delta_ref = delta_ref + delta;
    endfor
  endfor

  % Normalize the median consensus value across all participant pairs
  cr_ref_med = delta_ref / (npart * (npart - 1));
endfunction

