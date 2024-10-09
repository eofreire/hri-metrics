clc
clear all
close all

% Read gesture data filename
[filename,path]=uigetfile("*.csv",'Select Gestures File (Referent Column; Volunteer Column; Gesture ID Column)');
gestures = dlmread(strcat(path,filename),';'); % Referent, Volunteer, Gesture
% Determine the number of volunteers and referents
[nref, ~] = size(unique(gestures(:, 1)));
[nvol, ~] = size(unique(gestures(:, 2)));

[rows, cols] = size(gestures);
gestures(1,1) = 1;

% Organize gestures by referent
for k = 1:nref
  gestures_ref{k} = gestures(gestures(:,1)==k,2:3);
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
  gor_ref{k} = gor_func(gestures_ref{k},nvol);
  gor = [gor; gor_ref{k}];
  gor_ref{k} = [gestures_ref_col{k} gor_ref{k}];
  [max_gor, max_gor_gesture_row] = max(gor_ref{k}(:,2));
  max_gor_gesture = gor_ref{k}(max_gor_gesture_row,1);
  winning_gestures_gor = [winning_gestures_gor max_gor_gesture];
endfor

% ORO (Occurrence Rate Overall)
oro = [];
winning_gestures_oro = [];
for k = 1:nref
  oro_ref{k} = oro_func(gestures_ref{k},nvol);
  oro = [oro; oro_ref{k}];
  oro_ref{k} = [gestures_ref_col{k} oro_ref{k}];
  [max_oro, max_oro_gesture_row] = max(oro_ref{k}(:,2));
  max_oro_gesture = oro_ref{k}(max_oro_gesture_row,1);
  winning_gestures_oro = [winning_gestures_oro max_oro_gesture];
endfor

% Volunteer Occurrence Rate (VOR)
vor = [];
winning_gestures_vor = [];
for k = 1:nref
  vor_ref{k} = vor_func(gestures_ref{k},nvol);
  vor = [vor; vor_ref{k}];
  vor_ref{k} = [gestures_ref_col{k} vor_ref{k}];
##  max_vor = max(vor_ref{k}(:,2));
##  max_vor_gesture_rows = find(vor_ref{k}(:,2) == max_vor);
##  winning_gestures_vor{k} = vor_ref{k}(max_vor_gesture_rows, 1);
  [max_vor, max_vor_gesture_row] = max(vor_ref{k}(:,2));
  max_vor_gesture = vor_ref{k}(max_vor_gesture_row,1);
  winning_gestures_vor = [winning_gestures_vor max_vor_gesture];
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
  [max_pop, max_pop_gesture_row] = max(pop_ref{k}(:,2));
  max_pop_gesture = pop_ref{k}(max_pop_gesture_row,1);
  winning_gestures_popularity = [winning_gestures_popularity max_pop_gesture];
endfor

% Intuitiveness Level (IL)
IL = (oro+vor+gor)/3;

% IL by referent
IL_R = [];
winning_gestures_IL = [];
for k = 1:nref
  IL_ref{k} = ((oro_ref{k}(:,2)+vor_ref{k}(:,2)+gor_ref{k}(:,2))/3);
  IL_R_ref = max(IL_ref{k});
  IL_R = [IL_R; IL_R_ref];
  IL_ref{k} = [gestures_ref_col{k} IL_ref{k}];
  [max_IL, max_IL_gesture_row] = max(IL_ref{k}(:,2));
  max_IL_gesture = IL_ref{k}(max_IL_gesture_row,1);
  winning_gestures_IL = [winning_gestures_IL max_IL_gesture];
endfor

% Intuitiveness Level - Normalized (ILN)
ILN = (norm(oro)+norm(vor)+norm(gor))/3;

% ILN by referent
ILN_R = [];
winning_gestures_ILN = [];
for k = 1:nref
  ILN_ref{k} = (norm(oro_ref{k}(:,2))+norm(vor_ref{k}(:,2))+norm(gor_ref{k}(:,2)))/3;
  ILN_R_ref = max(ILN_ref{k});
  ILN_R = [ILN_R; ILN_R_ref];
  ILN_ref{k} = [gestures_ref_col{k} ILN_ref{k}];
  [max_ILN, max_ILN_gesture_row] = max(ILN_ref{k}(:,2));
  max_ILN_gesture = ILN_ref{k}(max_ILN_gesture_row,1);
  winning_gestures_ILN = [winning_gestures_ILN max_ILN_gesture];
endfor

% Intuitiveness Level - Normalized (ILN1)
ILN1 = ((oro/max(oro(:)))+(vor/max(vor(:)))+(gor/max(gor(:))))/3;

