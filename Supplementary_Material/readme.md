# Supplementary Material

Purpose
This folder contains example datasets, precomputed results, and supplementary files used in the analyses and to reproduce results presented in the paper.

Datasets
The folder is organized into two dataset subfolders (as present in the repo):
1. Frustration‑Based Approach Dataset Supplementary Material
2. Take a Seat, Make a Gesture Dataset Supplementary Material

Contents of each dataset folder
Each dataset subfolder typically includes:
- contingency_table.csv — contingency tables used for analysis
- gesture_metrics.csv — complete gesture metrics for all referents
- referent_*_gesture_metrics.csv — one CSV per referent (individual gesture metrics)
- vocabulary_metrics.csv — vocabulary-level metrics table
- vocabulary_metrics.txt — text summary of vocabulary metrics
- gesture_summary_report.txt — human-readable summary report
- winning_gestures.txt — list of winning gestures per referent
- R_Data/ — folder with R outputs (plots, CI and p-values text files, PNGs of correlations, etc.)

How to use these files
- Open CSV/TXT files with common tools (Excel, Python/pandas, R, or a text editor).
- Use these CSVs as input examples for the Octave scripts in `Octave Files/` (for example, `hri_metrics.m` and `gesture_metrics_eval.m`) or as input for the R scripts in `R_file/`.
- Example Octave workflow:
  1. Start Octave and change directory to `Octave Files`:
     cd('Octave Files')
  2. Run the main script and select a CSV from this folder when prompted:
     run('hri_metrics.m')
- Example R usage (from repo root):
  Rscript "R_file/Metrics_correlation.R" --args input="path/to/contingency_table.csv" output="results/"

Notes and recommendations
- These supplementary files are intended as working examples to test or reproduce analyses without running the full experiment pipeline.
- Confirm column names and ordering in these CSVs (Referent, Participant, Gesture ID, and metric columns such as GOR / ORT / VOR) before using them as inputs, since scripts may select or slice columns by position.
- If your datasets are large or contain sensitive participant data, provide sanitized sample files in this folder instead of raw data.
- The `R_Data/` subfolders contain the R outputs used in the paper (plots and text outputs). They are useful references for expected plot appearance and reported statistics.

Links
- See the root `README.md` for overall project usage and installation instructions.
- See `Octave Files/README.md` and `R_file/README.md` (if present) for folder-specific instructions.

If you want, I can:
- replace the existing `Supplementary_Material/readme.md` in the repository with this merged version (branch + PR or direct commit),
- or create an additional `Supplementary_Material/README.md` (capitalized variant) if you prefer consistent capitalization across folders.
