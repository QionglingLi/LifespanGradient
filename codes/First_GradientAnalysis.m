addpath                                             (genpath('.\tools\micaopen-master'));
addpath                                             (genpath('.\tools\BrainSpace\'))

Gpath                                               = '.\G_output\';
FCrootpath                                          = 'H:\FC_matrix\';

% load masks
load                                                ('.\masks\v4609tov5124.mat');
Vertices                                            = v4609tov5124;
load                                                ('.\masks\v4661tov5124.mat')
Vertices1                                           = v4661tov5124;
RemVind                                             = Vertices1(Vertices1~=0 & Vertices==0);
MatirxSize                                          = sum(Vertices~=0); %vertx number

% visulization
surfl                                               = SurfStatReadSurf('D:\lql\tools\freesurfer\subjects\fsaverage4\surf\lh.inflated');
surfr                                               = SurfStatReadSurf('D:\lql\tools\freesurfer\subjects\fsaverage4\surf\rh.inflated');
cmap                                                = viridis;
%% load subject information
Subinfo                                             = ('.\tables\Subinfo_HC.csv');
AgeName                                             = {'32-35pmw'; '35-37pmw'; '37-39pmw'; '39-41pmw';...
                                                        '0.25-1.5mon';'1.5-4.5mon';'4.5-7.5mon';'7.5-10.5mon';'10.5-13.5mon';'13.5-21mon';'21-27mon';...
                                                        '2.25-5yrs';'5-7yrs';'7-9yrs';'9-11yrs';'11-13yrs';'13-15yrs';'15-17yrs';'17-19yrs';'19-23yrs';...
                                                        '23-35yrs';'35-45yrs';'45-55yrs';'55-65yrs';'65-75yrs';'75-80yrs'};
AgeRange                                            = [-0.17,-0.1042; -0.1042,-0.0625; -0.0625,-0.0208; -0.0208,0.0208;...
                                                        0.0208,0.125; 0.125,0.375; 0.375,0.625; 0.625,0.875;0.875,1.125; 1.125,1.75; 1.75,2.25;...
                                                        2.25,5; 5,7; 7,9; 9,11; 11,13; 13,15; 15,17; 17,19; 19,23;...
                                                        23,35; 35,45; 45,55; 55,65; 65,75;75,80];
                                                    
 Age                                                = Subinfo.Age; 
 SubID                                              = Subinfo.SubID;
 SiteID                                             = Subinfo.SiteID; 
 FCPath1                                            = Subinfo.Path1;
 FCPath2                                            = Subinfo.Path2;
 FCPath3                                            = Subinfo.Path3;
 
%% compute group-level mean functional connectome
for g = 1:size(AgeRange,1)
    Lage                                            = AgeRange(g, 1);
    Uage                                            = AgeRange(g, 2);
   
    subind                                          = find((Age >= Lage) & (Age < Uage));
    MeanCon_z                                       = zeros(MatirxSize);
    
    for i = 1:numel(subind)
        fatherpath                                  = cell2mat(FCPath1(subind(i),1));
        subid                                       = cell2mat(FCPath2(subind(i),2));
        sesid                                       = cell2mat(FCPath3(subind(i),3)); 
        
        disp                                        (strcat('loading', " ", num2str(i), 'th/',num2str(numel(subind))," ", 'matrix in', " ", AgeName{g}," ",'group'))
        
        FCpath                                      = strcat(FCrootpath, fatherpath,'\',subid,'_', sesid, ...
                                                            '_BOLD_1_Atlas.cWGSR.BandPass_Scrubbing.sm6.fs4.StaticFC.txt');
        FC                                          = importdata(FCpath);
        FC(:,RemVind)                               = []; % remove column with all zero
        FC(RemVind, :)                              = []; % remove row with all zero
        FC_z                                        = atanh(FC);
        MeanCon_z                                   = MeanCon_z + FC_z;
    end
    
        MeanCon_r                                   = MeanCon_z./size(subind,1);
        MeanCon_r(isinf(MeanCon_r)|isnan(MeanCon_r))= 0;
        MeanCon_r                                   = tanh(MeanCon_r);
    
        groupMeanCon_r{g}                           = MeanCon_r;
        save                                        (strcat(Gpath,'groupMeanCon_r_',AgeName{g},'.mat'), 'MeanCon_r')
end
save                                                (strcat(Gpath,'groupMeanCon_r.mat'), 'groupMeanCon_r')  

%% load each group mean FC                                                    
for g=1:26
    load                                            (strcat(Gpath,'groupMeanCon_r_',AgeName{g},'.mat'));
    groupMeanCon_r{g}                               = MeanCon_r;
end

%% compute age-specific group level gradients
disp                                                ('computing gradient...')
Refind                                              = 21; %reference group matrix
matrixToMove                                        = groupMeanCon_r{Refind};
groupMeanCon_r(Refind)                              = [];
groupMeanCon_r                                      = [{matrixToMove}, groupMeanCon_r{:}];

Ggroup                                              = GradientMaps('kernel','cs','approach','dm','alignment','pa');
Ggroup                                              = Ggroup.fit(groupMeanCon_r);
save                                                (strcat(Gpath,'Ggroup.mat'), 'Ggroup')

% reorder group sequence according age
newGgroup.method                                    = Ggroup.method;
newGgroup.gradients                                 = [Ggroup.gradients(2:Refind),Ggroup.gradients(1),Ggroup.gradients(Refind+1:end)];
newGgroup.lambda                                    = [Ggroup.lambda(2:Refind),Ggroup.lambda(1),Ggroup.lambda(Refind+1:end)];
newGgroup.aligned                                   = [Ggroup.aligned(2:Refind),Ggroup.aligned(1),Ggroup.aligned(Refind+1:end)];

% define the limits for S-A gradient
maxValues                                           = max(cellfun(@(matrix) max(matrix(:, 1)), newGgroup.aligned));
minValues                                           = min(cellfun(@(matrix) min(matrix(:, 1)), newGgroup.aligned));
alimits(:,1)                                        = [minValues; maxValues];

% plot aligned gradients
ViewData                                            = -inf(5124,size(AgeRange,1));
for g = 1:size(AgeRange,1)
  
    ViewData(Vertices~=0,g)                         = newGgroup.aligned{g}(:,1);

    figure;
    DeSurfStatViewData                              (ViewData(:,g),surf_inflated,'');
    SurfStatColLim                                  ([alimits(1,1)-0.1,alimits(2,1)])
    colormap                                        ([.8 .8 .8;cmap])   

    saveas                                          (gca,strcat('.\GroupMeanFC_dbch\figures\',num2str(g),'_Gradients_', AgeName{g},'.tif'))
    close all
end

%% pairwise correlation between group gradients
for g = 1:26
   G1_group(:,g)                                    = newGgroup.aligned{g}(:,1);
end
Distances                                           = pdist(G1_group','cosine');
D1                                                  = squareform(Distances);

labels                                              = {'34 w', '36 w', '38 w', '0 m', '1 m', '3 m', '6 m', '9 m', '12 m', '18 m', '2 yr', '4 yr', '6 yr',...
                                                        '8 yr', '10 yr', '12 yr', '14 yr', '16 yr', '18 yr', '20 yr', '30 yr', '40 yr', '50 yr', '60 yr', '70 yr', '80 yr'};
figure; imagesc(1-D1)
xticks                                              (1:size(D1, 2));  
xticklabels                                         (labels);
xtickangle(90);
yticks                                              (1:size(D1, 1));  
yticklabels                                         (labels);
set                                                 (gca, 'FontSize', 12, 'FontWeight', 'bold');
colormap(cmap)
saveas                                              (gca,'.\GroupMeanFC_dbch\Cluster\PA_corMatrix.tiff')
print                                               ('.\GroupMeanFC_dbch\Cluster\PA_corMatrix.pdf', '-dpdf', ['-r' '600'],'-bestfit')

% plot MDS
Y1                                                  = mdscale(D1, 2);

Colors                                              = zeros(26,3);
Colors(1:5,:)                                       = repmat([226, 121, 53],5,1)/255; % color for cluster1
Colors(6:12,:)                                      = repmat([66,109,178],7,1)/255; % color for cluster2
Colors(13:26,:)                                     = repmat([221,125,135],14,1)/255; % color for cluster3

fig = figure;
scatter                                             (Y1(:,1), Y1(:,2),155,Colors,'filled');
xlim                                                ([-0.3,0.4])
ylim                                                ([-0.15,0.3])
xlabel                                              ('Dimension 1');
ylabel                                              ('Dimension 2');
for i = 1:length(labels)
    text                                            (Y1(i,1), Y1(i,2), labels{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end
saveas                                              (fig,'.\GroupMeanFC_dbch\Cluster\MDS_PA_C3.tiff')
print                                               ('.\GroupMeanFC_dbch\Cluster\MDS_PA_C3.pdf', '-dpdf', ['-r' '600'],'-bestfit')

%% visulization of S-A gradient in each stage
G1_1                                                = mean(G1_group1(:,1:5),2);
G1_2                                                = mean(G1_group1(:,6:12),2);
G1_3                                                = mean(G1_group1(:,13:26),2);

G1_stage1                                           = -inf(5124,1);
G1_stage1(Vertices~=0,:)                            = G1_1;
figure;
DeSurfStatViewData                                  (G1_stage1,surf_inflated,'G1_stage1')
colormap                                            ([.8 .8 .8;cmap])
SurfStatColLim                                      ([-10.5,11.6])
saveas                                              (gca,'.\GroupMeanFC_dbch\figures\PA_stage1.tiff')

G1_stage2                                           = -inf(5124,1);
G1_stage2(Vertices~=0,:)                            = G1_2;
figure;
DeSurfStatViewData                                  (G1_stage2,surf_inflated,'G1_stage2')
colormap                                            ([.8 .8 .8;cmap])
SurfStatColLim                                      ([-10.5,11.6])
saveas                                              (gca,'.\GroupMeanFC_dbch\figures\PA_stage2.tiff')

G1_stage3                                           = -inf(5124,1);
G1_stage3(Vertices~=0,:)                            = G1_3;
figure;
DeSurfStatViewData                                  (G1_stage3,surf_inflated,'G1_stage3')
colormap                                            ([.8 .8 .8;cmap])
SurfStatColLim                                      ([-10.5,11.6])
saveas                                              (gca,'.\GroupMeanFC_dbch\figures\PA_stage3.tiff')

%% prepare data for gradient rigdes
Gradient_ridges1                                     = [];
for g = 1:26
    G1                                              = newGgroup.aligned{g}(:,1);
    Gradient_ridges1                                = [Gradient_ridges1; G1];
end
Ages                                                = [-0.125,-0.083,-0.042,0,0.083,0.25,0.5,0.75,1,1.5,2,4,6,8,10,12,14,16,18,20,30,40,50,60,70,80];
Age                                                 = repelem(Ages, 1, 4609)';

Gradient_ridges_table                               = table(Age,Gradient_ridges1);
writetable                                          (Gradient_ridges_table,'.\G_output\Group_wr_pa.csv')