% ILN1 by referent
ILN1_R = [];
winning_gestures_ILN1 = [];
for k = 1:nref
  ILN1_ref{k} = ((oro_ref{k}(:,2)/max(oro_ref{k})(:,2))+(vor_ref{k}(:,2)/max(vor_ref{k}(:,2)))+(gor_ref{k}(:,2)/max(gor_ref{k})(:,2)))/3;
  ILN1_R_ref = max(ILN1_ref{k});
  ILN1_R = [ILN1_R; ILN1_R_ref];
  ILN1_ref{k} = [gestures_ref_col{k} ILN1_ref{k}];
  [max_ILN1, max_ILN1_gesture_row] = max(ILN1_ref{k}(:,2));
  max_ILN1_gesture = ILN1_ref{k}(max_ILN1_gesture_row,1);
  winning_gestures_ILN1 = [winning_gestures_ILN1 max_ILN1_gesture];
endfor

% Consensus-Distinct Ratio (CDR)
threshold = 2;
cdr = [];
for k = 1:nref
  cdr_ref{k} = cdr_func(gestures_ref{k},nvol,threshold);
  cdr = [cdr; cdr_ref{k}];
endfor

% Consensus (Cr) --> delta = median (Vatavu 2019 - Dissimilarity Consensus)
cr_median = [];
for k = 1:nref
  cr_median_ref{k} = cr_avg_func(gestures_ref{k},nvol);
  cr_median = [cr_median; cr_median_ref{k}];
endfor

% Consensus (Cr) --> delta = min
cr_min = [];
for k = 1:nref
  cr_min_ref{k} = cr_min_func(gestures_ref{k},nvol);
  cr_min = [cr_min; cr_min_ref{k}];
endfor

% Consensus (Cr) --> delta = max
cr_max = [];
for k = 1:nref
  cr_max_ref{k} = cr_max_func(gestures_ref{k},nvol);
  cr_max = [cr_max; cr_max_ref{k}];
endfor

% Consensus (Cr) --> delta = jac
cr_jac = [];
for k = 1:nref
  cr_jac_ref{k} = cr_jac_func(gestures_ref{k},nvol);
  cr_jac = [cr_jac; cr_jac_ref{k}];
endfor

% Consensus (Cr) --> delta = sor
cr_sor = [];
for k = 1:nref
  cr_sor_ref{k} = cr_sor_func(gestures_ref{k},nvol);
  cr_sor = [cr_sor; cr_sor_ref{k}];
endfor

% Consensus (Cr) --> delta = overlap
cr_overlap = [];
for k = 1:nref
  cr_overlap_ref{k} = cr_over_func(gestures_ref{k},nvol);
  cr_overlap = [cr_overlap; cr_overlap_ref{k}];
endfor

% Guessability
##selected_gestures = [2 28 39 27 43 5]; % Chosen gestures
##guess = guess_func(gestures,nvol,nref,selected_gestures);

[contingency_table,winning_gestures] = contingency_func(gestures,gestures_ref);

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

aux_name = "/winner_gestures.txt";
#dlmwrite(strcat(path,filename,aux_name),[winning_gestures; winning_gestures_popularity; winning_gestures_vor; winning_gestures_gor; winning_gestures_oro; winning_gestures_IL; winning_gestures_ILN; winning_gestures_ILN1],';');
fid = fopen(strcat(path,folder,aux_name),'w');
refs = (1:nref);
fprintf(fid, ' Referent  Contingency     Pop     VOR     GOR     ORO    IL_R   ILN_R   ILN1_R\n');
fprintf(fid, '%5d %12d %10d %7d %7d %7d %7d %7d %7d\n', [refs; winning_gestures; winning_gestures_popularity; winning_gestures_vor; winning_gestures_gor; winning_gestures_oro; winning_gestures_IL; winning_gestures_ILN; winning_gestures_ILN1]);
fclose(fid);

aux_name = "/vocabulary_metrics.txt";
fid = fopen(strcat(path,folder,aux_name),'w');
refs = (1:nref);
fprintf(fid, ' Referent  ILN_R     ILN1_R      IL_R       Pop       Max-Con     CDR       Cr(min)    Cr(med)    Cr(max)    Cr(Jac)    Cr(Sor)   Cr(Over) \n');
fprintf(fid, '%5d %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f\n', [refs; ILN_R'; ILN1_R'; IL_R'; pop_R'; max_con'; cdr'; cr_min'; cr_median'; cr_max'; cr_jac'; cr_sor'; cr_overlap']);
fclose(fid);

aux_name = "/vocabulary_metrics.csv";
dlmwrite(strcat(path,folder,aux_name),[refs' ILN_R ILN1_R IL_R pop_R max_con cdr cr_min cr_median cr_max cr_jac cr_sor cr_overlap],';');

aux_name = "/gesture_metrics.csv";
dlmwrite(strcat(path,folder,aux_name),[referent_col gestures_col popularity gor vor oro IL ILN ILN1],';');

aux_name = "_gesture_metrics.csv";
ref = "/referent_";
for k = 1:nref
  ref_num = num2str(k);
  file_name = strcat(path,folder,ref,ref_num,aux_name);
  dlmwrite(file_name,[pop_ref{k} gor_ref{k}(:,2) vor_ref{k}(:,2) oro_ref{k}(:,2) IL_ref{k}(:,2) ILN_ref{k}(:,2) ILN1_ref{k}(:,2)],';');
endfor

Finished = 'Ok'

