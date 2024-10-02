function cr_jac_ref = cr_jac_func(referent, nvol)
  % Identify unique gestures performed by the referent
  gestures_ref = unique(referent(:, 2));

  % Determine the number of different gestures
  [dif_gestures, ~] = size(gestures_ref);

  % Initialize the Jaccard consensus value (delta_ref)
  delta_ref = 0;

  % Loop through each pair of volunteers
  for i = 1:nvol
    for j = i+1:nvol % number of volunteers
      % Find the unique gestures performed by volunteer i
      gestures_i = unique(referent(referent(:, 1) == i, 2));

      % Find the unique gestures performed by volunteer j
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

  % Normalize the Jaccard consensus value across all volunteer pairs
  cr_jac_ref = delta_ref / (nvol * (nvol - 1) / 2);
endfunction

