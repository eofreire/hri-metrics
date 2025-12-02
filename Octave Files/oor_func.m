function oor_ref = oor_func(referent, npart)
  % This function calculates a metric (oor_ref) for each unique gesture
  % based on the number of participants who proposed each gesture.

  % Find the unique gestures proposed by any participant
  unique_gestures = unique(referent(:,2));

  % Get the number of unique gestures
  [num_gestures, ~] = size(unique_gestures);

  % Initialize the oor_ref vector with zeros, one entry for each unique gesture
  oor_ref = zeros(num_gestures, 1);

  % Loop over each unique gesture
  for i = 1:num_gestures
    % Loop over each participant
    for j = 1:npart  % number of participants
      % Get the gestures proposed by the current participant (participant ID = j)
      gestures = referent(referent(:,1) == j, 2);

      % Get the number of gestures proposed by this participant
      [num_gestures_per_part, ~] = size(gestures);

      % Check if the current unique gesture is in the list of gestures proposed by this participant
      aux = find(gestures == unique_gestures(i));

      % If the current unique gesture was proposed by this participant
      if (~isempty(aux))
        % Get the position of the gesture in the participant's list
        pos = aux(1);

        % Calculate a contribution to the oor_ref value based on the gesture's position
        % The closer the gesture is to the start of the list, the higher the contribution
        aux2 = (num_gestures_per_part - pos + 1) / (npart * num_gestures_per_part);

        % Add this contribution to the total oor_ref value for the current unique gesture
        oor_ref(i) = oor_ref(i) + aux2;
      endif
    endfor
  endfor
endfunction

