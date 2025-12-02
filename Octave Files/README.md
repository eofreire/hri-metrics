# Octave Files

Purpose
This folder contains the Octave code that performs the core gesture-metrics computations and generates CSV/text reports.

Main entry points
- `hri_metrics.m` — Primary interactive/scriptable analysis driver. Prompts for input CSV, guessability option, and output folder.
- `gesture_metrics_eval.m` — Evaluation/visualization driver (creates correlation tables and displays them).

Helper functions
Key helper functions used by the entry scripts (not exhaustive):
- `gor_func.m` — General Occurrence Rate
- `ort_func.m` — Occurrence Rate by Time
- `vor_func.m` — Participant Occurrence Rate
- `cdr_func.m` — Consensus‑Distinct Ratio
- `display_table.m` — Display correlation/consensus matrices (visual)
- `consensus_func.m`, `contingency_func.m`, `guess_func.m`, `select_or_create_folder.m`, `calculate_DIM.m`, `norm.m`, etc.

Input
- Use CSV files with at least: Referent, Participant, Gesture ID columns.
- Example dataset: `FBA_gestures.csv` (included in this folder).

Usage examples
Interactive (recommended):
1. Start Octave and change directory:
   cd('Octave Files')
2. Run the main script:
   run('hri_metrics.m')

Non-interactive script example (wrap the main code to pass arguments programmatically):
- Inspect the top of `hri_metrics.m` to see the variables to set (input path, output path, guessability flag), then create a small wrapper.

Outputs
- gesture_summary_report.txt
- contingency_table.csv
- per-referent gesture metrics CSVs (e.g. `referent_*_gesture_metrics.csv`)
- other intermediate CSVs with GOR / ORT / VOR / IL / CDR values

Notes
- Ensure Octave’s current directory or path includes this folder so helper functions are found.
- See root `README.md` for overall project context and links to R scripts.