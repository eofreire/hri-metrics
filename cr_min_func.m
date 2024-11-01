function cr_min_ref = cr_min_func(referent, npart)
  % Identify unique gestures performed by the referent
  gestures_ref = unique(referent(:, 2));

  % Determine the number of different gestures
  [dif_gestures, ~] = size(gestures_ref);

  % Initialize the minimum consensus value (delta_ref)
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

      % Initialize the delta value for this pair of participants
      delta = 0;

      % Check if there is any gesture performed by participant i that is also performed by participant j
      for m = 1:num_gestures_i
        aux = find(gestures_j == gestures_i(m));
        if (~isempty(aux))
          delta = 1; % Set delta to 1 if there is at least one common gesture
          break; % Exit the loop as we found a common gesture
        endif
      endfor

      % Accumulate the minimum consensus value
      delta_ref = delta_ref + delta;
    endfor
  endfor

  % Normalize the consensus value across all participant pairs
  cr_min_ref = delta_ref / (npart * (npart - 1) / 2);
endfunction

