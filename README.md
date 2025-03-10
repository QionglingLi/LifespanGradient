# Spatiotemporal dynamics of human cortical functional hierarchy across the lifespan
This repository provides data and relevant codes & toolbox used in our paper ''

## Datasets
The MRI dataset are partly available at the [Adolescent Brain Cognitive Development Study](https://nda.nih.gov/), the [Autism Brain Imaging Data Exchange Initiative](https://fcon_1000.projects.nitrc.org/indi/abide/),
the [Alzheimer’s Disease Neuroimaging Initiative](https://adni.loni.usc.edu/), the [Age_ility Project](https://www.nitrc.org/projects/age-ility), the [Baby Connectome Project](https://nda.nih.gov/),
the [Brain Genomics Superstruct Project](https://doi.org/10.7910/DVN/25833), the [Calgary Preschool MRI Dataset](https://osf.io/axz5r/), the [Cambridge Centre for Ageing and Neuroscience Dataset](https://www.cam-can.org/index.php?content=dataset),
the [Developing Human Connectome Project](http://www.developingconnectome.org/data-release/second-data-release/), the [Human Connectome Project](https://www.humanconnectome.org), the [Lifespan Human Connectome Project](https://nda.nih.gov/), the [Nathan Kline Institute-Rockland Sample Dataset](https://fcon_1000.projects.nitrc.org/indi/pro/nki.html), the [Neuroscience in Psychiatry Network Dataset](https://nspn.org.uk/), the [Pediatric Imaging, Neurocognition, and Genetics (PING) Data Repository](http://pingstudy.ucsd.edu/),
the [Pixar Dataset](https://openfmri.org/dataset/ds000228/), the [Strategic Research Program for Brain Sciences (SRPBS) MRI Dataset](https://bicr-resource.atr.jp/srpbsopen/), the [Southwest University Adult Lifespan Dataset](http://fcon_1000.projects.nitrc.org/indi/retro/sald.html), the [Southwest University Longitudinal Imaging Multimodal Brain Data Repository](http://fcon_1000.projects.nitrc.org/indi/retro/southwestuni_qiu_index.html), and the [UK Biobank Brain Imaging Dataset](https://www.ukbiobank.ac.uk/).

The dhcpSym surface atlases in aged from 32 to 44 postmenstrual weeks is available at https://brain-development.org/brain-atlases/atlases-from-the-dhcp-project/cortical-surface-template/. The UNC 4D infant cortical surface atlases are available at https://www.nitrc.org/projects/infantsurfatlas/. The fs_LR_32k surface atlas is available at https://balsa.wustl.edu/. The NeuroSynth database is available at https://neurosynth.org.

The rigorous quality control framework can be found [here](https://github.com/sunlianglong/BrainChart-FC-Lifespan/blob/main/QC/README.md).
More detailed QC and preprocessing procedures can be found in [our prior study](https://www.biorxiv.org/content/10.1101/2023.09.12.557193v3.full).

The vertex-wise FC matrices are upon requested to yong.he@bnu.edu.cn.

## Dependencies
Software packages used in this work include [Connectome Workbench v1.5.0](https://www.humanconnectome.org/software/connectome-workbench), [MATLAB R2018b](https://www.mathworks.com/products/matlab.html), [cifti-matlab toolbox v2](https://github.com/Washington-University/cifti-matlab), [GAMLSS package v5.4-3](https://www.gamlss.com/), [Spyder v4.0](https://www.spyder-ide.org/), [Python v3.7](https://www.python.org), [R v4.4.1](https://www.r-project.org), [NbClust package](https://www.rdocumentation.org/packages/NbClust/versions/3.0.1/topics/NbClust), [BrainSpace toolbox v0.1.10](https://github.com/MICA-MNI/BrainSpace), [PAGANI toolbox v1.5](https://www.nitrc.org/projects/pagani_toolkit/), [neuromaps toolbox v0.0.5](https://github.com/netneurolab/neuromaps), [BrainStat toolbox v0.4.2](https://github.com/MICA-MNI/Brainstat), [SurfStat toolbox](https://mica-mni.github.io/surfstat/), [plotSurfaceROIBoundary](https://github.com/StuartJO/plotSurfaceROIBoundary), and [NeuroSynth meta-analysis code](https://github.com/NeuroanatomyAndConnectivity/gradient_analysis). 

Please use the “add path” in MATLAB, "install.packages()" in R, and "pip install" in Python to add toolboxes and packages in the enviroment.

## [Functional connectome gradient analysis](#https://github.com/QionglingLi/LifespanGradient/tree/main/codes/First_GradientAnalysis)
**1. gradients computation**  
   The functional connectome gradients were computed using the [BrainSpace toolbox v0.1.10](https://github.com/MICA-MNI/BrainSpace) based on the vertex-wise functional connectome matrix.
   
**2. gradients alignment**  
   These gradients were iteratively aligned using the Procrustes rotation. We identified the correspondence between the original gradients and the aligned ones based on the largest values of the final transformation matrices ([Xia et al. Molecular Psychiatry 2022](https://github.com/mingruixia/MDD_ConnectomeGradient/blob/main/0_GradientCalculation/a_analysis_pipeline.m)).

**3. clustering**  
   The age-specific group-level functional gradients were categorized into different stages using K-means clustering. The optimal cluster number was determined based on a winner-take-all approach based on thiry indices using the [NbClust package](https://www.rdocumentation.org/packages/NbClust/versions/3.0.1/topics/NbClust).  

**4. visulization**  
   The gradient maps were shown using the SurfStatViewData function from [SurfStat toolbox](https://mica-mni.github.io/surfstat/). The distinct stages of the gradient were shown using multidimensional scaling. Distribution of gradient score along S-A axis across the lifespan was shown using [Plot_gradient_ridges.R](https://github.com/QionglingLi/LifespanGradient/blob/main/codes/First_GradientAnalysis/Plot_gradient_ridges.R).


## Growth pattern of the gradient
   
## Functional segregation-integration
   
## Structural hierarchies

## Cognitive spectrum

## Sensitivity analysis

## Citation

## Contact
Any question, please contact qiongling0212@126.com
