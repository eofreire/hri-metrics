clc
clear all
close all

% Read gesture data filename
[filename,path]=uigetfile("*.csv",'Select Gestures File (Referent Column; Participant Column; Gesture ID Column)');
gestures = dlmread(strcat(path,filename),';'); % Referent, Participant, Gesture
% Determine the number of Participants and referents
[nref, ~] = size(unique(gestures(:, 1)));
[npart, ~] = size(unique(gestures(:, 2)));
[ngest, ~] = size(unique(gestures(:, 3)));

[rows, cols] = size(gestures);
gestures(1,1) = 1;

% Organize gestures by referent
for k = 1:nref
  gestures_ref{k} = gestures(gestures(:,1)==k,2:3);
  aux1 = 0;
  aux2 = 0;
  for i = 1:npart
    num_gestures_ref_part(i) = size(gestures_ref{k}(gestures_ref{k}(:,1)==i,2),1);
    num_dist_gestures_ref_part(i) = size(unique(gestures_ref{k}(gestures_ref{k}(:,1)==i,2)),1);
  endfor
  mean_num_gestures_ref_part(k) = mean(num_gestures_ref_part);
  mean_num_dist_gestures_ref_part(k) = mean(num_dist_gestures_ref_part);
  median_num_gestures_ref_part(k) = median(num_gestures_ref_part);
  median_num_dist_gestures_ref_part(k) = median(num_dist_gestures_ref_part);
  min_num_gestures_ref_part(k) = min(num_gestures_ref_part);
  min_num_dist_gestures_ref_part(k) = min(num_dist_gestures_ref_part);
  max_num_gestures_ref_part(k) = max(num_gestures_ref_part);
  max_num_dist_gestures_ref_part(k) = max(num_dist_gestures_ref_part);
  num_gestures_ref(k) = size(unique(gestures_ref{k}(:,2)),1);
endfor
mean_num_gestures_part = mean(mean_num_gestures_ref_part);
mean_num_dist_gestures_part = mean(mean_num_dist_gestures_ref_part);
median_num_gestures_part = median(median_num_gestures_ref_part);
median_num_dist_gestures_part = median(median_num_dist_gestures_ref_part);
min_num_gestures_part = min(min_num_gestures_ref_part);
min_num_dist_gestures_part = min(min_num_dist_gestures_ref_part);
max_num_gestures_part = max(max_num_gestures_ref_part);
max_num_dist_gestures_part = max(max_num_dist_gestures_ref_part);


% Organize gestures by Participants
for k = 1:npart
  gestures_part{k} = gestures(gestures(:,2)==k,[1 3]);
endfor

gestures_col = [];
referent_col = [];
for k = 1:nref
  gestures_ref_col{k} = org_func(gestures_ref{k});
  gestures_col = [gestures_col; gestures_ref_col{k}];
  [aux,~] = size(gestures_ref_col{k});
  aux_vec_ref = zeros(aux,1)+k;
  referent_col = [referent_col; aux_vec_ref];
endfor

% General Occurrence Rate (GOR)
gor = [];
winning_gestures_gor = [];
for k = 1:nref
  gor_ref{k} = gor_func(gestures_ref{k},npart);
  gor = [gor; gor_ref{k}];
  gor_ref{k} = [gestures_ref_col{k} gor_ref{k}];
  max_gor = max(gor_ref{k}(:,2));
  max_gor_gesture_rows = find(gor_ref{k}(:,2) == max_gor);
  winning_gestures_gor{k} = gor_ref{k}(max_gor_gesture_rows, 1);
endfor

% OOR (Occurrence Rate Overall)
oor = [];
winning_gestures_oor = [];
for k = 1:nref
  oor_ref{k} = oor_func(gestures_ref{k},npart);
  oor = [oor; oor_ref{k}];
  oor_ref{k} = [gestures_ref_col{k} oor_ref{k}];
  max_oor = max(oor_ref{k}(:,2));
  max_oor_gesture_rows = find(oor_ref{k}(:,2) == max_oor);
  winning_gestures_oor{k} = oor_ref{k}(max_oor_gesture_rows, 1);
endfor

