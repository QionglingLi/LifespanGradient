Yeo_colors                                      = [120, 18, 134; 70, 130, 180; 0, 118, 14; 196, 58, 250; 220, 248, 164; 230, 148, 34; 205, 62, 78];

Variables                                       = readtable('.\tables\RangeStd_deltaMeanStd_sys.csv');
SubID                                           = Variables.SubID;
Age                                             = Variables.Age;

Stag                                            = zeros(size(Variables,1),1);
Stag(Age<0.125)                                 = 1;
Stag((0.125<=Age)& (Age<5))                     = 2;
Stag(Age>=5)                                    = 3;

data                                            = abs([Variables.deltaMean_1 Variables.deltaMean_2 Variables.deltaMean_3...
                                                    Variables.deltaMean_4 Variables.deltaMean_5 Variables.deltaMean_6 Variables.deltaMean_7]);
% bar plot
for i = 1:3
   for j = 1:7
       stage_y(i,j)                             = mean(abs(data(Stag==i,j)));
   end    
end

figure;
h                                               = bar(stage_y,'stacked');
for j = 1:size(stage_y, 2)
    for i = 1:size(stage_y, 1)
        h(j).FaceColor                          = 'flat';
        h(j).CData(i,:)                         = Yeo_colors(j,:)/255;
    end
end
xticklabels                                     ({'Phase 1', 'Phase 2', 'Phase 3'})

print                                           (strcat('.\NC_model\figures\trajectory\deltaDispersion_Individual.pdf'), '-dpdf', ['-r' '600'],'-bestfit')

%% anova analysis at individual level
numSubjects                                     = size(data, 1);
numMeasures                                     = size(data,2);

% fit repeated ANOVA model
T                                               = table(data(:,1), data(:,2), data(:,3), data(:,4), data(:,5), data(:,6), data(:,7), categorical(Stag), Age,...
                                                    'VariableNames', {'Measure1', 'Measure2', 'Measure3', 'Measure4', 'Measure5', 'Measure6', 'Measure7', 'Stag', 'Age'});
WithinDesign                                    = table((1:numMeasures)', 'VariableNames', {'Measure'});
rm                                              = fitrm(T, 'Measure1-Measure7 ~ 1 + Stag + Age', 'WithinDesign', WithinDesign);
ranovaResults                                   = ranova(rm);

disp(ranovaResults);

% post hoc test for measures
posthocMeasure                                  = multcompare(rm, 'Measure', 'ComparisonType', 'bonferroni');
disp(posthocMeasure);
writetable                                      (posthocMeasure,'.\NC_model\figures\trajectory\RangeStd_deltaMeanStd_sys_ANOVA_measures.csv');

% post hoc test for stage
posthocStag                                     = multcompare(rm, 'Stag', 'ComparisonType', 'bonferroni');
disp(posthocStag);
writetable                                      (posthocStag,'.\NC_model\figures\trajectory\RangeStd_deltaMeanStd_sys_ANOVA_stages.csv');

for s = 1:3
    Sindex                                      = (Stag==s); 
    T                                           = table(data(Sindex,1), data(Sindex,2), data(Sindex,3), data(Sindex,4), data(Sindex,5), data(Sindex,6), data(Sindex,7), Age(Sindex),...
                                                    'VariableNames', {'Measure1', 'Measure2', 'Measure3', 'Measure4', 'Measure5', 'Measure6', 'Measure7',  'Age'});
    WithinDesign                                = table((1:numMeasures)', 'VariableNames', {'Measure'});

    rm                                          = fitrm(T, 'Measure1-Measure7 ~ 1 + Age', 'WithinDesign', WithinDesign);
    ranovaResults                               = ranova(rm);

    disp(ranovaResults);

    % post hoc test for measures
    posthocMeasure                              = multcompare(rm, 'Measure', 'ComparisonType', 'bonferroni');
    disp(posthocMeasure);
    writetable                                  (posthocMeasure,strcat('.\NC_model\figures\trajectory\RangeStd_deltaMeanStd_sys_ANOVA_measures',num2str(s),'.csv'));    
end
