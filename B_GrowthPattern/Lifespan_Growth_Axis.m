namel                                               = '.\tools\freesurfer\subjects\fsaverage4\surf\lh.inflated';
namer                                               = '.\tools\freesurfer\subjects\fsaverage4\surf\rh.inflated';
surf_inflated                                       = SurfStatAvSurf({namel,namer});

load                                                ('.\masks\v4609tov5124.mat');
Vertices                                            = v4609tov5124;

Subinfo                                             = readtable('.\tables\Subinfo_HC.csv');
IGpath                                              = '.\IndividualG2wrdbch\';
Age                                                 = Subinfo.Age; 
SubID                                               = Subinfo.SubID;
SiteID                                              = Subinfo.SiteID;
FCPath1                                             = Subinfo.Path1;
FCPath2                                             = Subinfo.Path2;
FCPath3                                             = Subinfo.Path3;
SubNum                                              = size(Subinfo,1);

load                                                ('.\GroupMeanFC_dbch\Ggroup_wr_pa.mat')
AgeName                                             = {'32-35pmw'; '35-37pmw'; '37-39pmw'; '39-41pmw';...
                                                        '0.25-1.5mon';'1.5-4.5mon';'4.5-7.5mon';'7.5-10.5mon';'10.5-13.5mon';'13.5-21mon';'21-27mon';...
                                                        '2.25-5yrs';'5-7yrs';'7-9yrs';'9-11yrs';'11-13yrs';'13-15yrs';'15-17yrs';'17-19yrs';'19-23yrs';...
                                                        '23-35yrs';'35-45yrs';'45-55yrs';'55-65yrs';'65-75yrs';'75-80yrs'};
AgeRange                                            = [-0.17,-0.1042; -0.1042,-0.0625; -0.0625,-0.0208; -0.0208,0.0208;...
                                                        0.0208,0.125; 0.125,0.375; 0.375,0.625; 0.625,0.875;0.875,1.125; 1.125,1.75; 1.75,2.25;...
                                                        2.25,5; 5,7; 7,9; 9,11; 11,13; 13,15; 15,17; 17,19; 19,23;...
                                                        23,35; 35,45; 45,55; 55,65; 65,75;75,80];
%% read individal G for regional-level gamlss
for g = 1:size(AgeName,1)
    disp (num2str(g))
    
    Lage                                            = AgeRange(g, 1);
    Uage                                            = AgeRange(g, 2);
    
    if g==26
        subind                                      = find((Age(1:SubNum) >= Lage) & (Age(1:SubNum) <= Uage));
    else
        subind                                      = find((Age(1:SubNum) >= Lage) & (Age(1:SubNum) < Uage));
    end
    
    for i = 1:numel(subind)
        fatherpath                                  = cell2mat(FCPath1(subind(i)));
        subid                                       = cell2mat(FCPath2(subind(i)));
        sesid                                       = cell2mat(FCPath3(subind(i)));
        
        disp                                        (strcat('loading', " ", num2str(i), 'th/',num2str(numel(subind))," ", 'Gradient in', " ", AgeName{g}," ",'group'))
        y                                           = load(strcat(IGpath,'AIG_',AgeName{g},'/',subid,'_', sesid,'_G.mat'));
        G1(:,subind(i))                             = y.x(:,1);
    end
end
writematrix                                         (G1,'.\IndividualG2wrdbch\AG1.csv')

%% plot growth rate at representative ages
Aind                                                = [1, 13, 17, 21, 29, 46, 71, 96, 121, 171, 221, 421, 621, 821, 1021, 1221, 1421, 1621, 1821, 2021, 3021, 4021, 5021, 6021, 7021, 8001];
Atalsind                                            = [1:26];

Data                                                = -inf(4609,size(Aind,2));
for g = 1:size(Aind,2)    
    xind                                            = Aind(g);
    Data(:,g)                                       = G1_all_velocity(xind,:);
        
    ViewData                                        = -inf(5124,1);
    ViewData(Vertices~=0,:)                         = Data(:,g);

    figure;
    DeSurfStatViewData                              (ViewData,surf_inflated,'');
    SurfStatColLim                                  ([-0.43,0.59])
    colormap                                        ([.8 .8 .8;cmap])   

    saveas                                          (gca,strcat('.\output_vertex\figures\GrowthRate\',num2str(Atalsind(g)),'_PA_GrowthRate_', AgeName{Atalsind(g)},'.tif'))
    close all
end

%% lifespan growth axis analyses
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

print                                               (strcat('.\output_vertex\figures\DevelopmentAxis\VE_G1.pdf'), '-dpdf', ['-r' '600'],'-bestfit')

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

saveas                                              (gca,'.\output_vertex\figures\DevelopmentAxis\PA_all_y.tiff')
print                                               ('.\output_vertex\figures\DevelopmentAxis\PA_all_y.pdf', '-dpdf', ['-r' '600'],'-bestfit')

% lifespan growth axis
G1_Loading                                          = -inf(5124,1);
G1_Loading(Vertices~=0,:)                           = L1;

figure;
DeSurfStatViewData                                  (G1_Loading,surf_inflated,'');
colormap                                            ([.8 .8 .8;cmap])
SurfStatColLim                                      ([-0.034, 0.03])
saveas                                              (gca,strcat('.\output_vertex\figures\DevelopmentAxis\G1_PrincipalAxis.tif'))

%% plot trajectory within each bin
nbin                                                = 20;
[Y,E]                                               = discretize(L1,nbin);
for nb = 1:nbin
    bin_y(:,nb)                                     = mean(all_y(:,Y==nb),2,'omitnan');
end
bin_y                                               = bin_y';

% plot G
fig                                                 = figure;
fig.Position                                        = [100 100 1000 1000];

dx                                                  = 0.02;
dy                                                  = 0.03;
plotAx                                              = axes('Position',[0.15 0.15 0.8 0.8],'Color','none');
yax                                                 = axes('Position',plotAx.Position-[dx 0 -dx 0],'Color','none','XColor','none');
yax.XGrid                                           = 'off';
yax.TickDir                                         = 'out';
xax                                                 = axes('Position',plotAx.Position-[0 dy 0 -dy],'Color','none','YColor','none');
xax.YGrid                                           = 'off';
xax.TickDir                                         = 'out';
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

exportgraphics                                      (gcf,'.\output_vertex\figures\DevelopmentAxis\G1_nomean_bin20.pdf', 'ContentType', 'vector', 'Resolution', 600);
%% correlation with evoluationary
load                                                ('.\neuromaps\EvoExpansion_4k.mat')
plotKDEContour                                      (L1,Evo,'','Lifespan growth axis of gradient','Evolutionary hierarchy')
saveas                                              (gca,'.\output_vertex\figures\DevelopmentAxis\r_G_Evo.tiff')
exportgraphics                                      (gcf,'.\output_vertex\figures\DevelopmentAxis\r_G_Evo.pdf', 'ContentType', 'vector', 'Resolution', 600);
