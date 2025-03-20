
cen_x                                               = repmat(linspace(-0.2,80,8021),7,1);
cen_x                                               = cen_x';

CurveColors                                         = [0,0,0; 216,128,144; 135,219,203; 239,207,222; 165,222,238; 148,125,153; 228,232,218]/255;
Yeo_colors                                          = [120, 18, 134; 70, 130, 180; 0, 118, 14; 196, 58, 250; 220, 248, 164; 230, 148, 34; 205, 62, 78]/255;

%% compute correlation between validation strategies
Measures                                            = ["AEV1", "ARange1", "Astd1"];
% Measures                                            = ["Range_sys_1", "Range_sys_2","Range_sys_3","Range_sys_4",...
%                                                         "Range_sys_5","Range_sys_6","Range_sys_7"];
% Measures                                            = ["Std_sys_1", "Std_sys_2","Std_sys_3","Std_sys_4",...
%                                                         "Std_sys_5","Std_sys_6","Std_sys_7"];
Measure_names                                       = ["Global","Range_sys","Std_sys"];
                                                    
for p = 1:size(Measures,2)
    load                                            (strcat('./median_y_',Measures(p),'.mat'))            
    
    % plot correlation matrix
    r_str                                           = corr(median_y);
    r_all_measure(p,:)                              = r_str(1,:);
    
    % mean square error
    mse_value                                       = mean((median_y(:,2:end)-median_y(:,1)).^2,1);
    mse_value_all(p,:)                              = mse_value;
    
    % plot trajectories of all validation strategies and main results
    fig                                             = figure('Color', 'w', 'Position', [100 100 1000 1000]);
    
    plotAx                                          = axes('Position', [0.15 0.15 0.8 0.8], 'Color', 'none');
    yax                                             = axes('Position', plotAx.Position - [0.02 0 -0.02 0], 'Color', 'none', 'XColor', 'none');
    xax                                             = axes('Position', plotAx.Position - [0 0.03 0 -0.03], 'Color', 'none', 'YColor', 'none');
    
    % Customize axes
    set                                             ([yax, xax], 'TickDir', 'out');
    yax.XGrid                                       = 'off';
    xax.YGrid                                       = 'off';
    axes                                            (plotAx); 
           
    for m = 7:-1:1
        plot                                        (cen_x,median_y(:,m),'Color',CurveColors(m,:),'LineWidth',3,'LineStyle','-');
        hold on;
    end
    
    linkaxes                                        ([plotAx,yax,xax]);
    xticklabels                                     = [];
    yticklabels                                     = [];
    plotAx.XColor                                   = 'none';
    plotAx.YColor                                   = 'none';
%     xax.YLim                                        = [0.1,0.4];%
    xax.XLim                                        = [-1,80];
    
    xax.XAxis.TickValues                            = [0, 10, 20, 30, 40, 50, 60, 70, 80];
    xax.XAxis.TickLabels                            = {'0','','20','','40','','60','','80'};
    
    yax.YLabel.String                               = Measures(p);
    xax.XLabel.String                               = 'Age (yr)';
    
    exportgraphics                                  (gcf,strcat('.\Validation\All\GrowthCurve_',Measures(p),'.pdf'), 'ContentType', 'vector', 'Resolution', 600);
end

% plot correlation
r_all_measure                                       = r_all_measure(:,2:end);

figure; 
imagesc                                             (r_all_measure)
xticks                                              (1:size(r_all_measure, 2));
xticklabels                                         ({'HM','BSR','SH1','SH2','LOSO','BLR'});
xtickangle(90);
yticks                                              (1:size(r_all_measure, 1));
yticklabels                                         (Measures);
set                                                 (gca, 'FontSize', 12, 'FontWeight', 'bold');
colormap                                            (cmap_red)
colorbar
caxis                                               ([0.8,1])

