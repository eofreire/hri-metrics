function gor_ref = gor_func(referent, nvol)
  % Get the total number of gestures for the referent
  [num_gestures_total, ~] = size(referent);

  % Find unique gestures performed by the referent
  gestures_ref = unique(referent(:, 2));

  % Determine the number of different gestures
  [dif_gestures, ~] = size(gestures_ref);

  % Initialize the General Occurrence Rate (GOR) vector
  gor_ref = zeros(dif_gestures, 1);

  % Loop over each unique gesture
  for i = 1:dif_gestures
    % Find occurrences of the current gesture in the dataset
    aux = find(referent(:, 2) == gestures_ref(i));

    % Get the number of occurrences of this gesture
    [num_gestures, ~] = size(aux);

    % If the gesture was performed, calculate its occurrence rate
    if (~isempty(aux))
      gor_ref(i) = num_gestures / num_gestures_total;
    endif
  endfor
endfunction

