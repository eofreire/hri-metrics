function cdr_ref = cdr_func(referent, npart, threshold)
  % Identify unique gestures performed by the referent
  gestures_ref = unique(referent(:, 2));

  % Determine the number of different gestures
  [dif_gestures, ~] = size(gestures_ref);

  % Initialize an array to count occurrences
  aux_ref = zeros(dif_gestures, 1);

  % Loop through each gesture
  for i = 1:dif_gestures
    % Loop through each participant
    for j = 1:npart % number of participants
      % Get gestures performed by the current participant
      gestures = referent(referent(:, 1) == j, 2);

      % Count the number of gestures
      [num_gestures, ~] = size(gestures);

      % Check if the current gesture is performed by the participant
      aux = find(gestures == gestures_ref(i));
      if (~isempty(aux))
        aux_ref(i) = aux_ref(i) + 1; % Increment the count for this gesture
      endif
    endfor
  endfor

  % Find gestures that meet or exceed the threshold
  aux = find(aux_ref >= threshold);

  % Count the number of gestures that meet the threshold
  [num, ~] = size(aux);

  % Calculate the Consensus-Distinct Ratio (CDR)
  cdr_ref = num / dif_gestures;
endfunction

