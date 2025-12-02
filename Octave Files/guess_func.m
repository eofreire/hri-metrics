function guess = guess_func(gestures, npart, nref)
  % Prompt the user to input values for 'chosen' via a dialog box for each referent
  chosen = cell(1, nref); % Initialize 'chosen' as a cell array to hold sets of gestures

  % Loop to gather chosen gestures for each referent
  for i = 1:nref
    prompt = sprintf('Enter the chosen gestures for referent %d, separated by commas:', i);
    user_input = inputdlg(prompt, 'Enter the Selected Gestures for Guessability Calculation', [1 50]);

    % Check if the user provided input; otherwise, display an error
    if isempty(user_input)
      error('Error: No value was provided for referent %d.', i);
    endif

    % Convert user input into a numeric vector and assign to chosen
    chosen{i} = str2num(user_input{1});  % Convert input string to numeric array

    % Check if chosen is valid (non-empty and numeric)
    if isempty(chosen{i})
      error('Error: Invalid input for referent %d.', i);
    endif
  endfor

  % Identify unique gestures in the dataset
  unique_gestures = unique(gestures(:,3));

  % Determine the number of unique gestures
  num_unique_gestures = numel(unique_gestures);

  % Initialize the count for correctly performed gestures
  count_gestures = 0;

  % Loop over each referent
  for i = 1:nref
    % Get the chosen gestures for this referent
    chosen_gestures = chosen{i};

    % Loop over each participant
    for j = 1:npart
      % Get the gestures performed by the current participant for the current referent
      gestures_part = gestures(((gestures(:,1) == i) & (gestures(:,2) == j)), 3);

      % Check if any of the gestures in `chosen_gestures` were performed by the participant
      gesture_found = any(ismember(gestures_part, chosen_gestures));

      % If any of the chosen gestures was performed, increase the count
      if gesture_found
        count_gestures = count_gestures + 1;
      endif
    endfor
  endfor

  % Calculate the guessability score as the ratio of correct gestures to total unique gestures
  guess = count_gestures / num_unique_gestures;
endfunction

