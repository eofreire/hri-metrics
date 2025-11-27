clc
close all
clear all

% Read gesture data filename
[filename,path]=uigetfile("*.csv",'Select Gestures Metrics File');
gestures_metrics = dlmread(strcat(path,filename),';');
% Determine the number of volunteers and referents
[nref, ~] = size(unique(gestures_metrics(:, 1)));
VarNames_gesture_metrics = {'CONT'; 'POP'; 'GOR'; 'VOR'; 'OOR'; 'ILN'};
%VarNames_gesture_metrics = {'CONT'; 'POP'; 'GOR'; 'VOR'; 'OOR'; 'IL'};
VarNames_vocabylary_metrics = {'IL R'; 'POP'; 'Max-Con'; 'CDR'; 'CGR'; 'AR*(Jac)'; 'AR*(Sør)'; 'AR*(Over)'};
low_thresh = 0;
mid_thresh = 0.5;
hig_thresh = 1.0;

##% Prompt user for threshold values
##disp('Please enter three threshold values for the colormap.');
##low_thresh = input('Low threshold: ');
##mid_thresh = input('Mid threshold: ');
##hig_thresh = input('High threshold: ');

aux_name = "_gesture_metrics.csv";
ref = "referent_";
for k = 1:nref
  ref_num = num2str(k);
  metrics_ref_aux{k} = dlmread(strcat(path,ref,ref_num,aux_name));
  [nlin,ncol] = size(metrics_ref_aux{k});
  metrics_ref{k} = metrics_ref_aux{k} (:,(2:(ncol-3)));
  metrics_ref{k} = [metrics_ref{k}, metrics_ref_aux{k}(:,ncol-1)];
  corr_K = kendall(metrics_ref{k});
#  corr_S = spearman(metrics_ref{k});
  ##[corr_K_tau,coor_K_p] = corr(vocabulary_metrics, 'type', 'Kendall');
  ##[corr_S_tau,coor_S_p] = corr(vocabulary_metrics, 'type', 'Spearman');
  titulo_K = strcat('Kendall Referent:',ref_num);
  titulo_S = strcat('Spearman Referent:',ref_num);
  exibe_tabela(corr_K,titulo_K,VarNames_gesture_metrics,low_thresh,mid_thresh,hig_thresh);
#  exibe_tabela(corr_S,titulo_S,VarNames_gesture_metrics,low_thresh,mid_thresh,hig_thresh);
endfor

[filename,path]=uigetfile("*.csv",'Select Vocabulary Metrics File');
vocabulary_metrics = dlmread(strcat(path,filename),';');
[nlin,ncol] = size(vocabulary_metrics);
vocabulary_metrics = vocabulary_metrics(:,5:ncol);

corr_K = kendall(vocabulary_metrics);
corr_S = spearman(vocabulary_metrics);

##[corr_K_tau,coor_K_p] = corr(vocabulary_metrics, 'type', 'Kendall');
##[corr_S_tau,coor_S_p] = corr(vocabulary_metrics, 'type', 'Spearman');

exibe_tabela(corr_K,'Kendall',VarNames_vocabylary_metrics,low_thresh,mid_thresh,hig_thresh);
exibe_tabela(corr_S,'Spearman',VarNames_vocabylary_metrics,low_thresh,mid_thresh,hig_thresh);


