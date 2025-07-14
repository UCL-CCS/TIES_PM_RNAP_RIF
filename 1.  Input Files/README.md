# Input Files

This directory contains the input files used for the TIES-PM workflow, organized into three main stages:

1. Preparation  
2. Calculation  
3. Post-processing

---

## 1. Preparation

This folder includes all necessary files prepared prior to running the simulations. It contains:

- Example configurations for hybrid amino acids
- Input files for the wild-type system
- A file named `modeling`, which demonstrates the automated process of building all files required for calculation

---

## 2. Calculation

This folder provides an example of the file and directory structure used during actual HPC simulations. It includes:

- `submission.sh`: Sample job submission script for the Polaris supercomputer
- `com/` and `prot/`: Contain lambda window and replica subdirectories
- `replica-confs/`: Core configuration files for both `com` (complex) and `prot` (apo) systems, which define lambda schemes and replica settings for TIES-PM

---

## 3. Post-processing

This folder contains scripts and templates used to process simulation outputs and compute ΔΔG values.

- `auto_post0.sh`: Main automation script for free energy analysis
- `analysis_scripts/`: Supporting scripts for energy extraction, overlap calculation, and final ΔΔG estimation

---
