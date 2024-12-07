# hri_metrics

**Gesture Analysis in Octave**

This Octave project processes gesture data to generate descriptive metrics and analysis reports for human-machine interaction studies. The script performs calculations based on user-selected gesture data, allowing researchers to assess patterns and consensus within participant-proposed gestures.

**Features**

Data Selection: Interactive file selection for gesture data in .csv format with columns for referents, participants, and gesture IDs.

Metrics Calculation:
  * Calculates occurrence rates, intuitiveness levels, and consensus across gestures by referent and participant.
  * Supports multiple metrics such as General Occurrence Rate (GOR), Overall Occurrence Rate (OOR), and Participant Occurrence Rate (VOR).
  * Includes calculations for Guessability and Consensus-Distinct Ratio (CDR) based on user input.

Customizable Output:
  * Prompts the user for an output folder to store results.
  * Provides an option to overwrite existing output folders.
  * Generates a summary report and a contingency table file in the chosen output folder.

**Requirements**

  * Software: Octave (version 9.1 or higher)
  * Libraries: No additional libraries required.

**Usage**

1. Run the Script: Execute the script in Octave using run or by loading it directly directly into the workspace.
2. Select Input Data: Upon execution, select a .csv file containing gesture data (columns: Referent, Participant, Gesture ID).
3. Optional Guessability Calculation: The script will prompt you to decide if you want to perform the Guessability calculation. If you opt for this, you will be prompted to enter the selected gesture(s) for each referent.
4. Choose Output Folder: Specify a folder for saving output data, including a gesture summary report and contingency table.

**Output**

The script generates:
  * gesture_summary_report.txt: Contains statistical summaries of gestures across participants and referents.
  * contingency_table.csv: A contingency table capturing gesture occurrences by referent and participant.

**Metrics Description**

  * GOR (General Occurrence Rate): Measures the frequency of gestures by referent
  * OOR (Overall Occurrence Rate): Calculates overall gesture occurrence across all participants
  * VOR (Participant Occurrence Rate): Tracks gesture occurrence specific to participants
  * Intuitiveness Level (IL): Averages OOR, VOR, and GOR to assess gesture intuitiveness
  * Consensus (Cr): Measures consensus across different referent-gesture pairs based on selected criteria
  * Popularity: Weighted by gesture occurrence rates, indicating gesture popularity
  * CDR (Consensus-Distinct Ratio): Evaluates distinctiveness and consensus of gestures based on a threshold
  * Guessability: Calculates the likelihood of gesture adoption, based on participant feedback

**Custom Functions**

This project depends on several custom functions defined within the script:
  * gor_func: Calculates General Occurrence Rate.
  * oor_func: Computes Overall Occurrence Rate.
  * vor_func: Determines Participant Occurrence Rate.
  * cdr_func: Calculates the Consensus-Distinct Ratio.
  * Additional functions for consensus measurements (median, minimum, maximum) and guessability.

**NOTE:**

Three values of Intuitiveness Level are calculated:
  *	IL: Calculated as the arithmetic mean of GOR, VOR, and OOR values (without normalization).
  *	ILN: Calculated as the arithmetic mean of GOR, VOR, and OOR values with max-normalization.
  *	ILN1: Calculated as the arithmetic mean of GOR, VOR, and OOR values with min-max normalization.

In the paper, ILN (max-normalization) was used for individual gesture metrics, while for Vocabulary Metrics analysis, the maximum IL (without normalization) per referent was assigned as the IL_R value.

**License**

This project is licensed under the MIT License. See the LICENSE file for details.

**Example Dataset**

An example dataset, titled **FBA_gestures.csv**, is provided for testing purposes. This dataset originates from the study by Canuto, C., Freire, E. O., Molina, L., Carvalho, E. A., & Givigi, S. N. (2022), titled Intuitiveness Level: Frustration-Based Methodology for Human–Robot Interaction Gesture Elicitation, published in IEEE Access, Volume 10, pages 17145-17154.
