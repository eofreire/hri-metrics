function vor_ref = vor_func(referent, npart)
  % Unique gestures for the referent
  gestures_ref = unique(referent(:,2));

  % Number of unique gestures
  [dif_gestures,~] = size(gestures_ref);

  % Initialize the participant Occurrence Rate (VOR) array
  vor_ref = zeros(dif_gestures, 1);

  % Loop over each unique gesture
  for i = 1:dif_gestures
    % Loop over each participant
    for j = 1:npart
      % Get gestures performed by the current participant
      gestures = referent(referent(:,1) == j, 2);

      % Get the number of gestures performed by the current participant
      [num_gestures, ~] = size(gestures);

      % Find if the current gesture is present for this participant
      aux = find(gestures == gestures_ref(i));

      % If the gesture is found, update the VOR
      if (~isempty(aux))
        aux1 = 1 / npart;
        vor_ref(i) = vor_ref(i) + aux1;
      endif
    endfor
  endfor
endfunction

