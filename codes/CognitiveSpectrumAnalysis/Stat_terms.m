
Stage_colors                                        = [217, 71, 56; 3 , 159, 137; 59, 83, 135]/255;

meanOrder                                           = readmatrix('.\neurosynth\output\Spearman_Corrs_between_MedianandSequenceRank.csv');

group                                               = zeros(26,1);
group(1:5)                                          = 1;
group(6:12)                                         = 2;
group(13:end)                                       = 3;

[p, tbl, stats]                                     = kruskalwallis(meanOrder, group);

% compute effect size
H = tbl{2,5};% chi squared value;
k = 3; % Number of groups
N = 26; % Total sample size
eta_squared                                         = (H - k + 1) / (N - k);% eta-squared 

% post-hoc comparison
posthocResults                                      = multcompare(stats,'ComparisonType', 'bonferroni');
posthocTable                                        = array2table(posthocResults,'VariableNames', {'Group1', 'Group2', 'MeanDifference', 'LowerBound', 'UpperBound', 'pValue'});
writetable                                          (posthocTable,'.\neurosynth\output\meanOrder_violin.csv')

% plot violin
figure; 
violinplot                                          (meanOrder, group,'ViolinColor',Stage_colors);
ax                                                  = gca;
ax.Box                                              = 'off';
ax.XColor                                           = 'k';
ax.YColor                                           = 'k';
ax.FontSize                                         = 24;
ax.LineWidth                                        = 1.5;
ax.YAxis.TickValues                                 = [7 8 9 10];
xlabel                                              ('Phase');
ylabel                                              ('meanOrder');

saveas                                              (gca,'.\neurosynth\output\meanOrder_violin.tiff')
print                                               ('.\neurosynth\output\meanOrder_violin.pdf', '-dpdf', ['-r' '600'],'-bestfit')