% Participant Occurrence Rate (VOR)
vor = [];
winning_gestures_vor = [];
for k = 1:nref
  vor_ref{k} = vor_func(gestures_ref{k},npart);
  vor = [vor; vor_ref{k}];
  vor_ref{k} = [gestures_ref_col{k} vor_ref{k}];
  max_vor = max(vor_ref{k}(:,2));
  max_vor_gesture_rows = find(vor_ref{k}(:,2) == max_vor);
  winning_gestures_vor{k} = vor_ref{k}(max_vor_gesture_rows, 1);
endfor

% Max-Consensus = Confidence Value (Cr) = max(vor) by referent
max_con = [];
for k = 1:nref
  max_con_ref{k} = max(vor_ref{k}(:,2));
  max_con = [max_con; max_con_ref{k}];
endfor

% Popularity Calculation
popularity = vor.*(gor+1)./2;

pop_R = [];
winning_gestures_popularity = [];
for k = 1:nref
  pop_ref{k} = vor_ref{k}(:,2).*(gor_ref{k}(:,2)+1)/2;
  pop_R_ref = max(pop_ref{k});
  pop_R = [pop_R; pop_R_ref];
  pop_ref{k} = [gestures_ref_col{k} pop_ref{k}];
  max_pop = max(pop_ref{k}(:,2));
  max_pop_gesture_rows = find(pop_ref{k}(:,2) == max_pop);
  winning_gestures_popularity{k} = pop_ref{k}(max_pop_gesture_rows, 1);
endfor

% Intuitiveness Level (IL)
IL = (oor+vor+gor)/3;

% IL by referent
IL_R = [];
winning_gestures_IL = [];
for k = 1:nref
  IL_ref{k} = ((oor_ref{k}(:,2)+vor_ref{k}(:,2)+gor_ref{k}(:,2))/3);
  IL_R_ref = max(IL_ref{k});
  IL_R = [IL_R; IL_R_ref];
  IL_ref{k} = [gestures_ref_col{k} IL_ref{k}];
  max_IL = max(IL_ref{k}(:,2));
  max_IL_gesture_rows = find(IL_ref{k}(:,2) == max_IL);
  winning_gestures_IL{k} = IL_ref{k}(max_IL_gesture_rows, 1);
endfor

% Intuitiveness Level - Normalized (ILN)
ILN = ((oor/max(oor(:)))+(vor/max(vor(:)))+(gor/max(gor(:))))/3;

% ILN by referent
ILN_R = [];
winning_gestures_ILN = [];
for k = 1:nref
  ILN_ref{k} = (norm(oor_ref{k}(:,2))+norm(vor_ref{k}(:,2))+norm(gor_ref{k}(:,2)))/3;
  ILN_R_ref = max(ILN_ref{k});
  ILN_R = [ILN_R; ILN_R_ref];
  ILN_ref{k} = [gestures_ref_col{k} ILN_ref{k}];
  max_ILN = max(ILN_ref{k}(:,2));
  max_ILN_gesture_rows = find(ILN_ref{k}(:,2) == max_ILN);
  winning_gestures_ILN{k} = ILN_ref{k}(max_ILN_gesture_rows, 1);
endfor

% Intuitiveness Level - Normalized (ILN1)
ILN1 = (norm(oor)+norm(vor)+norm(gor))/3;

% ILN1 by referent
ILN1_R = [];
winning_gestures_ILN1 = [];
for k = 1:nref
  ILN1_ref{k} = ((oor_ref{k}(:,2)/max(oor_ref{k})(:,2))+(vor_ref{k}(:,2)/max(vor_ref{k}(:,2)))+(gor_ref{k}(:,2)/max(gor_ref{k})(:,2)))/3;
  ILN1_R_ref = max(ILN1_ref{k});
  ILN1_R = [ILN1_R; ILN1_R_ref];
  ILN1_ref{k} = [gestures_ref_col{k} ILN1_ref{k}];
  max_ILN1 = max(ILN1_ref{k}(:,2));
  max_ILN1_gesture_rows = find(ILN1_ref{k}(:,2) == max_ILN1);
  winning_gestures_ILN1{k} = ILN1_ref{k}(max_ILN1_gesture_rows, 1);
