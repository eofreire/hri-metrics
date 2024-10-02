function guess = guess_func(gestures, nvol, nref, chosen)
  % Find unique gestures in the dataset
  gestures_uni = unique(gestures);

  % Determine the number of unique gestures
  [num_gestures_uni, ~] = size(gestures_uni);

  % Initialize the gesture count
  cont_gestures = 0;

  % Loop over each referent
  for i = 1:nref
    aux_ok = [];

    % Loop over each volunteer
    for j = 1:nvol
      % Get the gestures performed by the current volunteer for the current referent
      gestures_vol = gestures(((gestures(:,1) == i) & (gestures(:,2) == j)), 3);

      % Check if the volunteer performed the chosen gesture for this referent
      aux = find(gestures_vol == chosen(i));

      % Special case for referent 5, where gesture 64 is checked as valid
      if i == 5
        aux_ok = find(gestures_vol == 64);
      endif

      % If the gesture was performed (or gesture 64 for referent 5), increase the count
      if (~isempty(aux)) || (~isempty(aux_ok))
        cont_gestures = cont_gestures + 1;
      endif
    endfor
  endfor

  % Calculate the guessability score as the ratio of correct gestures to total unique gestures
  guess = cont_gestures / num_gestures_uni;
endfunction

