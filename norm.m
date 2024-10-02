function norm_vec = norm(vec)
  % This function normalizes a vector or matrix 'vec' to the range [0, 1].

  % Find the maximum value in the vector or matrix
  max_vec = max(vec(:));

  % Find the minimum value in the vector or matrix
  min_vec = min(vec(:));

  % Normalize the vector or matrix using min-max normalization formula:
  % (value - min) / (max - min)
  norm_vec = (vec - min_vec) / (max_vec - min_vec);

endfunction

