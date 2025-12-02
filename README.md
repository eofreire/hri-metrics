# hri_metrics

Gesture analysis tools and metrics for human–robot/human–machine interaction research.

This repository contains implementations to compute descriptive gesture metrics (occurrence rates, intuitiveness indices, consensus measures, Consensus‑Distinct Ratio (CDR), and optional guessability calculations). The codebase is organized by language and purpose to make it easier to run analyses and reproduce results from experiments.

This README mirrors the current repository layout and includes exact entry-point filenames for the Octave and R workflows.

## Quick summary

- Purpose: Compute and report gesture statistics and vocabulary metrics from gesture labeling datasets.
- Languages: Octave (primary analysis), R (additional processing/visualization).
- Input: CSV files with gesture annotations (referent, participant, gesture id).
- Output: Text and CSV reports (gesture summary, contingency tables), and optionally plots when using R scripts.

## Features

- Interactive and scriptable processing of gesture datasets.
- Multiple occurrence metrics (GOR, ORT, VOR) and Intuitiveness Level (IL) with three normalizations.
- Consensus measures and the Consensus‑Distinct Ratio (CDR).
- Optional Guessability calculation based on participant-provided labels.
- Generates human-readable summary reports and machine-readable contingency tables for downstream analysis.

## Requirements

- Octave (recommended >= 9.1)
- R (recommended >= 4.0) — only if you plan to run the R scripts in `R_file/`
- No special Octave toolboxes are required for the core scripts; check the top of each file for specific package requirements.
- OS: cross-platform; avoid committing macOS `.DS_Store` files (see housekeeping below).

## Repository structure (current)

Top-level folders and important files:
- Octave Files/  
  - Main entry points:
    - hri_metrics.m — primary interactive/scriptable analysis driver (recommended entry point)
    - gesture_metrics_eval.m — evaluation / alternate analysis script
  - Sample dataset:
    - FBA_gestures.csv
  - Key helper functions (not exhaustive):
    - gor_func.m
    - ort_func.m
    - vor_func.m
    - cdr_func.m
    - cr_func.m, cr_avg_func.m, cr_med_func.m, cr_min_func.m, cr_max_func.m, cr_sor_func.m (consensus-related helpers)
    - consensus_func.m
    - contingency_func.m
    - calculate_DIM.m
    - guess_func.m
    - display_table.m
    - select_or_create_folder.m
    - norm.m, org_func.m, ar_* and cr_* jac/sor/over functions
  - Other files: DS_Store (should be removed/ignored)
- R_file/
  - Metrics_correlation.R — R script for metric correlation/visualization
- Supplementary_Material/  
  - Example datasets and supporting files (see folder for contents)
- README.md — this file
- LICENSE — MIT License (see file in repo root)

## Input data format

The Octave scripts expect a CSV file with columns including (at minimum):
- Referent (what the gesture refers to)
- Participant (participant identifier)
- Gesture ID (gesture label/identifier given by the participant)

Column names are case-insensitive, but the script expects the columns to be present in some order. If your CSV uses different names, either rename the columns or adapt the input-parsing portion of the main script.

A sample dataset is provided at `Octave Files/FBA_gestures.csv`.

## Usage — Octave (exact commands)

1. Open Octave (CLI or GUI).
2. Change directory to the Octave scripts folder:
   ```octave
   cd('Octave Files')
   ```
3. Run the primary analysis driver:
   ```octave
   run('hri_metrics.m')
   ```
   or call the function (if in Octave path):
   ```octave
   hri_metrics
   ```
4. Alternate analysis/evaluation entry point:
   ```octave
   run('gesture_metrics_eval.m')
   ```

Expected interactive prompts (behavior of hri_metrics.m):
- Select an input CSV file (or provide a path programmatically).
- Choose whether to perform Guessability calculations.
- Select or create an output folder (the script can prompt to overwrite).
- The script will write one or more output files into the chosen folder.

Non-interactive usage:
- Inspect the top of `hri_metrics.m` to see how input/output variables are read; you can create a small wrapper script that sets:
  - input CSV path
  - output folder path
  - guessability flag
  and then calls the functions used by `hri_metrics.m` for batch processing or CI runs.