endfor

% Consensus-Distinct Ratio (CDR)
threshold = 2;
cdr = [];
for k = 1:nref
  cdr_ref{k} = cdr_func(gestures_ref{k},npart,threshold);
  cdr = [cdr; cdr_ref{k}];
endfor

% Consensus (Cr) --> delta = median (Vatavu 2019 - Dissimilarity Consensus)
cr_median = [];
for k = 1:nref
  cr_median_ref{k} = cr_med_func(gestures_ref{k},npart);
  cr_median = [cr_median; cr_median_ref{k}];
endfor

% Consensus (Cr) --> delta = min
cr_min = [];
for k = 1:nref
  cr_min_ref{k} = cr_min_func(gestures_ref{k},npart);
  cr_min = [cr_min; cr_min_ref{k}];
endfor

% Consensus (Cr) --> delta = max
cr_max = [];
for k = 1:nref
  cr_max_ref{k} = cr_max_func(gestures_ref{k},npart);
  cr_max = [cr_max; cr_max_ref{k}];
endfor

% Consensus (Cr) --> delta = jac
cr_jac = [];
for k = 1:nref
  cr_jac_ref{k} = cr_jac_func(gestures_ref{k},npart);
  cr_jac = [cr_jac; cr_jac_ref{k}];
endfor

% Consensus (Cr) --> delta = sor
cr_sor = [];
for k = 1:nref
  cr_sor_ref{k} = cr_sor_func(gestures_ref{k},npart);
  cr_sor = [cr_sor; cr_sor_ref{k}];
endfor

% Consensus (Cr) --> delta = overlap
cr_overlap = [];
for k = 1:nref
  cr_overlap_ref{k} = cr_over_func(gestures_ref{k},npart);
  cr_overlap = [cr_overlap; cr_overlap_ref{k}];
endfor

% Guessability
guessability = -1;
% Create a dialog asking the user if they want to perform the guessability calculation
choice = menu("Do you want to perform the guessability calculation?", "Yes", "No");
% Check the user's choice
if choice == 1
    disp("Performing guessability calculation...");
    guessability = guess_func(gestures,npart,nref);
else
    disp("Guessability calculation skipped.");
end

[contingency_table,winning_gestures_contingency] = contingency_func(gestures,gestures_ref);
contingency = [];
for k = 1:nref
  aux = find(contingency_table(:,(k+1))!=0);
  contingency_ref{k} = contingency_table(aux,(k+1));
  contingency = [contingency; contingency_ref{k}];
  contingency_ref{k} = [gestures_ref_col{k} contingency_ref{k}];
endfor

%% Data Output

% Output folder name selection
while true
  % Ask the user for the output folder name
  prompt = {'Enter output folder name:'};
  dlgtitle = 'Output Folder Selection';
  dims = [1 50];
  definput = {''};
  answer = inputdlg(prompt, dlgtitle, dims, definput);
  if isempty(answer)
    disp('No input provided. Exiting...');
    return;
  end
  folder = answer{1};
  % Check if the folder exists
  if isfolder(folder)
    msg = sprintf('Folder "%s" already exists.', folder);
    choice = questdlg([msg ' Do you want to overwrite the files in this folder?'], ...
    'Folder Exists', 'Yes', 'No', 'Cancel', 'Cancel');
    % Handle user's response
    switch choice
      case 'Yes'
        msgbox('Overwriting existing files...');
        break; % Proceed with the current directory
      case 'No'
        msgbox('Please choose a new folder name.');
        % Loop continues to ask for a new name
      case 'Cancel'
        msgbox('Operation cancelled.');
        return; % Exit without any action
      end
  else
    % Create the folder if it doesn't exist
    mkdir(folder);
    break; % Exit the loop
  end
end

aux_name = "/contingency_table.csv";
dlmwrite(strcat(path,folder,aux_name),contingency_table,';');

