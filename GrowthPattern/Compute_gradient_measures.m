addpath                                             (genpath('./micaopen-master'));
addpath                                             (genpath('./BrainSpace-master'));

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

AgeName                                             = {'32-35pmw'; '35-37pmw'; '37-39pmw'; '39-41pmw';...
                                                        '0.25-1.5mon';'1.5-4.5mon';'4.5-7.5mon';'7.5-10.5mon';'10.5-13.5mon';'13.5-21mon';'21-27mon';...
                                                        '2.25-5yrs';'5-7yrs';'7-9yrs';'9-11yrs';'11-13yrs';'13-15yrs';'15-17yrs';'17-19yrs';'19-23yrs';...
                                                        '23-35yrs';'35-45yrs';'45-55yrs';'55-65yrs';'65-75yrs';'75-80yrs'};
AgeRange                                            = [-0.17,-0.1042; -0.1042,-0.0625; -0.0625,-0.0208; -0.0208,0.0208;...
                                                        0.0208,0.125; 0.125,0.375; 0.375,0.625; 0.625,0.875;0.875,1.125; 1.125,1.75; 1.75,2.25;...
                                                        2.25,5; 5,7; 7,9; 9,11; 11,13; 13,15; 15,17; 17,19; 19,23;...
                                                        23,35; 35,45; 45,55; 55,65; 65,75;75,80];

IGpath                                              = './IndividualG2wrdbch/';                                                    
%% compute individual gradient measures at global and system levels
for i = 1:SubNum
    fatherpath                                      = cell2mat(FCPath1(i));
    subid                                           = cell2mat(FCPath2(i));
    sesid                                           = cell2mat(FCPath3(i));

    age                                             = Age(i);
    if age==80
        g                                           = 26;
    else
        tmp                                         = find(AgeRange(:,2)>age);
        g                                           = tmp(1);
    end
        
    disp                                            (strcat('loading', " ", num2str(i), 'th/',num2str(SubNum)," ", 'gradient in', " ", AgeName{g}," ",'group'))
    
    % load explanation ratio
    x                                               = load(strcat(IGpath,'AIG_',AgeName{g},'/',subid,'_', sesid,'_EV.mat'));
    AEV(i,:)                                        = x.x';
    
    % load aligned individual gradient
    y                                               = load(strcat(IGpath,'AIG_',AgeName{g},'/',subid,'_', sesid,'_G.mat'));
    
    % compute global-level measures
    ARange(i,:)                                     = range(y.x);
    IRange(i,1)                                     = range(y.x(:,1));
    AG1(i,:)                                        = y.x(:,1);
    Astd(i,:)                                       = std(y.x);
    Istd(i,1)                                       = std(y.x(:,1));
    
    % load age-specific 7-network atlas
    AtlasL                                          = gifti(strcat('./SupportFiles/Atlas_1_26_yeo7_fs4/Atlas',num2str(g),'_FinalAtlas_fs4_L.gii'));
    AtlasR                                          = gifti(strcat('./SupportFiles/Atlas_1_26_yeo7_fs4/Atlas',num2str(g),'_FinalAtlas_fs4_R.gii'));
    Atlas                                           = [AtlasL.cdata; AtlasR.cdata];
    Atlas(Atlas==0)                                 = [];

    % compute system-level measures
    for s = 1:7
        ind_sys                                     = find(Atlas==s);
        
        Range_sys(i,s)                              = range(y.x(ind_sys,1));
        Std_sys(i,s)                                = std(y.x(ind_sys,1));
        G_sys                                       = y.x(ind_sys,1);
        G_meanscore_sys(i,s)                        = mean(G_sys);
        deltaMean(i,s)                              = mean(y.x(~(Atlas==s),1))-mean(y.x(:,1));% delta mean after removing the system
    end
end

AG1                                                 = AG1';
writematrix                                         (AG1,'./AG1.csv')

AEV1                                                = AEV(:,1);
ARange1                                             = ARange(:,1);
Astd1                                               = Astd(:,1);

Variables                                           = table(AEV1, ARange1, Astd1);
writetable                                          (Variables, './tables/Variables33247.csv')

Variables                                           = [Subinfo table(G_meanscore_sys)];
writetable                                          (Variables,'./tables/G_meanscore_sys.csv')

Variables                                           = [Subinfo table(Range_sys) table(Std_sys) table(deltaMean)];
writetable                                          (Variables,'./tables/RangeStd_deltaMeanStd_sys.csv')
