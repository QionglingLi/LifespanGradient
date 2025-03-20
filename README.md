# Spatiotemporal dynamics of human cortical functional hierarchy across the lifespan

## Data
The MRI dataset are partly available at the [Adolescent Brain Cognitive Development Study](https://nda.nih.gov/), the [Autism Brain Imaging Data Exchange Initiative](https://fcon_1000.projects.nitrc.org/indi/abide/),
the [Alzheimer’s Disease Neuroimaging Initiative](https://adni.loni.usc.edu/), the [Age_ility Project](https://www.nitrc.org/projects/age-ility), the [Baby Connectome Project](https://nda.nih.gov/),
the [Brain Genomics Superstruct Project](https://doi.org/10.7910/DVN/25833), the [Calgary Preschool MRI Dataset](https://osf.io/axz5r/), the [Cambridge Centre for Ageing and Neuroscience Dataset](https://www.cam-can.org/index.php?content=dataset),
the [Developing Human Connectome Project](http://www.developingconnectome.org/data-release/second-data-release/), the [Human Connectome Project](https://www.humanconnectome.org), the [Lifespan Human Connectome Project](https://nda.nih.gov/), the [Nathan Kline Institute-Rockland Sample Dataset](https://fcon_1000.projects.nitrc.org/indi/pro/nki.html), the [Neuroscience in Psychiatry Network Dataset](https://nspn.org.uk/), the [Pediatric Imaging, Neurocognition, and Genetics (PING) Data Repository](http://pingstudy.ucsd.edu/),
the [Pixar Dataset](https://openfmri.org/dataset/ds000228/), the [Strategic Research Program for Brain Sciences (SRPBS) MRI Dataset](https://bicr-resource.atr.jp/srpbsopen/), the [Southwest University Adult Lifespan Dataset](http://fcon_1000.projects.nitrc.org/indi/retro/sald.html), the [Southwest University Longitudinal Imaging Multimodal Brain Data Repository](http://fcon_1000.projects.nitrc.org/indi/retro/southwestuni_qiu_index.html), and the [UK Biobank Brain Imaging Dataset](https://www.ukbiobank.ac.uk/).  

The dhcpSym surface atlases aged from 32 to 44 postmenstrual weeks is available at https://brain-development.org/brain-atlases/atlases-from-the-dhcp-project/cortical-surface-template/. The UNC 4D infant cortical surface atlases are available at https://www.nitrc.org/projects/infantsurfatlas/. The fs_LR_32k surface atlas is available at https://balsa.wustl.edu/. The NeuroSynth database is available at https://neurosynth.org.

The rigorous quality control framework can be found [here](https://github.com/sunlianglong/BrainChart-FC-Lifespan/blob/main/QC/README.md).
More detailed QC and preprocessing procedures can be found in [our prior study](https://www.biorxiv.org/content/10.1101/2023.09.12.557193v3.full).

For the main study, we provided the following data:  
**1. Subject information**: Subinfo.csv  
**2. Gradients for each age-specific group**: Gradient_GroupLevel.mat  
**3. Gradients for all individuals**: GradientValues_AllSub.mat  
**4. Fitted mean gradient scores for yeo's 7 networks**: Y_median_Gscore_sys.mat  
**5. Fitted growth of the S-A gradient**: Fitted_GradientValues.mat    
**6. Regional-level clustering coefficients for all individuals**: Cp_AllSub.mat  
**7. Fitted growth of the clustering coefficient for all vertices**: Fitted_Cp.mat  
**8. Regional-level path length for all individuals**: NodalEff_AllSub.mat  
**9. Fitted growth of the path length for all vertices**: Fitted_NodalEff.mat  
**10. Regional-level cortical thickness(fsaverage4) for all individuals**: CT_4k_AllSub.mat  
**11. Fitted growth of the cortical thickness for all vertices**: Fitted_CT.mat  
**12. Regional-level intracortical myelination(fsaverage4) for all individuals**: M_4k_AllSub.mat    
**13. Fitted growth of the intracortical myelination for all vertices**: Fitted_Myelin.mat    
**14. Neurosynth-based decoding results at the group-level**: decoding_results_group.zip  
**15. Neurosynth-based decoding results at the individual-level**: decoding_results_individual.zip

For the sensitivity analyses, we provided the following data:   
**16. Fitted growth of global gradient measures from main results and validation strategies**: [1]explanation ratio: Y_median_AEV1_all.mat; [2] gradient range: Y_median_ARange1.mat; [3] gradient variation: Y_median_Astd1.mat    
**17. Fitted growth of the system-level gradient range and variation from main results and validation strategies**: Y_median_Range_sys_[num].mat; Y_median_Std_sys_[num].mat  
**18. The peak age of gradient score for each functional system and each validation strategy**: PeakAgeIndex.mat  
**19. The Δ mean gradient score for each system and each validation strategy**: all_stage_y_stackedbar.mat  
**20. Fitted growth rate of all vertices from each validation strategy**: all_velocity.mat  
**21. The growth axes for gradient from validation strategies**: all_L1.mat  

## Dependencies
Software packages used in this work include [HCP pipeline v4.4.0-rc-MOD-e7a6af9](https://github.com/Washington-University/HCPpipelines/releases), [Connectome Workbench v1.5.0](https://www.humanconnectome.org/software/connectome-workbench), [MATLAB R2020b](https://www.mathworks.com/products/matlab.html), [cifti-matlab toolbox v2](https://github.com/Washington-University/cifti-matlab), [GAMLSS package v5.4-3](https://www.gamlss.com/), [Spyder v4.0](https://www.spyder-ide.org/), [Python v3.7](https://www.python.org), [R v4.4.1](https://www.r-project.org), [NbClust package v3.0.1](https://www.rdocumentation.org/packages/NbClust/versions/3.0.1/topics/NbClust), [BrainSpace toolbox v0.1.10](https://github.com/MICA-MNI/BrainSpace), [PAGANI toolbox v1.5](https://www.nitrc.org/projects/pagani_toolkit/), [neuromaps toolbox v0.0.5](https://github.com/netneurolab/neuromaps), [BrainStat toolbox v0.4.2](https://github.com/MICA-MNI/Brainstat), [SurfStat toolbox](https://mica-mni.github.io/surfstat/), [plotSurfaceROIBoundary v1.0.1](https://github.com/StuartJO/plotSurfaceROIBoundary), and [NeuroSynth meta-analysis code](https://github.com/NeuroanatomyAndConnectivity/gradient_analysis). 

Please use the “add path” in MATLAB, "install.packages()" in R, and "pip install" in Python to add toolboxes and packages in the enviroment.

## I. Functional connectome gradient analysis
**1. Gradients identification**  
   The functional connectome gradients were computed using the [BrainSpace toolbox v0.1.10](https://github.com/MICA-MNI/BrainSpace) based on the vertex-wise functional connectome matrix ([code](https://github.com/QionglingLi/LifespanGradient/blob/main/A_GradientAnalysis/Gradient_Analysis.m)).
   
**2. Gradients alignment**  
   These gradients were iteratively aligned using the Procrustes rotation. We identified the correspondence between the original gradients and the aligned ones based on the largest values of the final transformation matrices ([Xia et al. Molecular Psychiatry 2022](https://github.com/mingruixia/MDD_ConnectomeGradient/blob/main/0_GradientCalculation/a_analysis_pipeline.m)).

**3. Clustering**  
   The age-specific group-level functional gradients were categorized into different stages using K-means clustering([code](https://github.com/QionglingLi/LifespanGradient/blob/main/A_GradientAnalysis/Gradient_NbClust.R)). The optimal cluster number was determined based on a winner-take-all approach based on thiry indices using the [NbClust package v3.0.1](https://www.rdocumentation.org/packages/NbClust/versions/3.0.1/topics/NbClust).  

**4. Visulization**  
   The gradient maps were shown using the SurfStatViewData function from [SurfStat toolbox](https://mica-mni.github.io/surfstat/). The distinct stages of the gradient were shown using multidimensional scaling. Distribution of gradient score along S-A axis across the lifespan was shown using [Plot_gradient_ridges.R](https://github.com/QionglingLi/LifespanGradient/blob/main/A_GradientAnalysis/Plot_Gradient_Ridges.R).  

## II. Growth pattern of the gradient
**1. Individual gradients computation**  
   Individual gradients were computed from each participant’s functional connectome using the same procedure and were aligned to their corresponding age-specific group-level gradients, which has been iteratively aligned to the reference gradient ([code](https://github.com/QionglingLi/LifespanGradient/blob/main/B_GrowthPattern/Compute_Individal_Gradient.m)).

**2. Global-level analysis**  
   At the global level, the explanation ratio, range, and standard deviation for each individual functional gradient were computed ([code](https://github.com/QionglingLi/LifespanGradient/blob/main/B_GrowthPattern/Compute_Gradient_Measures.m)). 

**3. System-level analysis**   
   At the system level, we used the [age-specific Yeo 7-network atlas](https://github.com/sunlianglong/BrainChart-FC-Lifespan/tree/main/Age-specific_group_atlases) to assign cortical vertices to functional systems. The gradient range, standard deviation, and gradient scores for each functional system and each individual were computed. We sequentially removed each system and calculated the changes in the mean cortical gradient score (Δ mean gradient score) for each individual ([code](https://github.com/QionglingLi/LifespanGradient/blob/main/B_GrowthPattern/Compute_Gradient_Measures.m)). The repeated-measures analysis of variance on the Δ mean gradient score was used to assess variations in system contribution across different developmental phases ([code](https://github.com/QionglingLi/LifespanGradient/blob/main/B_GrowthPattern/Stat_system.m)).

**4. Regional-level analysis**  
   PCA was performed to the fitted growth curves of functional gradient across all vertices. The first PC referred to as the principal lifespan growth axis. The axis was divided into 20 decile bins and the average gradient scores and growth rates for all vertices within each bin were calculated ([code](https://github.com/QionglingLi/LifespanGradient/blob/main/B_GrowthPattern/Lifespan_Growth_Axis.m)). The cortical evolutionary hierarchy was obtained from the neuromaps dataset and downsampled to the fsaverage4 space using the [neuromaps toolbox v0.0.5](https://github.com/netneurolab/neuromaps).

**5. Building growth curves**  
   The lifespan growth curves of these measures were fitted using the GAMLSS model refered to [Sun et al., NN 2025](https://github.com/sunlianglong/BrainChart-FC-Lifespan/blob/main/Code/for-Normative-Modeling/GAMLSS_model_fitting.ipynb).

## III. Functional segregation-integration
**1. Graph theory measures computation**  
   The graph theoretical measures on voxel-wise brain networks were executed using the Parallel Graph-theoretical Analysis ([PAGANI toolbox v1.5](https://www.nitrc.org/projects/pagani_toolkit/)).
**2. Lifespan growth pattern analyses**  
The lifespan growth pattern of functional segregation and integration were characterized using the same procedures as the functional gradient at global and regional levels ([code](https://github.com/QionglingLi/LifespanGradient/blob/main/GrowthPattern/Lifespan_growth_axis.m)).

## IV. Structural hierarchies
**1.Geometric distance**  
The boundaries of cortical vertices with the top and bottom gradient values were highlighted on the cortical surface using [plotSurfaceROIBoundary v1.0.1](https://github.com/StuartJO/plotSurfaceROIBoundary). Geometric distance between any two vertices is computed as the shortest path between them on the triangle surface mesh using the wb_command -surface-geodesic-distance implemented in [Connectome Workbench v1.5.0](https://www.humanconnectome.org/software/connectome-workbench). The geometric distance was computed on the mid-thickness surface in the fsaverage_LR32k native space.

**2.Cortical thickness**  
The cortical thickness was computed between the white and pial surfaces in native space. For each vertex, the shortest distance of that vertex to any other vertex on the other surface was found. Those shortest distances from pial to white surface and from white to pial surface then averaged to compute the cortical thickness. This process was implemented in the [HCP pipeline v4.4.0-rc-MOD-e7a6af9](https://github.com/Washington-University/HCPpipelines/releases) The cortical thickness for each participant was resampled from native space to fsaverage_LR32k space and then to fsaverage4 space using [power tools](https://github.com/MICA-MNI/micaopen/blob/master/mica_powertools/mica_crossTemplateNN.m).

**3.Intracortical myelination**  
The intracortical myelination was estimated within the accurate, high-resolution cortical ribbon volume produced during the preprocessing pipeline. The T1-weighted image is divided by the aligned T2-weigthed image within voxels between the white and pial surfaces implemented in the [HCP pipeline v4.4.0-rc-MOD-e7a6af9](https://github.com/Washington-University/HCPpipelines/releases).

**4.Lifespan growth pattern analyses**   
The lifespan growth pattern of structural attributes were characterized using the same procedures as the functional gradient at global and regional levels ([code](https://github.com/QionglingLi/LifespanGradient/blob/main/GrowthPattern/Lifespan_growth_axis.m)).

## V. Cognitive spectrum
**1.NeuroSynth-based meta-analysis**  
The cortical regions were divided into 20 bins along the S-A axis and projected to the MNI volume space using the [BrainStat toolbox v0.4.2](https://github.com/MICA-MNI/Brainstat). The functional decoding meta-analysis was performed using code from [Margulies et al., PNAS 2016](https://github.com/NeuroanatomyAndConnectivity/gradient_analysis/blob/master/05_metaanalysis_neurosynth.ipynb) at both the group-level and individual-level.

**2.Compute spectrum distribution measures**  
The mean width across terms and Spearman’s correlation for each group and each inidividal were computed to meausre the distribution of the cognitive spectrum distribution ([code](https://github.com/QionglingLi/LifespanGradient/blob/main/E_CognitiveSpectrumAnalysis/CognitiveSpectrumMeasures.m)).

**3.Statistical analyses**  
The mean width across terms and Spearman’s correlation differences among stages were tested using the non-parametric Kruskal-Wallis test ([code](https://github.com/QionglingLi/LifespanGradient/blob/main/E_CognitiveSpectrumAnalysis/Stat_terms.m)).

## VI. Validation analyses
[1] Stricter head motion threshold analysis; [2] Bootstrap resampling analysis; [3] Split-half replication analysis; [4] Leave-one-site-out analysis; and [5] Balanced resampling analysis were conducted to test the robustness and reliability of the optimized models referred to [our prior study](https://www.biorxiv.org/content/10.1101/2023.09.12.557193v3.full). At the golbal and system levels, we computed the Pearson's correlation and mean square error between main results and those from sensitivity analyses ([code](https://github.com/QionglingLi/LifespanGradient/blob/main/G_Validation/Validation_global.m)). At the regional level, we assessed the consistency of the growth rate curves across the validation strategies by calculating the ICC and MMSE ([code](https://github.com/QionglingLi/LifespanGradient/blob/main/G_Validation/Validation_regional.m)).

## References
[1] Margulies, Daniel S., et al. "Situating the default-mode network along a principal gradient of macroscale cortical organization." Proceedings of the National Academy of Sciences 113.44 (2016): 12574-12579.
[2] Vos de Wael, Reinder, et al. "BrainSpace: a toolbox for the analysis of macroscale gradients in neuroimaging and connectomics datasets." Communications biology 3.1 (2020): 103.
[3] Xia, Mingrui, et al. "Connectome gradient dysfunction in major depression and its association with gene expression profiles and treatment outcomes." Molecular Psychiatry 27.3 (2022): 1384-1393.
[4] Sun, L. et al. Functional connectome through the human life span. 2023.09.12.557193 Preprint at https://doi.org/10.1101/2023.09.12.557193 (2024).


## Citation
Please cite us as follows:

## Contact
Any question, please contact qiongling0212@126.com
