function display_table(matrix, name, VarNames, low_thresh, mid_thresh, hig_thresh)
% DISPLAY_TABLE - Display a symmetric matrix as a colored table with values
%
% Usage:
%   display_table(matrix, title_name, VarNames, low_thresh, mid_thresh, hig_thresh)
%
% Inputs:
%   matrix      - square numeric matrix
%   name        - title/name for the figure
%   VarNames    - cell array of variable names (for x/y tick labels)
%   low_thresh  - low threshold for colormap (not currently used for caxis)
%   mid_thresh  - mid threshold for colormap
%   hig_thresh  - high threshold for colormap
%
% This replaces the previous Portuguese-named function exibe_tabela.m.
  if low_thresh >= mid_thresh || mid_thresh >= hig_thresh
    error('Thresholds must satisfy: Low threshold < Mid threshold < High threshold.');
  end

  % Clear lower triangular part of the matrix so only upper triangle is shown
  [nrows, ncols] = size(matrix);
  for nr = 1:nrows
    for nc = 1:ncols
      if nr >= nc; matrix(nr, nc) = 0; end
    end
  end

  % Create figure
  figure('NumberTitle', 'off', 'Name', name);
  imagesc(matrix); hold on;

  % Define colormap
  my_colormap = [
    1 0 0;      % -1 red
    1 0.5 0;    % -0.75 orange
    1 1 0;      % -0.5 yellow
    0.9 0.9 0.9;% -0.25 light gray
    1 1 1;      % 0 white
    0.9 0.9 0.9;% 0.25 light gray
    1 1 0;      % 0.5 yellow
    1 0.5 0;    % 0.75 orange
    1 0 0       % +1 red
  ];
  colormap(my_colormap);

  % Fix color axis to [-1, 1]; change if needed
  caxis([-1 1]);
  colorbar;

  % Set x and y labels
  if nargin >= 3 && ~isempty(VarNames)
    xticks(1:length(VarNames)); xticklabels(VarNames); xtickangle(90);
    yticks(1:length(VarNames)); yticklabels(VarNames);
  end
  set(gca, 'XAxisLocation', 'top');

  % Add numeric values to each visible cell (upper triangle)
  text_color = [0 0 0]; % black
  for r = 1:nrows
    for c = 1:ncols
      if r < c
        val = matrix(r, c);
        text(c, r, num2str(val, '%.2f'), 'HorizontalAlignment', 'center', 'Color', text_color);
      end
    end
  end

  hold off;
end