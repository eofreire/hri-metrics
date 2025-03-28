function folder = select_or_create_folder()
  % Folder selection and creation function
  % Returns the selected/created folder path or an empty string if cancelled.

  while true
    % Ask the user to input a folder path or select an existing one
    choice = questdlg('Do you want to select an existing folder or create a new one?', ...
                      'Folder Selection', 'Select Existing', 'Create New', 'Cancel', 'Select Existing');

    switch choice
      case 'Select Existing'
        % Let the user browse for an existing folder
        folder = uigetdir(pwd, 'Select Existing Folder');
        if folder == 0
          disp('Operation cancelled.');
          folder = ''; % Return empty string if cancelled
          return;
        else
          msgbox(sprintf('Using existing folder: %s', folder));
          break; % Proceed with the selected folder
        end

      case 'Create New'
        % Prompt the user to enter a new folder name
        new_folder = inputdlg('Enter the name of the new folder:', 'Create New Folder', [1 50]);
        if isempty(new_folder)
          disp('Operation cancelled.');
          folder = ''; % Return empty string if cancelled
          return;
        else
          folder = fullfile(pwd, new_folder{1}); % Create new folder in the current directory
          if isfolder(folder)
            msg = sprintf('Folder "%s" already exists. Do you want to use it?', folder);
            use_existing = questdlg(msg, 'Folder Exists', 'Yes', 'No', 'Yes');
            if strcmp(use_existing, 'Yes')
              msgbox(sprintf('Using existing folder: %s', folder));
              break; % Proceed with the existing folder
            else
              continue; % Loop to ask for a new folder name
            end
          else
            % Create the new folder
            [status, msg] = mkdir(folder);
            if status
              msgbox(sprintf('Folder "%s" created successfully.', folder));
              break; % Exit the loop
            else
              errordlg(sprintf('Failed to create folder: %s', msg));
              % Loop continues to prompt for a valid folder
            end
          end
        end

      case 'Cancel'
        disp('Operation cancelled.');
        folder = ''; % Return empty string if cancelled
        return;
    end
  end
end