aux_name = "/gesture_summary_report.txt";
fid = fopen(strcat(path, folder, aux_name), 'w');
refs = (1:nref);
fprintf(fid, 'GESTURE SUMMARY REPORT\n');
fprintf(fid, '\nTotal Number of Distinct Gestures: %3d\n', ngest);
fprintf(fid, '\nAverage Number of Distinct Gestures per Referent: %5.2f\n', mean(num_gestures_ref));
fprintf(fid, '\nStandard Deviation of Distinct Gestures per Referent: %5.2f\n', std(num_gestures_ref));
fprintf(fid, '\nMedian Number of Distinct Gestures per Referent: %3d\n', median(num_gestures_ref));
fprintf(fid, '\nMinimum Number of Distinct Gestures per Referent: %3d\n', min(num_gestures_ref));
fprintf(fid, '\nMaximum Number of Distinct Gestures per Referent: %3d\n', max(num_gestures_ref));
fprintf(fid, '\nAverage Number of Proposed Gestures per Participant: %5.2f\n', mean_num_gestures_part);
fprintf(fid, '\nAverage Number of Distinct Proposed Gestures per Participant: %5.2f\n', mean_num_dist_gestures_part);
fprintf(fid, '\nMedian Number of Proposed Gestures per Participant: %5.2f\n', median_num_gestures_part);
fprintf(fid, '\nMedian Number of Distinct Proposed Gestures per Participant: %5.2f\n', median_num_dist_gestures_part);
fprintf(fid, '\nMinimum Number of Proposed Gestures per Participant: %3d\n', min_num_gestures_part);
fprintf(fid, '\nMinimum Number of Distinct Proposed Gestures per Participant: %3d\n', min_num_dist_gestures_part);
fprintf(fid, '\nMaximum Number of Proposed Gestures per Participant: %3d\n', max_num_gestures_part);
fprintf(fid, '\nMaximum Number of Distinct Proposed Gestures per Participant: %3d\n', max_num_dist_gestures_part);
fprintf(fid, '\nReferent   Dist. Gest./Ref.   Avg. Gest./Part.   Avg. Dist. Gest./Part.   Median Gest./Part.   Median Dist. Gest./Part.   Min Gest./Part   Min Dist. Gest./Part.   Max Gest./Part.   Max Dist. Gest./Part.\n');
for k = 1:nref
fprintf(fid, '%5d %14d %19.2f %21.2f %22.2f %22.2f %21d %19d %21d %19d\n', ...
    refs(k), num_gestures_ref(k), mean_num_gestures_ref_part(k), mean_num_dist_gestures_ref_part(k), ...
    median_num_gestures_ref_part(k), median_num_dist_gestures_ref_part(k), ...
    min_num_gestures_ref_part(k), min_num_dist_gestures_ref_part(k), ...
    max_num_gestures_ref_part(k), max_num_dist_gestures_ref_part(k));
endfor
fclose(fid);

aux_name = "/winning_gestures.txt";
fid = fopen(strcat(path, folder, aux_name), 'w');
refs = (1:nref);

% Loop over each referent
% Write Contingency Gestures
fprintf(fid, 'Winning Gestures \n');
fprintf(fid, '\nContingency Table Winning Gestures: \n');
for k = 1:nref
    fprintf(fid, 'Referent %2d: ', refs(k));
    for l = 1:length(winning_gestures_contingency{k})
        fprintf(fid, '%2d ', winning_gestures_contingency{k}(l));
    endfor
    fprintf(fid, '\n');
endfor

% Write Popularity Gestures
fprintf(fid, '\nPopularity Winning Gestures: \n');
for k = 1:nref
    fprintf(fid, 'Referent %2d: ', refs(k));
    for l = 1:length(winning_gestures_popularity{k})
        fprintf(fid, '%2d ', winning_gestures_popularity{k}(l));
    endfor
    fprintf(fid, '\n');
endfor

% Write GOR Gestures
fprintf(fid, '\nGOR Winning Gestures: \n');
for k = 1:nref
    fprintf(fid, 'Referent %2d: ', refs(k));
    for l = 1:length(winning_gestures_gor{k})
        fprintf(fid, '%2d ', winning_gestures_gor{k}(l));
    endfor
    fprintf(fid, '\n');
endfor

