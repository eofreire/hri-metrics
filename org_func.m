function gestures_col = org_func(referent)
  % Get the unique gestures for the referent
  gestures_ref = unique(referent(:,2));

  % Determine the number of unique gestures
  [dif_gestures, ~] = size(gestures_ref);

  % Initialize the gesture collection array
  gestures_col = [];

  % Loop through each unique gesture and add it to the collection
  for i = 1:dif_gestures
    gestures_col = [gestures_col; gestures_ref(i)];
  endfor
endfunction

