function cr_over_ref = cr_over_func(referent, nvol)
  % Identify unique gestures performed by the referent
  gestures_ref = unique(referent(:, 2));

  % Determine the number of different gestures
  [dif_gestures, ~] = size(gestures_ref);

  % Initialize the overlap consensus value (delta_ref)
  delta_ref = 0;

  % Loop through each pair of volunteers
  for i = 1:nvol
    for j = i+1:nvol
      % Find the unique gestures performed by volunteer i
      gestures_i = unique(referent(referent(:, 1) == i, 2));

      % Find the unique gestures performed by volunteer j
      gestures_j = unique(referent(referent(:, 1) == j, 2));

      % Get the number of gestures performed by volunteers i and j
      [num_gestures_i, ~] = size(gestures_i);
      [num_gestures_j, ~] = size(gestures_j);

      % Find the number of common gestures between volunteers i and j
      [num_inter, ~] = size(intersect(gestures_i, gestures_j));

      % Calculate the Overlap coefficient (delta) for this pair of volunteers
      delta = num_inter / min(num_gestures_i, num_gestures_j);

      % Accumulate the overlap consensus value
      delta_ref = delta_ref + delta;
    endfor
  endfor

  % Normalize the consensus value across all volunteer pairs
  cr_over_ref = delta_ref / (nvol * (nvol - 1) / 2);
endfunction

