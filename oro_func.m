function oro_ref = oro_func(referent, nvol)
  % This function calculates a metric (oro_ref) for each unique gesture
  % based on the number of volunteers who proposed each gesture.

  % Find the unique gestures proposed by any volunteer
  unique_gestures = unique(referent(:,2));

  % Get the number of unique gestures
  [num_gestures, ~] = size(unique_gestures);

  % Initialize the oro_ref vector with zeros, one entry for each unique gesture
  oro_ref = zeros(num_gestures, 1);

  % Loop over each unique gesture
  for i = 1:num_gestures
    % Loop over each volunteer
    for j = 1:nvol  % number of volunteers
      % Get the gestures proposed by the current volunteer (volunteer ID = j)
      gestures = referent(referent(:,1) == j, 2);

      % Get the number of gestures proposed by this volunteer
      [num_gestures_per_vol, ~] = size(gestures);

      % Check if the current unique gesture is in the list of gestures proposed by this volunteer
      aux = find(gestures == unique_gestures(i));

      % If the current unique gesture was proposed by this volunteer
      if (~isempty(aux))
        % Get the position of the gesture in the volunteer's list
        pos = aux(1);

        % Calculate a contribution to the oro_ref value based on the gesture's position
        % The closer the gesture is to the start of the list, the higher the contribution
        aux2 = (num_gestures_per_vol - pos + 1) / (nvol * num_gestures_per_vol);

        % Add this contribution to the total oro_ref value for the current unique gesture
        oro_ref(i) = oro_ref(i) + aux2;
      endif
    endfor
  endfor
endfunction