## Usage — R (exact command)

From the repository root (or anywhere), run the R script:
```bash
Rscript "R_file/Metrics_correlation.R" --args input="path/to/contingency_table.csv" output="results/"
```


## Outputs

Files typically produced by the Octave workflow (written inside the output folder you choose):
- gesture_summary_report.txt — human-readable statistical summary per referent/participant.
- contingency_table.csv — machine-readable table of occurrences (referent × gesture × participant).
- Additional CSVs containing computed metrics (GOR, ORT, VOR, IL / ILN / ILN1, Cr, popularity, CDR).
- If R scripts are run, generated plots (PNG, PDF) or aggregated reports.

Keep outputs in dedicated results directories (e.g., results/run1/) to preserve reproducibility.


- GOR (General Occurrence Rate): Frequency of gestures per referent (how often a gesture occurs for a specific referent across participants).
- ORT (Occurrence Rate by Time): Measures the occurrence rate taking temporal exposure or interaction time into account (e.g., occurrences per unit time or normalized by exposure duration).
- VOR (Participant Occurrence Rate): Frequency normalized per participant (how often a participant used a given gesture).
- Intuitiveness Level (IL):
  - IL: arithmetic mean of GOR, VOR, and ORT (no normalization).
  - ILN: mean after max-normalization.
  - ILN1: mean after min‑max normalization.
  In the referenced paper, ILN (max-normalization) was used for individual-gesture metrics; for vocabulary metrics, the maximum IL per referent was assigned as IL_R.
- Consensus (Cr): measure(s) of agreement across participants for referent–gesture pairings (several aggregation methods implemented).
- Popularity: weighted metric derived from occurrence rates.
- CDR (Consensus‑Distinct Ratio): assesses distinctiveness vs. consensus under a chosen threshold.
- Guessability: optional measure calculating the likelihood that a gesture is guessed/adopted by others given participant-provided labels.

Formulas and implementation notes are documented inside the relevant function files (see `ort_func.m`, `gor_func.m`, `vor_func.m`, `cdr_func.m`, and consensus helpers). Consult those headers for exact computation details.

## Custom functions (entry and examples)

Primary Octave entry points:
- hri_metrics.m — main script combining data loading, metric calculations, and output generation.
- gesture_metrics_eval.m — alternative driver for evaluation scenarios.

Important helper functions located in `Octave Files/` (used by the entry scripts):
- gor_func.m
- ort_func.m
- vor_func.m
- cdr_func.m
- cr_func.m and cr_* variants
- consensus_func.m
- contingency_func.m
- guess_func.m
- select_or_create_folder.m
- display_table.m
- calculate_DIM.m
- norm.m, org_func.m
- several ar_* helper functions

Read each function's header comments for expected inputs and outputs.

## Example workflow (concise)

1. Start Octave.
2. cd('Octave Files').
3. run('hri_metrics.m') and select `Octave Files/FBA_gestures.csv` as input.
4. Choose output folder (e.g., `results/run1/`).
5. Inspect `results/run1/gesture_summary_report.txt` and `results/run1/contingency_table.csv`.
6. (Optional) Run `R_file/Metrics_correlation.R` to produce correlation plots from the CSV outputs.

## Reproducibility & housekeeping suggestions

- Add a `.gitignore` with:
  ```
  .DS_Store
  results/
  *.log
  ```
  to avoid committing OS artifacts and temporary output.
- Remove `.DS_Store` from the repository and avoid further commits of that file.
- If you want deterministic, non-interactive runs for automation, add a small wrapper script (Octave or shell) that sets input/output variables and calls the main functions directly.

## Contributing

Contributions are welcome. Suggested workflow:
1. Fork the repository.
2. Create a feature branch (e.g., feature/readme-update).
3. Run analysis scripts locally and update documentation as needed.
4. Open a Pull Request describing the change and rationale.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Contact / Issues

Open issues in this repository to request features, report bugs, or ask for help. Include:
- Steps to reproduce
- The input dataset used (or a small sample)
- The exact Octave/R command you ran and any error messages or logs