# TIES_PM_RNAP_RIF

This repository contains all input files, output data, and processed results used in the study:

**"Rapid, accurate and reproducible de novo prediction of resistance to antituberculars"**

The TIES-PM simulations were primarily executed on the Polaris High-Performance Computing (HPC) platform, with additional analysis performed on local machines. The data provided here allows for inspection, reproduction, and further exploration of our molecular simulation-based resistance prediction approach.

---

## Repository Structure

The repository is organized into three main directories:

### 1. Input Files (`1_Input_files/`)

Contains all files required to set up and run the TIES-PM workflow. It is divided into three parts:

- **Preparation**: Example inputs for wild-type and hybrid residues, along with an automated pipeline (`modeling`) to generate simulation-ready structures.
- **Calculation**: A sample directory structure and configuration files (`replica-confs`) for both `com` (complex) and `prot` (apo protein), along with a job submission script for Polaris.
- **Post-processing**: Scripts for analyzing simulation outputs and computing free energy changes, including an automated analysis pipeline (`auto_post0.sh`) and support scripts.

### 2. Output Files (`2_Output_files/`)

Provides a complete example of raw simulation outputs for the mutation **V170F**, demonstrating the directory structure used in TIES-PM:

- Each of `com/` and `prot/` contains 13 lambda windows.
- Each lambda window includes 5 replicas.
- The `sim1.alch` files from each replica are the key inputs for ΔΔG calculation.

### 3. Results (`3_Results/`)

Contains all processed free energy results from the TIES-PM workflow. The main results file includes:

- ΔG and ΔΔG values with associated statistical errors
- Mutation classification (Resistant/Susceptible)
- Comparison to experimental annotations (e.g., WHO phenotype, CRyPTIC data)
- Metadata such as sample counts and resistance proportions

Each column in the results file is explained in detail in the corresponding `README.md` file within the `3_Results/` directory.

---

## Usage

Users interested in replicating or extending this work should:

- Review the input structure in `1_Input_files/` and adapt templates for their own systems;
- Use the provided output example in `2_Output_files/` to understand the lambda/replica setup;
- Refer to `3_Results/` for analysis outputs and validation against reference datasets.

The workflow is compatible with other HPC platforms with minor adjustments. Detailed automation and analysis scripts are included or available upon request.

---

## Citation

If you use the data or structure of this repository, please cite our paper:

> [here](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=5166252)

---

For further questions or collaborations, please contact:  
**xxxxxx.zhang.23@ucl.ac.uk**

