clc
clear all
close all

pkg load optim
pkg load struct


% Read gesture data filename
[filename,path]=uigetfile("*.csv",'Select Gestures File (Referent Column; Participant Column; Gesture ID Column)');
gestures = dlmread(strcat(path,filename),';'); % Referent, Participant, Gesture
% Determine the number of Participants and referents
[ntotalgest, ~] = size(gestures(:, 1));
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

% ORT (Occurrence Rate Overall)
ort = [];
winning_gestures_ort = [];
for k = 1:nref
  ort_ref{k} = ort_func(gestures_ref{k},npart);
  ort = [ort; ort_ref{k}];
  ort_ref{k} = [gestures_ref_col{k} ort_ref{k}];
  max_ort = max(ort_ref{k}(:,2));
  max_ort_gesture_rows = find(ort_ref{k}(:,2) == max_ort);
  winning_gestures_ort{k} = ort_ref{k}(max_ort_gesture_rows, 1);
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
IL = (ort+vor+gor)/3;

% IL by referent
IL_R = [];
winning_gestures_IL = [];
for k = 1:nref
  IL_ref{k} = ((ort_ref{k}(:,2)+vor_ref{k}(:,2)+gor_ref{k}(:,2))/3);
  IL_R_ref = max(IL_ref{k});
  IL_R = [IL_R; IL_R_ref];
  IL_ref{k} = [gestures_ref_col{k} IL_ref{k}];
  max_IL = max(IL_ref{k}(:,2));
  max_IL_gesture_rows = find(IL_ref{k}(:,2) == max_IL);
  winning_gestures_IL{k} = IL_ref{k}(max_IL_gesture_rows, 1);
endfor

% Main program
% Consensus (Cr) --> delta = average (Vatavu 2019 - Dissimilarity Consensus)
CGR = [];
tau_0 = [];
for k = 1:nref
  [CGR_ref{k},tau_0_ref{k}] = consensus_func(gestures_ref{k}, npart);
  CGR = [CGR; CGR_ref{k}];
	tau_0 = [tau_0; tau_0_ref{k}];
endfor

% Consensus-Distinct Ratio (CDR)
threshold = 2;
cdr = [];
for k = 1:nref
  cdr_ref{k} = cdr_func(gestures_ref{k},npart,threshold);
  cdr = [cdr; cdr_ref{k}];
endfor

% General Agreement (GA) --> SIM = Jaccard
ar_jac = [];
for k = 1:nref
  ar_jac_ref{k} = ar_jac_func(gestures_ref{k},npart);
  ar_jac = [ar_jac; ar_jac_ref{k}];
endfor

% General Agreement (GA) --> SIM = Sorensen
ar_sor = [];
for k = 1:nref
  ar_sor_ref{k} = ar_sor_func(gestures_ref{k},npart);
  ar_sor = [ar_sor; ar_sor_ref{k}];
endfor

% General Agreement (GA) --> delta = overlap
ar_overlap = [];
for k = 1:nref
  ar_overlap_ref{k} = ar_over_func(gestures_ref{k},npart);
  ar_overlap = [ar_overlap; ar_overlap_ref{k}];
endfor

% Guessability
guessability = -1;
% Create a dialog asking the user if they want to perform the guessability calculation
choice = menu("Do you want to perform the guessability calculation?", "No", "Yes");
% Check the user's choice
if choice == 1
    disp("Guessability calculation skipped.");
else
    disp("Performing guessability calculation...");
    guessability = guess_func(gestures,npart,nref);
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

% Call the function to get the output_folder path
output_folder = select_or_create_folder();

% Check if the user cancelled the operation
if isempty(output_folder)
  disp('No folder selected. Exiting...');
  return;
else
  disp(['Selected folder: ', output_folder]);
  % Proceed with your code using the selected folder
end

aux_name = "/contingency_table.csv";
dlmwrite(strcat(output_folder,aux_name),contingency_table,';');

aux_name = "/gesture_summary_report.txt";
fid = fopen(strcat(output_folder, aux_name), 'w');
refs = (1:nref);
fprintf(fid, 'GESTURE SUMMARY REPORT\n');
fprintf(fid, '\nTotal Number of Gestures: %3d\n', ntotalgest);
fprintf(fid, '\nTotal Number of Distinct Gestures: %3d\n', ngest);
fprintf(fid, '\nAverage Number of Instances per Distinct Gesture Set: %3d\n', (ntotalgest/ngest));
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
fid = fopen(strcat(output_folder, aux_name), 'w');
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

% Write ORT Gestures
fprintf(fid, '\nORT Winning Gestures: \n');
for k = 1:nref
    fprintf(fid, 'Referent %2d: ', refs(k));
    for l = 1:length(winning_gestures_ort{k})
        fprintf(fid, '%2d ', winning_gestures_ort{k}(l));
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

fclose(fid);

aux_name = "/vocabulary_metrics.txt";
fid = fopen(strcat(output_folder,aux_name),'w');
fprintf(fid, 'Average Max-Consensus =%7.2f%%\n\n',(mean(max_con)*100));
fprintf(fid, 'Maximum Max-Consensus =%7.2f%%\n\n',(max(max_con)*100));
fprintf(fid, 'Average Constant-Distinct Ratio =%7.2f%%\n\n',(mean(cdr)*100));
fprintf(fid, 'Maximum Constant-Distinct Ratio =%7.2f%%\n\n',(max(cdr)*100));
if guessability != -1
  fprintf(fid, 'Guessability =%7.2f%%\n\n',(guessability*100));
endif
refs = (1:nref);
fprintf(fid, ' Referent  POP       Max-Con     CDR        CGR      AR*(Jac)   AR*(Sor)   AR*(Over)    IL_R\n');
fprintf(fid, '%5d %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f\n', [refs; pop_R'; max_con'; cdr'; CGR'; ar_jac'; ar_sor'; ar_overlap'; IL_R']);
fclose(fid);

aux_name = "/vocabulary_metrics.csv";
dlmwrite(strcat(output_folder,aux_name),[refs' pop_R max_con cdr CGR ar_jac ar_sor ar_overlap IL_R],';');

aux_name = "/gesture_metrics.csv";
dlmwrite(strcat(output_folder,aux_name),[referent_col gestures_col contingency popularity gor vor ort IL],';');

aux_name = "_gesture_metrics.csv";
ref = "/referent_";
for k = 1:nref
    ref_num = num2str(k);
    file_name = strcat(output_folder,ref,ref_num,aux_name);
    dlmwrite(file_name,[contingency_ref{k} pop_ref{k}(:,2) gor_ref{k}(:,2) vor_ref{k}(:,2) ort_ref{k}(:,2) IL_ref{k}(:,2)],';');
endfor

Finished = 'Ok'

