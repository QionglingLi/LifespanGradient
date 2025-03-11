addpath                                             (genpath('./scripts/micaopen-master'));
addpath                                             (genpath('./scripts/BrainSpace-master'));

load                                                ('./v4609tov5124.mat');
Vertices                                            = v4609tov5124;
load                                                ('./RemVind.mat');

Age                                                 = Subinfo.Age; 
SubID                                               = Subinfo.SubID;
SiteID                                              = Subinfo.SiteID;
FCPath1                                             = Subinfo.Path1;
FCPath2                                             = Subinfo.Path2;
FCPath3                                             = Subinfo.Path3;

load                                                ('.\GroupMeanFC_dbch\Ggroup_wr_pa.mat')
AgeName                                             = {'32-35pmw'; '35-37pmw'; '37-39pmw'; '39-41pmw';...
                                                        '0.25-1.5mon';'1.5-4.5mon';'4.5-7.5mon';'7.5-10.5mon';'10.5-13.5mon';'13.5-21mon';'21-27mon';...
                                                        '2.25-5yrs';'5-7yrs';'7-9yrs';'9-11yrs';'11-13yrs';'13-15yrs';'15-17yrs';'17-19yrs';'19-23yrs';...
                                                        '23-35yrs';'35-45yrs';'45-55yrs';'55-65yrs';'65-75yrs';'75-80yrs'};
AgeRange                                            = [-0.17,-0.1042; -0.1042,-0.0625; -0.0625,-0.0208; -0.0208,0.0208;...
                                                        0.0208,0.125; 0.125,0.375; 0.375,0.625; 0.625,0.875;0.875,1.125; 1.125,1.75; 1.75,2.25;...
                                                        2.25,5; 5,7; 7,9; 9,11; 11,13; 13,15; 15,17; 17,19; 19,23;...
                                                        23,35; 35,45; 45,55; 55,65; 65,75;75,80];

IGpath                                              = './IndividualG2wrdbch/';
FCrootpath                                          = './FC_matrix/';

%% compute and align individual gradient to its age-specific group-level gradient
Refind                                              = 21;%reference group
newGgroup.aligned                                   = [Ggroup.aligned(2:Refind),Ggroup.aligned(1),Ggroup.aligned(Refind+1:end)];

for g = 1:size(AgeRange,1)
    Gref                                            = newGgroup.aligned{g}; 
    Lage                                            = AgeRange(g, 1);
    Uage                                            = AgeRange(g, 2);
   
    if g==26
       subind                                       = find((Age >= Lage) & (Age <= Uage));
    else
       subind                                       = find((Age >= Lage) & (Age < Uage));
    end
    
    mkdir                                           (strcat(IGpath,'IG_',AgeName{g}))
    for i = 1:numel(subind)
        fatherpath                                  = cell2mat(FCPath1(subind(i)));
        subid                                       = cell2mat(FCPath2(subind(i)));
        sesid                                       = cell2mat(FCPath3(subind(i)));
        
        disp                                        (strcat('loading', " ", num2str(i), 'th/',num2str(numel(subind))," ", 'matrix in', " ", AgeName{g}," ",'group'))
        
        FCpath                                      = strcat(FCrootpath, fatherpath,'/',subid,'_', sesid, ...
                                                                '_BOLD_1_Atlas.cWGSR.BandPass_Scrubbing.sm6.fs4.StaticFC.txt');
        FC                                          = importdata(FCpath);
        FC(:,RemVind)                               = []; % remove column with all zero
        FC(RemVind, :)                              = []; % remove row with all zero
        
        Gindiv                                      = GradientMaps('kernel','cs','approach','dm','alignment','pa');
        Gindiv                                      = Gindiv.fit(FC,'reference',Gref);
        save                                        (strcat(IGpath,'IG_',AgeName{g},'/',subid,'_', sesid,'_G.mat'), Gindiv)
        
        % reorder lambda
        mkdir                                       (strcat(IGpath,'AIG_',AgeName{g}))
        [aligned, xfms]                             = procrustes_alignment({Gref,Gindiv.gradients{1}});        
        xfms                                        = cellfun(@real,xfms,'UniformOutput',false);
        
        tmp                                         = abs(xfms{2});
        [~,I]                                       = sort(tmp,'descend');
        seq_tmp                                     = zeros(5,1);
        seq_tmp(1)                                  = I(1);
        for j = 2:10
            for k = 1:10
                if isempty(find(seq_tmp == I(k,j), 1))
                    seq_tmp(j)                      = I(k,j);
                    break;
                end
            end
        end
        EV                                          = Gindiv.lambda{1}./sum(Gindiv.lambda{1});
        AEV                                         = EV(seq_tmp);
        
        AGindiv                                     = aligned{2};
        save                                        (strcat(IGpath,'AIG_',AgeName{g},'/',subid,'_', sesid,'_G.mat'), AGindiv)
        save                                        (strcat(IGpath,'AIG_',AgeName{g},'/',subid,'_', sesid,'_EV.mat'), AEV)
    end    
end
