
# Tree Model for Lithium-ion Battery Lifetime Prediction

This repository contains MATLAB implementations for lithium-ion battery lifetime prediction based on tree model using several widely used public datasets. The code provides a simple pipeline for reproducing prediction results on different datasets using pre-extracted features.

## Supported Datasets

The repository includes experiments conducted on three commonly used battery lifetime datasets:

- **MIT–Stanford Dataset**
- **HUST Dataset**
- **XJTU Dataset**

## Data Organization

All extracted features and labels are stored in **Excel format** and placed in the following directory:

```

src/
├── data/
│    ├── MIT_feature.xlsx
│    └── mit_label.xlsx
│    ├── hust_feature.xlsx
│    └── hust_label.xlsx
│    ├── xjtu_feature.xlsx
│    ├── xjtu_label.xlsx
|    ├── ...
├── cv_compare_MIT.m
├── cv_compare_hust.m
├── cv_compare_xjtu.m
├── ...

````

Each Excel file contains:

- **Features**: extracted battery health indicators used as model inputs  
- **Labels**: corresponding battery lifetime values

## Running the Experiments

To reproduce the lifetime prediction results, simply run the corresponding MATLAB scripts:

### MIT–Stanford Dataset

```matlab
cv_compare_MIT.m
````

### HUST Dataset

```matlab
cv_compare_hust.m
```

### XJTU Dataset

```matlab
cv_compare_xjtu.m
```

Each script performs experiments following the original data split and outputs the lifetime prediction results.

## Requirements

* MATLAB (recommended version: R2020a or later)

## Notes

* The repository assumes that all feature and label files are already prepared and placed under `src/data`.
* No additional preprocessing is required before running the scripts.

