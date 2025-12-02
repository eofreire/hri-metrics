function [contingency_table, win_gestures] = contingency_func(gestures, gestures_ref)
  % Identify unique gestures and referents
  gestures_uni = unique(gestures(:, 3));  % List of unique gestures
  refs = unique(gestures(:, 1));  % List of unique referents

  % Determine the number of unique gestures and referents
  dif_gestures = numel(gestures_uni);
  dif_refs = numel(refs);

  % Initialize the contingency matrix
  contingency = zeros(dif_gestures, dif_refs);

  % Fill the contingency matrix
  for i = 1:dif_gestures
    for j = 1:dif_refs
      % Count occurrences of each gesture for each referent
      contingency(i, j) = sum(gestures_ref{j}(:, 2) == gestures_uni(i));
    endfor
  endfor

  % Prepare the contingency table
  contingency_table = [gestures_uni, contingency];

  % Get the maximum occurrences per referent
  max_votes = max(contingency, [], 1);  % Maximum votes for each referent

  % Initialize the cell array for winning gestures
  win_gestures = cell(1, dif_refs);

  % Find the gestures that received the maximum number of votes for each referent
  for j = 1:dif_refs
    % Find gestures with the maximum number of votes for referent j
    max_gestures_indices = find(contingency(:, j) == max_votes(j));

    % Get the corresponding gesture IDs
    win_gestures{j} = gestures_uni(max_gestures_indices)';
  endfor

  % The output `win_gestures` now contains a cell array where each element
  % is a list of gestures that tied for the maximum for each referent.
endfunction

