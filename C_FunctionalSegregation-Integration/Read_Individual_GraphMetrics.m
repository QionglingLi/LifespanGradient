load                                                ('./SupportFiles/v4609tov5124.mat');
Vertices                                            = v4609tov5124;

Subinfo                                             = readtable('./tables/Subinfo_HC.csv');
Age                                                 = Subinfo.Age; 
SubID                                               = Subinfo.SubID;
SiteID                                              = Subinfo.SiteID;
FCPath1                                             = Subinfo.Path1;
FCPath2                                             = Subinfo.Path2;
FCPath3                                             = Subinfo.Path3;
SubNum                                              = size(Subinfo,1);

%% compute age-specific group mean surface
parpool('local', 96)


AgeName                                             = {'32-35pmw'; '35-37pmw'; '37-39pmw'; '39-41pmw';...
                                                        '0.25-1.5mon';'1.5-4.5mon';'4.5-7.5mon';'7.5-10.5mon';'10.5-13.5mon';'13.5-21mon';'21-27mon';...
                                                        '2.25-5yrs';'5-7yrs';'7-9yrs';'9-11yrs';'11-13yrs';'13-15yrs';'15-17yrs';'17-19yrs';'19-23yrs';...
                                                        '23-35yrs';'35-45yrs';'45-55yrs';'55-65yrs';'65-75yrs';'75-80yrs'};
AgeRange                                            = [-0.17,-0.1042; -0.1042,-0.0625; -0.0625,-0.0208; -0.0208,0.0208;...
                                                        0.0208,0.125; 0.125,0.375; 0.375,0.625; 0.625,0.875;0.875,1.125; 1.125,1.75; 1.75,2.25;...
                                                        2.25,5; 5,7; 7,9; 9,11; 11,13; 13,15; 15,17; 17,19; 19,23;...
                                                        23,35; 35,45; 45,55; 55,65; 65,75;75,80];
                                                    
IGpath                                              = './GraphTheory/CpLp/';

%% compute and align individual gradient to its age-specific group-level gradient
parfor i = 1:SubNum
    
    age                                             = Age(i);
    if age==80
        g                                           = 26;
    else
        tmp                                         = find(AgeRange(:,2)>age);
        g                                           = tmp(1);      
    end
    
    fatherpath                                      = cell2mat(FCPath1(i));
    subid                                           = cell2mat(FCPath2(i));
    sesid                                           = cell2mat(FCPath3(i));
    
    Cppath                                          = strcat(IGpath, fatherpath,'/',subid,'_', sesid, ...
                                                            '_BOLD_1_Atlas.cWGSR.BandPass_Scrubbing.sm6.fs4.StaticFC_cp.txt');
    Lppath                                          = strcat(IGpath, fatherpath,'/',subid,'_', sesid, ...
                                                            '_BOLD_1_Atlas.cWGSR.BandPass_Scrubbing.sm6.fs4.StaticFC_Lp.txt');
    NodeCppath                                      = strcat(IGpath, fatherpath,'/',subid,'_', sesid, ...
                                                            '_BOLD_1_Atlas.cWGSR.BandPass_Scrubbing.sm6.fs4.StaticFC_cp.nm');
    NodeLppath                                      = strcat(IGpath, fatherpath,'/',subid,'_', sesid, ...
                                                            '_BOLD_1_Atlas.cWGSR.BandPass_Scrubbing.sm6.fs4.StaticFC_eff.nm');                                                                                                                
    
    % global Cp Lp                                                 
    Cp(i,1)                                         = load(Cppath);
    Lp(i,1)                                         = load(Lppath);

    % read nodal Cp Lp
    fid                                             = fopen(NodeCppath);
    nm                                              = fread(fid,'single');
    tmp                                             = nm(2:end);
    tmp(RemVind)                                    = [];
    nodCp(i,:)                                      = tmp;
    fclose(fid);    
    
    fid                                             = fopen(NodeLppath);
    nm                                              = fread(fid,'single');
    tmp                                             = nm(2:end);
    mean_tmp                                        = mean(tmp(tmp~=0));
    tmp(tmp==0)                                     = mean_tmp;
    tmp(RemVind)                                    = [];
    nodEff(i,:)                                     = tmp;
    fclose(fid);        
end
Variables                                           = [Subinfo table(Cp, Lp)];
writetable                                          (Variables, './tables/GlobalSystemCpLp.csv')

nodCp                                               = nodCp';
writematrix                                         (nodCp,'./GraphTheory/CpLp/nodCp.csv')
 
nodEff                                              = nodEff';
writematrix                                         (nodEff,'./GraphTheory/CpLp/nodEff.csv')
