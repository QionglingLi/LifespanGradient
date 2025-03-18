

load                                            ('.\NC_model\Trajectories\Y_median_Gscore_sys.mat')
Yeo_colors                                      = [120, 18, 134; 70, 130, 180; 0, 118, 14; 196, 58, 250; 220, 248, 164; 230, 148, 34; 205, 62, 78]/255;

data                                            = Y_median;
num_variables                                   = size(data,2);
num_timepoints                                  = size(data,1);

figure;
hold on;

% plot the gradient score growth bar for each system
for i = 1:num_variables
   
    data_Y                                      = data(:,i);
    if i <5
        data_Y                                  = -data_Y;% ensure same trends
    end

    colorbar_range                              = [min(data_Y), max(data_Y)];
    norm_data                                   = (data_Y - colorbar_range(1)) / (colorbar_range(2) - colorbar_range(1));
    norm_data                                   = min(max(norm_data, 0), 1); 
    
    [~, idx]                                    = max(norm_data);

    % set the color from white to yeo_color
    startColor                                  = [1, 1, 1];
    endColor                                    = Yeo_colors(i, :);
    
    % the parameter controlling the degree of nonliear change in color
    alpha                                       = 6;
    t                                           = linspace(0, 1, num_timepoints).^alpha;
    cmap                                        = [startColor(1) + t * (endColor(1) - startColor(1));
                                                   startColor(2) + t * (endColor(2) - startColor(2));
                                                   startColor(3) + t * (endColor(3) - startColor(3))]';
    
    ax1                                         = subplot(num_variables, 1, i);
    imagesc                                     ([1:num_timepoints], [0 1]+i, data_Y')
    set                                         (ax1, 'CLim', colorbar_range); 
    colormap                                    (ax1, cmap);
    hold on;
    plot                                        (idx, norm_data(idx) + i-0.5, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 8);
    
    if i == num_variables  %visible x-axis only for the last subplot
        set                                     (ax1, 'Box', 'off');
        set                                     (ax1, 'XColor', 'k', 'YColor', 'none');
        set                                     (ax1, 'TickDir', 'out');
        ax1.XAxis.TickValues                    = [21, 1021, 2021, 3021, 4021, 5021, 6021, 7021, 8021];
        ax1.XAxis.TickLabels                    = {'0','10','20','30','40','50','60','70','80'};
    else
        axis(ax1, 'off')
    end
end
ax                                              = gca;
ax.LineWidth                                    = 2;
ax.FontSize                                     = 28;
xlabel('Age (yr)')
ylabel('Functional system')
hold off

print                                           ('.\NC_model\figures\trajectory\Bar_Gradient_Mean_Score.pdf', '-dpdf', ['-r' '600'],'-bestfit')
