load                                                 ('.\Thickness_4k\CT_all_y.mat')
% pca 
[coeff, score, ~, ~, explained, ~]                  = pca(all_y);

% plot explained variance
figure;
plot                                                (1:10, explained(1:10), '-o', 'LineWidth', 2);
xlabel                                              ('Number of Principal Components');
ylabel                                              ('Explained Variance(%)');
ax                                                  = gca;
ax.TickDir                                          = 'out';
ax.Box                                              = 'off';
ax.XLim                                             = [0.5, 10.5];
ax.YLim                                             = [-2, ax.YLim(2)];
ax.LineWidth                                        = 1;

print                                               (strcat('.\Thickness_4k\figures\DevelopmentAxis\VE_G1.pdf'), '-dpdf', ['-r' '600'],'-bestfit')

% sorted gradient values
L1                                                  = coeff(:,1);
[~,Sind]                                            = sort(L1,'descend');
sorted_all_y                                        = all_y(:,Sind);

Aind                                                = [21,1021,2021,3021,4021,5021,6021,7021,8021];
figure; 
ax                                                  = axes; 
imagesc                                             (ax,sorted_all_y');
colormap(cmap);
ax                                                  = gca;
ax.TickDir                                          = 'out';
ax.Box                                              = 'off';
ax.XLim                                             = [-200,8121];
ax.YLim                                             = [-100,4709];
xticks                                              (Aind);
xticklabels                                         (arrayfun(@(x) sprintf('%d', x), age(Aind), 'UniformOutput', false));

saveas                                              (gca,'.\Thickness_4k\figures\DevelopmentAxis\PA_all_y.tiff')
print                                               ('.\Thickness_4k\figures\DevelopmentAxis\PA_all_y.pdf', '-dpdf', ['-r' '600'],'-bestfit')

% lifespan growth axis
G1_Loading                                          = -inf(5124,1);
G1_Loading(Vertices~=0,:)                           = L1;

figure;
SurfStatViewData                                    (G1_Loading,surf_inflated,'');
colormap                                            ([.8 .8 .8;cmap])
SurfStatColLim                                      ([-0.034, 0.03])
saveas                                              (gca,strcat('.\Thickness_4k\figures\DevelopmentAxis\G1_PrincipalAxis.tif'))

%% plot trajectory within each bin
nbin                                                = 20;
[Y,E]                                               = discretize(L1,nbin);
for nb = 1:nbin
    bin_y(:,nb)                                     = mean(all_y(:,Y==nb),2,'omitnan');
end
bin_y                                               = bin_y';

% plot G
fig                                                 = figure('Color', 'w', 'Position', [100 100 1000 1000]);
    
plotAx                                              = axes('Position', [0.15 0.15 0.8 0.8], 'Color', 'none');
yax                                                 = axes('Position', plotAx.Position - [0.02 0 -0.02 0], 'Color', 'none', 'XColor', 'none');
xax                                                 = axes('Position', plotAx.Position - [0 0.03 0 -0.03], 'Color', 'none', 'YColor', 'none');
    
set                                                 ([yax, xax], 'TickDir', 'out');
yax.XGrid                                           = 'off';
xax.YGrid                                           = 'off';
axes                                                (plotAx); 
    
for i = 1:nbin
   plot                                             (cen_x(:,4),bin_y(i,:)-mean(bin_y(i,:)),'Color',cmap_bin(i,:),'LineWidth',3,'LineStyle','-');
   hold on    
end
linkaxes                                            ([plotAx,yax,xax]);
yticklabels                                         ([]);
xticklabels                                         ([]);
plotAx.XColor                                       = 'none';
plotAx.YColor                                       = 'none';
xax.XLim                                            = [-1,80];

yax.YLabel.String                                   = 'G1';
xax.XLabel.String                                   = 'Age/year';

exportgraphics                                      (gcf,'.\Thickness_4k\figures\DevelopmentAxis\G1_nomean_bin20.pdf', 'ContentType', 'vector', 'Resolution', 600);
%% correlation with evoluationary
load                                                ('.\neuromaps\EvoExpansion_4k.mat')
plotKDEContour                                      (L1,Evo,'','Lifespan growth axis of gradient','Evolutionary hierarchy')
saveas                                              (gca,'.\Thickness_4k\figures\DevelopmentAxis\r_G_Cp.tiff')
exportgraphics                                      (gcf,'.\Thickness_4k\figures\DevelopmentAxis\r_G_Cp.pdf', 'ContentType', 'vector', 'Resolution', 600);
