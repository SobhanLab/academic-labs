# Adaptive Slope-Based R-Peak Detection in Multi-Activity Chest-Strap ECG Signals

A MATLAB/Simulink implementation and experimental evaluation of an
adaptive slope-based R-peak detector for chest-strap ECG recordings
collected under multiple activity conditions.

**Author:** Abdus Sobhan\
**Affiliation:** Department of Computer Science and Engineering,
Varendra University, Rajshahi, Bangladesh

<a href="https://doi.org/10.5281/zenodo.24373828" target="_blank" rel="noopener noreferrer"><img src="https://zenodo.org/badge/DOI/10.5281/zenodo.24373828.svg" alt="DOI"></a>

## Overview

This project presents an adaptive slope-based framework for detecting
R-peaks in wearable chest-strap electrocardiogram (ECG) signals. The
detector was implemented and evaluated in a discrete-time
MATLAB/Simulink environment using the ECG-GUDB dataset.

The study focuses on how four adaptive threshold configurations perform
across recordings collected under different activities. In addition to
pooled detection metrics, the evaluation includes activity-wise and
subject-wise analyses, recording-level results, timing-error analysis,
false-positive/false-negative analysis, and sensitivity to temporal
matching tolerance.

The repository contains the project scripts and research materials
available in this release. The dataset itself is not included; see
[Dataset](#dataset).

## Main Features

-   Adaptive slope-based R-peak detection.
-   Digital filtering and derivative-based slope extraction.
-   Absolute-slope processing and moving-average integration.
-   Rolling-buffer adaptive thresholding using maximum and percentile
    statistics.
-   Local peak refinement that accommodates positive and negative ECG
    peak polarity.
-   Comparison of four threshold configurations.
-   Evaluation across 123 annotated recordings from 25 participants and
    five activities.
-   Record-level, activity-wise, subject-wise, timing-error, and
    tolerance-sensitivity analyses.

## Dataset

The experiments use the **ECG-GUDB** dataset, described as a
high-precision ECG database with annotated R-peaks recorded under
realistic conditions.

-   **Dataset:** ECG-GUDB
-   **Original dataset publication:** L. Howell and B. Porr, *High
    precision ECG database with annotated R peaks, recorded and filmed
    under realistic conditions* (2018).
-   **Dataset download (Zenodo):**
    <a href="https://zenodo.org/records/10925903" target="_blank" rel="noopener noreferrer">Download ECG-GUDB dataset</a>
-   **Original dataset DOI:**
    <a href="https://doi.org/10.5525/gla.researchdata.716" target="_blank" rel="noopener noreferrer">10.5525/gla.researchdata.716</a>
-   **Dataset access:** Use the Zenodo link above to access and download
    the dataset. The original dataset DOI is retained for source attribution.

The study used 123 annotated chest-strap ECG recordings from 25
participants (S00--S24). The five activity conditions were **sitting,
walking, maths, jogging, and hand biking**. Two subject--activity
combinations were not included because annotations were unavailable.

Each recording contains 30,000 samples at 250 Hz (approximately 120
seconds). Reference R-peak locations were taken from the chest-strap
annotation file, `annotation_cs.tsv`. Cable ECG annotations were not
used.

**The dataset is not redistributed in this repository.** Obtain it from
its official source and follow the provider's access conditions,
license, and citation requirements.

## Detection Method

The proposed processing pipeline consists of the following stages:

1.  **High-pass filtering:** Second-order Butterworth high-pass filter
    with a 0.5 Hz cutoff.
2.  **Bandpass filtering:** Second-order Butterworth bandpass filter
    with 10--30 Hz cutoff frequencies.
3.  **Derivative calculation:** Differentiation of the filtered signal
    to obtain slope information.
4.  **Absolute-slope processing:** Absolute value of the derivative to
    represent slope magnitude.
5.  **Moving-average integration:** 20-sample moving-average window (80
    ms at 250 Hz).
6.  **Adaptive thresholding:** A rolling reference buffer of 1,500
    samples (6 seconds) is used to calculate an adaptive threshold.
7.  **Candidate detection:** A minimum separation of 50 samples (200 ms)
    is enforced between consecutive candidates.
8.  **Local peak refinement:** A localization signal is low-pass
    filtered at 40 Hz; a ±15-sample search window is used to refine each
    candidate by selecting the largest positive or negative deviation
    from the local median.

### Threshold Configurations

Four reference-statistic configurations were evaluated. In each case,
the detection threshold was set to 35% of the selected rolling-buffer
statistic.

  Configuration      Rolling-buffer reference statistic
  ------------------ ------------------------------------
  Original Maximum   Maximum value
  Percentile 90      90th percentile
  Percentile 92.5    92.5th percentile
  Percentile 95      95th percentile

The Original Maximum configuration was treated as the primary
configuration in the study.

## Experimental Setup

-   **Environment:** MATLAB/Simulink R2024b (24.2.0.2712019)
-   **Simulation architecture:** Discrete-time, fixed-step solver
-   **Sampling frequency:** 250 Hz
-   **Sample interval:** 0.004 seconds
-   **Samples per recording:** 30,000
-   **Recordings:** 123
-   **Participants:** 25
-   **Activities:** 5
-   **Primary matching tolerance:** 48 ms (12 samples)

Detected and reference peaks were compared using chronological
one-to-one temporal matching. Each detection and reference annotation
could be matched only once. Matching was performed independently for
each recording before counts were aggregated.

## Main Results

At the primary matching tolerance of 48 ms, the four configurations
achieved the following pooled results:

  ---------------------------------------------------------------------------------------
  Threshold               TP         FP         FN    Precision   Recall (%) F1-score (%)
  configuration                                             (%)              
  --------------- ---------- ---------- ---------- ------------ ------------ ------------
  **Original          22,518        625        704   **97.299**       96.968   **97.134**
  Maximum**                                                                  

  Percentile 90       22,579      3,941        643       85.140       97.231       90.784

  Percentile 92.5     22,670      2,677        552       89.439       97.623       93.352

  Percentile 95       22,760      1,644        462       93.263   **98.011**       95.578
  ---------------------------------------------------------------------------------------

The **Original Maximum** configuration achieved the highest overall
F1-score (97.134%) among the four evaluated configurations. The
**Percentile 95** configuration achieved the highest recall (98.011%),
but also produced more false positives than the Original Maximum
configuration.

### Additional Findings

-   The Original Maximum configuration achieved the highest
    activity-wise F1-score in each of the five activity categories.
-   Its mean subject-wise F1-score was 96.83% (median 97.32%; standard
    deviation 2.67 percentage points).
-   The highest subject-wise F1-score was 99.34% for S12; the lowest was
    88.05% for S07.
-   For 22,518 matched detection--reference pairs, mean signed timing
    error was +20.14 ms, median error was +12 ms, and mean absolute
    error was 20.23 ms.
-   The study also examined requested matching tolerances of 4, 10, 25,
    48, 50, and 100 ms. At 250 Hz, these corresponded to effective
    tolerances of 4, 12, 24, 48, 52, and 100 ms, respectively.

These results are specific to the ECG-GUDB recordings and evaluation
protocol described in the manuscript. They do not establish
generalization to unseen participants or external datasets.

## Repository Structure

``` text
.
├── Final_Research_Experiment/
│   ├── 01_Frozen_Model/
│   ├── 02_Configuration/
│   ├── 03_Raw_Detection_Outputs/
│   ├── 04_Record_Level_Results/
│   ├── 05_Overall_Performance/
│   ├── 06_Activity_Analysis/
│   ├── 07_Subject_Analysis/
│   ├── 08_Timing_Error_Analysis/
│   ├── 09_FP_FN_Error_Analysis/
│   ├── 10_Statistical_Analysis/
│   ├── 11_Baseline_Comparison/
│   ├── 12_Figures/
│   ├── 13_Tables/
│   └── 14_Reproducibility/
├── ECG_GUDB_RPeak_Detector_Frozen.slxc
├── GENERATE_ALL_ECG_GUDB_FIGURES.m
├── RUN_FINAL_123_RECORD_4_VARIANT_EXPERIMENT.m
├── Manuscript.pdf
└── README.md
```

The folders are organized by model/configuration, raw and record-level
outputs, performance analyses, figures, tables, and reproducibility
materials. The exact files present in each folder depend on the current
repository release.

> **Simulink note:** The screenshot of the project directory shows
> `ECG_GUDB_RPeak_Detector_Frozen.slxc`, which is a Simulink cache file.
> If the editable `.slx` model exists, include it in the repository as
> the model source. A cache file is not a substitute for the editable
> model and is generally regenerable.

## Requirements

-   MATLAB/Simulink R2024b was used for the experiments reported in the
    manuscript.
-   Additional MATLAB toolboxes or dependencies may be required by the
    model and scripts. Check the files and MATLAB installation for the
    exact dependencies.

## Running the Project

1.  Clone or download this repository.

2.  Download ECG-GUDB from Zenodo:
    <a href="https://zenodo.org/records/10925903" target="_blank" rel="noopener noreferrer">Download ECG-GUDB dataset</a>.
    The original dataset DOI is
    <a href="https://doi.org/10.5525/gla.researchdata.716" target="_blank" rel="noopener noreferrer">10.5525/gla.researchdata.716</a>.

3.  Place the dataset where the project configuration expects it, or
    update the relevant dataset paths.

4.  Open MATLAB and set the repository directory as the working
    directory.

5.  Review the configuration and confirm that required MATLAB/Simulink
    dependencies are available.

6.  Run the experiment script:

    ``` matlab
    RUN_FINAL_123_RECORD_4_VARIANT_EXPERIMENT
    ```

7.  Generate the figures using:

    ``` matlab
    GENERATE_ALL_ECG_GUDB_FIGURES
    ```

Check the scripts for expected input paths and output locations before
running. The commands above assume the filenames and folder layout have
not changed.

## Research Paper

**Adaptive Slope-Based R-Peak Detection in Multi-Activity Chest-Strap
ECG Signals**

-   **Zenodo archive:** <a href="https://zenodo.org/records/24373828" target="_blank" rel="noopener noreferrer">https://zenodo.org/records/24373828</a>
-   **DOI:** <a href="https://doi.org/10.5281/zenodo.24373828" target="_blank" rel="noopener noreferrer">https://doi.org/10.5281/zenodo.24373828</a>
-   **ResearchGate:**
    <a href="https://www.researchgate.net/publication/418163500_Adaptive_Slope-Based_R-Peak_Detection_in_Multi-Activity_Chest-Strap_ECG_Signals" target="_blank" rel="noopener noreferrer">https://www.researchgate.net/publication/418163500_Adaptive_Slope-Based_R-Peak_Detection_in_Multi-Activity_Chest-Strap_ECG_Signals</a>

The manuscript provides the full methodology, experimental protocol,
results, discussion, limitations, and references.

### Citation

Sobhan, A. *Adaptive Slope-Based R-Peak Detection in Multi-Activity
Chest-Strap ECG Signals*. Zenodo.
<a href="https://doi.org/10.5281/zenodo.24373828" target="_blank" rel="noopener noreferrer">https://doi.org/10.5281/zenodo.24373828</a>

## Limitations

The study was limited to the ECG-GUDB dataset and its 123 annotated
recordings from 25 participants. It did not include independent
subject-level validation or external-dataset validation. The detector
was not directly benchmarked against established QRS detection
algorithms under the same experimental conditions. Performance also
depends on the selected temporal matching tolerance.

Accordingly, further validation with independent participants and
external ECG datasets is required. The study did not evaluate clinical
diagnostic applications or downstream heart-rate-variability analysis.

## Intended Use

This repository is intended for academic and research purposes. The
implementation is an experimental signal-processing framework, not a
certified medical device, and must not be used as a substitute for
professional medical assessment or clinical decision-making.

## Author

**Abdus Sobhan**\
Department of Computer Science and Engineering\
Varendra University, Rajshahi, Bangladesh

### Research Profiles

-   **Google Scholar:**
    <a href="https://scholar.google.com/citations?hl=en&user=fZC_B7wAAAAJ" target="_blank" rel="noopener noreferrer">https://scholar.google.com/citations?hl=en&user=fZC_B7wAAAAJ</a>
-   **ORCID:** <a href="https://orcid.org/0009-0009-5139-1172" target="_blank" rel="noopener noreferrer">https://orcid.org/0009-0009-5139-1172</a>
