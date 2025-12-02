function [consensus_ref,x0] = consensus_func(referent, npart)
  resolution = 0.005;
  font_size = 12;
	min_tau = 0.0;
  max_tau = 2;

  k = 1;

  % Loop over different tolerance levels (tau)
  for tau = min_tau:resolution:max_tau
    consensus_value = 0;

    % Loop through each pair of participants
    for i = 1:npart
      for j = i+1:npart
        % Get gestures performed by participant i
        gestures_i = referent(referent(:, 1) == i, 2);
        % Get gestures performed by participant j
        gestures_j = referent(referent(:, 1) == j, 2);
        % Get the number of gestures per participant
        [num_gestures_i, ~] = size(gestures_i);
        [num_gestures_j, ~] = size(gestures_j);

        % Initialize variables
        disagreement_count = 0;

        % Check for common gestures between participants i and j
        for m = 1:num_gestures_i
          for n = 1:num_gestures_j
            if gestures_i(m) != gestures_j(n)
              disagreement_count = disagreement_count + 1;
            endif
          endfor
        endfor

        % Compute the disagreement ratio
        disagreement_ratio = disagreement_count / (num_gestures_i * num_gestures_j);

        % If the disagreement is below the threshold (tau), set delta to 1
        delta = (disagreement_ratio <= tau);

        % Accumulate the consensus value
        consensus_value = consensus_value + delta;
      endfor
    endfor

    % Normalize the consensus value across all participant pairs
    consensus(k) = consensus_value / (npart * (npart - 1) / 2);
    k = k + 1;
  endfor

  % Define the range of tau values
  tau_values = min_tau:resolution:max_tau;

  % Define the logistic function model
  logistic_model = @(p, x) 1./ (1 + exp(-p(1) * (x - p(2))));

  % Initial estimates for parameters [r, x0]
	initial_params = [1, 0.5];

	% Fit the logistic model
  optimized_params = lsqcurvefit(logistic_model, initial_params, tau_values, consensus);

  % Extract fitted parameters
  r_est = optimized_params(1);   % Growth rate
  x0_est = optimized_params(2);  % Inflection point (midpoint)

  % Compute fitted values and R-squared
  consensus_fit = logistic_model(optimized_params, tau_values);
  R2 = 1 - sum((consensus - consensus_fit).^2) / sum((consensus - mean(consensus)).^2);

  % Plot the original data and logistic fit
##  figure;
##  plot(tau_values, consensus, 'bo', 'DisplayName', 'Data');
##  hold on;
##  plot(tau_values, consensus_fit, 'r-', 'LineWidth', 2, 'DisplayName', 'Logistic Fit');
##  xlabel('Tau', 'fontsize', font_size);
##  ylabel('Consensus', 'fontsize', font_size);
##  title(sprintf('Logistic Fit (r=%.3f, x_0=%.3f, R²=%.3f)', r_est, x0_est, R2), 'fontsize', font_size);
##  legend;
##  grid on;
##  hold off;

  % Return estimated growth rate, midpoint, and fit quality
  consensus_ref = r_est;
	x0 = x0_est;
endfunction
