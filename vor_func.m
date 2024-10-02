function vor_ref = vor_func(referent, nvol)
  % Unique gestures for the referent
  gestures_ref = unique(referent(:,2));

  % Number of unique gestures
  [dif_gestures,~] = size(gestures_ref);

  % Initialize the Volunteer Occurrence Rate (VOR) array
  vor_ref = zeros(dif_gestures, 1);

  % Loop over each unique gesture
  for i = 1:dif_gestures
    % Loop over each volunteer
    for j = 1:nvol
      % Get gestures performed by the current volunteer
      gestures = referent(referent(:,1) == j, 2);

      % Get the number of gestures performed by the current volunteer
      [num_gestures, ~] = size(gestures);

      % Find if the current gesture is present for this volunteer
      aux = find(gestures == gestures_ref(i));

      % If the gesture is found, update the VOR
      if (~isempty(aux))
        aux1 = 1 / nvol;
        vor_ref(i) = vor_ref(i) + aux1;
      endif
    endfor
  endfor
endfunction

