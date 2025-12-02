function exibe_tabela(matrix, nome, VarNames, low_thresh, mid_thresh, hig_thresh)

##% Prompt user for threshold values
##disp('Please enter three threshold values for the colormap.');
##low_thresh = input('Low threshold: ');
##mid_thresh = input('Mid threshold: ');
##hig_thresh = input('High threshold: ');

  if low_thresh >= mid_thresh || mid_thresh >= hig_thresh
    error('Thresholds must satisfy: Low threshold < Mid threshold < High threshold.');
  end

  % Clear lower triangular part of the matrix
  [nrows, ncols] = size(matrix);
  for nr = 1:nrows
    for nc = 1:ncols
      if nr >= nc; matrix(nr, nc) = 0; end
    end
  end

  % Create figure
  figure('NumberTitle', 'off', 'Name', nome);
  im = imagesc(matrix); hold on;

colormap([1 1 1; 1 1 1]); % Set colormap to black and white
colorbar off; % Remove the colorbar if not needed

##[nrows, ncols] = size(matrix);
##for i = 0.5:1:nrows+0.5
##    % Horizontal lines
##    plot([0.5, ncols+0.5], [i, i], 'k-', 'LineWidth', 1); % Black gridlines
##end
##for j = 0.5:1:ncols+0.5
##    % Vertical lines
##    plot([j, j], [0.5, nrows+0.5], 'k-', 'LineWidth', 1); % Black gridlines
##end
##hold off;
##
##% Adjust axes
##axis equal;
##xlim([0.5, ncols+0.5]); % Set limits to remove padding
##ylim([0.5, nrows+0.5]); % Set limits to remove padding
##xticks(1:ncols);
##yticks(1:nrows);

  % Define colormap based on thresholds
  my_colormap = [
  1 0 0;    % -1 em vermelho
  1 0.5 0;  % -0.75 em laranja
  1 1 0;    % -0.5 em amarelo
  0.9 0.9 0.9; % -0.25 em cinza claro
  1 1 1;    % 0 em branco
  0.9 0.9 0.9; % 0.25 em cinza claro
  1 1 0;    % 0.5 em amarelo
  1 0.5 0;  % 0.75 em laranja
  1 0 0     % +1 em vermelho
  ];
  colormap(my_colormap);

  % Adjust color axis
%  caxis([low_thresh, hig_thresh]); % Adjust to focus on the defined range
  caxis([-1 1]);
  colorbar;

  % Set x and y labels
  xticks(1:length(VarNames)); xticklabels(VarNames); xtickangle(90);
  yticks(1:length(VarNames)); yticklabels(VarNames);
  set(gca, 'XAxisLocation', 'top');

  % Add values to each cell
  for nr = 1:nrows
    for nc = 1:ncols
      if matrix(nr, nc) ~= 0
        str_val = num2str(round(matrix(nr, nc) * 1000) / 1000);
        text(nc, nr, str_val, 'HorizontalAlignment', 'center', 'Color', 'black', 'FontSize', 9);
      end
    end
  end
end

