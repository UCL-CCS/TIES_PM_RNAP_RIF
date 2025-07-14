# Results

This directory contains all processed results from the TIES-PM free energy calculations.

Each row in the main results file corresponds to a single mutation and includes detailed thermodynamic values, classification outcomes, and comparisons to experimental or reference data sources.

---

## Column Descriptions

- `Name_1`: Name of the mutation (as commonly referred to in the literature).
- `Name_2`: Internal mutation name used in our simulation system. Due to a residue index offset of 430 in our protein model, this value differs from `Name_1`.
- `dG-complex`: Binding free energy (ΔG) computed for the **complex** system.
- `error_c`: Statistical error associated with `dG-complex`.
- `dG-protein`: Binding free energy (ΔG) computed for the **apo protein** system.
- `error_p`: Statistical error associated with `dG-protein`.
- `ddG`: Final computed ΔΔG value (difference between complex and protein ΔG).
- `error`: Overall statistical error of the ΔΔG value.
- `err_95`: Error corresponding to the 95% confidence interval.
- `R/S`: Classification based on ΔΔG threshold—**R** for resistant, **S** for susceptible.
- `REF`: Reference classification based on external experimental data.
- `SOLO_SR`: Total number of individual samples (SOLO entries) with resistance-related annotations.
- `SOLO_R`: Number of SOLO samples classified as resistant.
- `SOLO_S`: Number of SOLO samples classified as susceptible.
- `Validation_R_rate`: Proportion of SOLO samples showing resistance (`SOLO_R / SOLO_SR`).
- `WHO`: WHO-derived phenotype classification based on the mutation.
- `WHO_original`: Additional WHO-provided metadata (e.g., whether the mutation lies in the RRDR region).
- `WHO_final`: Final phenotype classification according to WHO criteria.

---

## Notes

- ΔG values are reported in kcal/mol.
- Classifications are based on a thermodynamically informed ΔΔG threshold.
- The data can be used to assess the consistency between computed predictions and experimental or public health annotations (e.g., WHO or CRyPTIC).

For interpretation of ΔΔG thresholds and classification methodology, refer to the main repository README and our publication.
