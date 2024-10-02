function [contingency_table, win_gestures] = contingency_func(gestures, gestures_ref)
  % Identify unique gestures and referents
  gestures_uni = unique(gestures(:, 3));
  refs = unique(gestures(:, 1));

  % Determine the number of unique gestures and referents
  [dif_gestures, ~] = size(gestures_uni);
  [dif_refs, ~] = size(refs);

  % Initialize the contingency matrix
  contingency = zeros(dif_gestures, dif_refs);

  % Fill the contingency matrix
  for i = 1:dif_gestures
    for j = 1:dif_refs
      % Count occurrences of each gesture in each referent
      [aux,~] = size(find(gestures_ref{j}(:,2)==gestures_uni(i)));
      contingency(i, j) = aux;
    endfor
  endfor

  % Prepare the contingency table
  nrefs = 0:dif_refs;
  contingency_table = [gestures_uni, contingency];
  contingency_table = [nrefs; contingency_table];

  % Find the gesture with the maximum occurrences
  ind = find(contingency == max(contingency));
  dims = size(contingency);
  [r, c] = ind2sub(dims, ind');
  [x, y, z] = unique(c);
  aux2 = r(y);

  % Get the winning gestures
  win_gestures = (gestures_uni(aux2(1, :)))';
endfunction


