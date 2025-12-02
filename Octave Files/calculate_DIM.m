function [DIM, DIM_R, DIM_ref, winning_gestures_DIM] = calculate_DIM(ILN1_ref, gestures_ref_col, nref)
  % Calculate Distinctive Intuitiveness Metric (DIM) for all referents
  %
  % Inputs:
  %   ILN1_ref: Cell array of size nref, where each cell contains a matrix of gesture IDs and ILN1 values.
  %   gestures_ref_col: Cell array of size nref, where each cell contains gesture IDs for the referent.
  %   nref: Number of referents.
  %
  % Outputs:
  %   DIM: Global array of all DIM values across all referents.
  %   DIM_R: Maximum DIM value for each referent.
  %   DIM_ref: Cell array containing DIM values for each gesture in each referent, along with gesture IDs.
  %   winning_gestures_DIM: Cell array containing the gesture(s) with the highest DIM value for each referent.

  % Initialize outputs
  DIM = [];
  DIM_R = [];
  DIM_ref = cell(1, nref);
  winning_gestures_DIM = cell(1, nref);

  % Loop over each referent
  for k = 1:nref
    % Initialize DIM for gestures in referent k
    DIM_ref{k} = zeros(size(ILN1_ref{k}, 1), 1);

    % Calculate DIM for each gesture in referent k
    for j = 1:size(ILN1_ref{k}, 1)
      current_gesture = ILN1_ref{k}(j, 1); % Gesture ID
      max_ILN1_other_referents = -inf; % To track the maximum ILN1 for other referents

      % Find the maximum ILN1 for the current gesture in other referents
      for other_r = 1:nref
        if other_r ~= k
          other_gesture_rows = find(ILN1_ref{other_r}(:, 1) == current_gesture);
          if ~isempty(other_gesture_rows)
            max_ILN1_other_referents = max(max_ILN1_other_referents, ILN1_ref{other_r}(other_gesture_rows, 2));
          end
        end
      end

      % If no value was found for other referents, set max_ILN1_other_referents to 0
      if max_ILN1_other_referents == -inf
        max_ILN1_other_referents = 0;
      end

      % Calculate DIM for the current gesture
      DIM_ref{k}(j) = ILN1_ref{k}(j, 2) - max_ILN1_other_referents;
    end

    % Append to global DIM array
    DIM = [DIM; DIM_ref{k}];

    % Calculate the maximum DIM for the referent
    DIM_R_ref = max(DIM_ref{k});
    DIM_R = [DIM_R; DIM_R_ref];

    % Include gesture IDs in the result
    DIM_ref{k} = [gestures_ref_col{k}, DIM_ref{k}];

    % Find the gesture with the highest DIM value
    max_DIM = max(DIM_ref{k}(:, 2));
    max_DIM_gesture_rows = find(DIM_ref{k}(:, 2) == max_DIM);
    winning_gestures_DIM{k} = DIM_ref{k}(max_DIM_gesture_rows, 1);
  end
end
