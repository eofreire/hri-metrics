# Load required libraries
library(readr)
library(dplyr)
library(boot)
library(ggcorrplot)
library(ggplot2)

# Function to compute Kendall's tau for bootstrap
kendall_stat <- function(data, indices) {
  d <- data[indices, ]
  cor(d[, 1], d[, 2], method = "kendall")
}

# Modified function to analyze correlation with bootstrap CI
analyze_correlation <- function(data, var_names, dataset_name) {
  options(digits = 4)
  colnames(data) <- var_names
  
  # Compute Kendall correlation matrix
  cor_kendall <- cor(data, method = "kendall")
  
  # Plot
  plot_kendall <- ggcorrplot(cor_kendall,
                             lab = TRUE,
                             lab_size = 3.5,
                             digits = 3,
                             type = "lower",
                             title = paste("Kendall Correlation -", dataset_name))
  print(plot_kendall)
  ggsave(paste0("correlation_", dataset_name, ".png"), plot_kendall, width = 8, height = 6)
  
  # Output file with bootstrap CI
  sink(paste0("CI_and_pvalues_", dataset_name, ".txt"))
  cat(paste0("\nStatistical Summary - ", dataset_name, "\n"))
  cat("========================================\n")
  
  for (i in 1:(ncol(data)-1)) {
    for (j in (i+1):ncol(data)) {
      # Standard correlation test
      test <- cor.test(data[[i]], data[[j]], method = "kendall")
      
      # Bootstrap CI with error handling
      boot_results <- boot(data = data.frame(data[[i]], data[[j]]), 
                           statistic = kendall_stat, 
                           R = 1000)
      
      # Try to get BCa CI, fall back to percentile if BCa fails
      ci <- tryCatch({
        boot.ci(boot_results, type = "bca")
      }, error = function(e) {
        tryCatch({
          boot.ci(boot_results, type = "perc")
        }, error = function(e) {
          list(percent = c(NA, NA, NA, NA, NA))
        })
      })
      
      cat(paste0("\n", var_names[i], " vs ", var_names[j], "\n"))
      cat("Kendall's Tau: ", round(test$estimate, 4), "\n")
      
      # Print appropriate CI based on what's available
      if (!is.null(ci$bca)) {
        cat("95% CI (BCa): [", round(ci$bca[4], 4), ", ", round(ci$bca[5], 4), "]\n")
      } else if (!is.null(ci$percent)) {
        cat("95% CI (percentile): [", round(ci$percent[4], 4), ", ", round(ci$percent[5], 4), "]\n")
      } else {
        cat("95% CI: Could not be calculated\n")
      }
      
      cat("p-value: ", format.pval(test$p.value, digits=4), "\n")
    }
  }
  sink()
}

# Function to analyze by referent
analyze_gesture_by_referent <- function(data) {
  if (!dir.exists("gesture_results")) dir.create("gesture_results")
  
  referents <- unique(data$Referent_ID)
  
  for (ref in referents) {
    ref_data <- data %>% 
      filter(Referent_ID == ref) %>% 
      select(CONT, POP, GOR, VOR, ORT, IL)
    
    if (nrow(ref_data) > 1) {
      analyze_correlation(ref_data, 
                          c("CONT", "POP", "GOR", "VOR", "ORT", "IL"), 
                          paste0("Gesture_Referent_", ref))
      # Move files to results folder
      file.rename(paste0("correlation_Gesture_Referent_", ref, ".png"),
                  paste0("gesture_results/correlation_Gesture_Referent_", ref, ".png"))
      file.rename(paste0("CI_and_pvalues_Gesture_Referent_", ref, ".txt"),
                  paste0("gesture_results/CI_and_pvalues_Gesture_Referent_", ref, ".txt"))
    }
  }
}

# Data reading
cat("Select the GESTURE metrics file (CSV format)\n")
gesture_file <- file.choose()
gesture_data <- read_delim(gesture_file, delim = ";", 
                           col_names = c("Referent_ID", "Gesture_ID", "CONT", "POP", "GOR", "VOR", "ORT", "IL"),
                           show_col_types = FALSE)

# Analysis by referent
analyze_gesture_by_referent(gesture_data)

# Vocabulary processing
cat("\nSelect the VOCABULARY metrics file (CSV format)\n")
vocab_file <- file.choose()
vocab_data <- read_delim(vocab_file, delim = ";", 
                         col_names = c("ID", "POP", "Max_Con", "CDR", "Gamma", "Tau_0", "AR_Jac", "AR_Sor", "AR_Over"),
                         show_col_types = FALSE)

vocab_metrics <- vocab_data %>% select(-ID)
analyze_correlation(vocab_metrics, colnames(vocab_metrics), "Vocabulary_Metrics")

cat("\nAnalysis complete!\n")
cat("- Gesture results saved in 'gesture_results/' folder\n")
cat("- Vocabulary results saved in original files\n")