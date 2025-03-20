


namel                                               = '.\tools\freesurfer\subjects\fsaverage4\surf\lh.inflated';
namer                                               = '.\tools\freesurfer\subjects\fsaverage4\surf\rh.inflated';
surf_inflated                                       = SurfStatAvSurf({namel,namer});

%% icc\absolute error range\std
load                                                ('.\Validation\All\all_velocity.mat')% age, vertex, validations

data                                                = permute(all_velocity, [2, 1, 3]);% vertex, age, validations
[V, ~, ~]                                           = size(data);

ICC_values                                          = zeros(V, 1);
MMSE_values                                         = zeros(V,1);
for v = 1:V
    current_data                                    = squeeze(data(v, :, :));  % trajectory for each vertex 
    ICC_values(v)                                   = ICC(current_data, 'C-1');  %  ICC(2,1), column: subjects being measured; row: raters or repeated measures
    
    max_values                                      = max(current_data, [], 2); 
    min_values                                      = min(current_data, [], 2); 
    
    absolute_error_range(v)                         = mean(max_values - min_values);
    mse_value                                       = mean((current_data(:,2:end)-current_data(:,1)).^2,1);
    MMSE_values(v)                                  = min(mse_value);
end

% ICC
Loading                                             = -inf(5124,1);
Loading(Vertices~=0,:)                              = ICC_values;
ViewData_sm                                         = SurfStatSmooth(Loading',surf_inflated,1);

figure;
SurfStatViewData                                    (ViewData_sm',surf_inflated,'');
colormap                                            ([.8 .8 .8;cmap_red])
SurfStatColLim ([0,1])
saveas                                              (gca,'.\Validation\All\ICC.tif')

% MMSE
outliers                                            = abs(MMSE_values - mean(MMSE_values)) > 1.5 * std(MMSE_values);
MMSE_values(outliers)                               = mean(MMSE_values(~outliers));

Loading                                             = -inf(5124,1);
Loading(Vertices~=0,:)                          	= MMSE_values;
ViewData_sm                                         = SurfStatSmooth(Loading',surf_inflated,1);

figure;
SurfStatViewData                                    (ViewData_sm',surf_inflated,'');
colormap                                            ([.8 .8 .8;cmap_blue])
SurfStatColLim ([0,5e-06])
saveas                                              (gca,'.\Validation\All\MMSE.tif')

%% correlation between axes
load                                                ('.\Validation\All\all_L1.mat')
r_str                                               = corr(all_L1,'type','Spearman');
r_str_upper                                         = triu(r_str, 1);
r_str_upper(tril(ones(size(r_str)), 0) == 1)        = NaN;
figure; 
imagesc                                             (r_str_upper, 'AlphaData', ~isnan(r_str_upper))
xticks                                              (1:size(r_str, 2));  
xticklabels                                         ({'HM','BSR','SH1','SH2','LOSO','BLR'});
xtickangle(30);
yticks                                              (1:size(r_str, 1));  
yticklabels                                         ({'HM','BSR','SH1','SH2','LOSO','BLR'});
ytickangle(30);
set                                                 (gca, 'FontSize', 12, 'FontWeight', 'bold');
colormap(cmap_red)
colorbar
caxis                                               ([0.8,1])

print                                               ('.\Validation\All\corr\G1_L1_corr.pdf', '-dpdf', ['-r' '600'],'-bestfit')