% Write VOR Gestures
fprintf(fid, '\nVOR Winning Gestures: \n');
for k = 1:nref
    fprintf(fid, 'Referent %2d: ', refs(k));
    for l = 1:length(winning_gestures_vor{k})
        fprintf(fid, '%2d ', winning_gestures_vor{k}(l));
    endfor
    fprintf(fid, '\n');
endfor

% Write OOR Gestures
fprintf(fid, '\nOOR Winning Gestures: \n');
for k = 1:nref
    fprintf(fid, 'Referent %2d: ', refs(k));
    for l = 1:length(winning_gestures_oor{k})
        fprintf(fid, '%2d ', winning_gestures_oor{k}(l));
    endfor
    fprintf(fid, '\n');
endfor

% Write IL Gestures
fprintf(fid, '\nIL Winning Gestures: \n');
for k = 1:nref
    fprintf(fid, 'Referent %2d: ', refs(k));
    for l = 1:length(winning_gestures_IL{k})
        fprintf(fid, '%2d ', winning_gestures_IL{k}(l));
    endfor
    fprintf(fid, '\n');
endfor

% Write ILN Gestures
fprintf(fid, '\nILN Winning Gestures: \n');
for k = 1:nref
    fprintf(fid, 'Referent %2d: ', refs(k));
    for l = 1:length(winning_gestures_ILN{k})
        fprintf(fid, '%2d ', winning_gestures_ILN{k}(l));
    endfor
    fprintf(fid, '\n');
endfor

% Write ILN1 Gestures
fprintf(fid, '\nILN1 Winning Gestures: \n');
for k = 1:nref
    fprintf(fid, 'Referent %2d: ', refs(k));
    for l = 1:length(winning_gestures_ILN1{k})
        fprintf(fid, '%2d ', winning_gestures_ILN1{k}(l));
    endfor
    fprintf(fid, '\n');
endfor

fclose(fid);

aux_name = "/vocabulary_metrics.txt";
fid = fopen(strcat(path,folder,aux_name),'w');
fprintf(fid, 'Average Max-Consensus =%7.2f%%\n\n',(mean(max_con)*100));
fprintf(fid, 'Maximum Max-Consensus =%7.2f%%\n\n',(max(max_con)*100));
fprintf(fid, 'Average Constant-Distinct Ratio =%7.2f%%\n\n',(mean(cdr)*100));
fprintf(fid, 'Maximum Constant-Distinct Ratio =%7.2f%%\n\n',(max(cdr)*100));
if guessability != -1
  fprintf(fid, 'Guessability =%7.2f%%\n\n',(guessability*100));
endif
refs = (1:nref);
fprintf(fid, ' Referent  POP       Max-Con     CDR      AR*(min)   AR*(med)   AR*(max)   AR*(Jac)   AR*(Sor)   A*(Over)     IL_R      ILN_R      ILN1_R\n');
fprintf(fid, '%5d %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f\n', [refs; pop_R'; max_con'; cdr'; cr_min'; cr_median'; cr_max'; cr_jac'; cr_sor'; cr_overlap'; IL_R'; ILN_R'; ILN1_R']);
fclose(fid);

aux_name = "/vocabulary_metrics.csv";
dlmwrite(strcat(path,folder,aux_name),[refs' ILN_R ILN1_R IL_R pop_R max_con cdr cr_min cr_median cr_max cr_jac cr_sor cr_overlap],';');

aux_name = "/gesture_metrics.csv";
dlmwrite(strcat(path,folder,aux_name),[referent_col gestures_col contingency popularity gor vor oor IL ILN ILN1],';');

aux_name = "_gesture_metrics.csv";
ref = "/referent_";
for k = 1:nref
  ref_num = num2str(k);
  file_name = strcat(path,folder,ref,ref_num,aux_name);
  dlmwrite(file_name,[contingency_ref{k} pop_ref{k}(:,2) gor_ref{k}(:,2) vor_ref{k}(:,2) oor_ref{k}(:,2) IL_ref{k}(:,2) ILN_ref{k}(:,2) ILN1_ref{k}(:,2)],';');
endfor

Finished = 'Ok'