print                                               (strcat('.\Validation\All\corr\',Measure_names(i),'_median_y_correlation.pdf'), '-dpdf', ['-r' '600'],'-bestfit')

% plot mse
figure; 
imagesc                                             (mse_value_all)
xticks                                              (1:size(mse_value_all, 2));
xticklabels                                         ({'HM','BSR','SH1','SH2','LOSO','BLR'});
xtickangle                                          (90);
yticks                                              (1:size(mse_value_all, 1));
yticklabels                                         (Measures);
set                                                 (gca, 'FontSize', 12, 'FontWeight', 'bold');
colormap                                            (cmap_blue)
colorbar
caxis                                               ([0,0.1])

print                                               (strcat('.\Validation\All\corr\',Measure_names(i),'_median_y_MSE.pdf'), '-dpdf', ['-r' '600'],'-bestfit')

%% Gradient mean score bar plot for all peaks
load                                                ('.\Validation\All\Y_median_meanscore_main.mat')
load                                                ('.\Validation\All\PeakAgeIndex.mat')
data                                                = Y_median;
num_variables                                       = size(data,2);
num_timepoints                                      = size(data,1);

figure;
hold on;

for i = 1:num_variables % each system
    
    data_Y                                          = data(:,i);
    if i <5
        data_Y                                      = -data_Y;
    end
    
    colorbar_range                                  = [min(data_Y), max(data_Y)];
    norm_data                                       = (data_Y - colorbar_range(1)) / (colorbar_range(2) - colorbar_range(1));
    norm_data                                       = min(max(norm_data, 0), 1);
    
    [~, idx]                                        = max(norm_data);
    
    % set the color from white to yeo_color
    startColor                                      = [1, 1, 1];
    endColor                                        = Yeo_colors(i, :)/255;
    
    % the parameter controlling the degree of nonliear change in color
    alpha                                           = 6;
    t                                               = linspace(0, 1, num_timepoints).^alpha;
    cmap                                            = [startColor(1) + t * (endColor(1) - startColor(1));
                                                        startColor(2) + t * (endColor(2) - startColor(2));
                                                        startColor(3) + t * (endColor(3) - startColor(3))]';
    
    ax1                                             = subplot(num_variables, 1, i);
    imagesc                                         ([1:num_timepoints], [0 1]+i, data_Y')
    set                                             (ax1, 'CLim', colorbar_range);
    colormap                                        (ax1, cmap);
    hold on;
    for j = 1:6 %validation strategies
        plot                                        (idxs(j,i), norm_data(idx) + i-rand(1), 'o','MarkerEdgeColor', CurveColors(j+1,:), 'MarkerFaceColor', CurveColors(j+1,:), 'MarkerSize', 8);
        hold on;
    end
    plot                                            (idx, norm_data(idx) + i-0.5, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 8);
    hold on;

    if i == num_variables  %visible x-axis only for the last subplot
        set                                         (ax1, 'Box', 'off');
        set                                         (ax1, 'XColor', 'k', 'YColor', 'none');
        set                                         (ax1, 'TickDir', 'out');
        ax1.XAxis.TickValues                        = [21, 1021, 2021, 3021, 4021, 5021, 6021, 7021, 8021];
        ax1.XAxis.TickLabels                        = {'0','10','20','30','40','50','60','70','80'};
    else
        axis                                        (ax1, 'off')
    end
end

ax                                                  = gca;
ax.LineWidth                                        = 2;
ax.FontSize                                         = 28;
xlabel                                              ('Age (yr)')
ylabel                                              ('Functional system')
hold off

print                                               (strcat('F:\project3\Validation\All\Bar_Gradient_Mean_Score.pdf'), '-dpdf', ['-r' '600'],'-bestfit')
%% System contribution for all validations
load                                                ('.\Validation\All\all_stage_y_stackedbar.mat')
for v = 1:6   
    validation_stag1_y(v,:)                         = all_stage_y{v}(1,:);
    validation_stag2_y(v,:)                         = all_stage_y{v}(2,:); 
    validation_stag3_y(v,:)                         = all_stage_y{v}(3,:); 
end

% plot stacked bar across validations for each stage
figure;
h                                                   = bar(validation_stag1_y,'stacked');
for j = 1:size(validation_stag1_y, 2)
    for i = 1:size(validation_stag1_y, 1)
        h(j).FaceColor                              = 'flat';
        h(j).CData(i,:)                             = Yeo_colors(j,:);
    end
end
xticklabels                                         ({'HM','BSR','SH1','SH2','LOSO','BLR'})
ax                                                  = gca;
ax.TickDir                                          = 'out';
ax.Box                                              = 'off';
ax.YColor = 'none';
ax.YAxisLocation = 'right';
ax.YLim = [0, 3.2];
ax.YColor = 'k'; 

print                                               (strcat(outputdir,'\deltaDispersion_Individual_stag1.pdf'), '-dpdf', ['-r' '600'],'-bestfit')
