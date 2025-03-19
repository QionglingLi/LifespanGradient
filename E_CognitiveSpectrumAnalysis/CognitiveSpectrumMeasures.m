
% read the term order of reference cognitive spectrum
heatmaporder                                        = readmatrix('.\neurosynth\output\group27\heatmaporder.txt');
heatmaporder                                        = heatmaporder+1;

%% group level
Width                                               = zeros(26,24);
Median                                              = zeros(26,24);
Spearman_Median_Rank                                = zeros(26,1);
rank_sequence                                       = [1:24]'; 

for g = 1:26 % each group
    disp(num2str(g))
    decoding_results                                = importdata(['.\neurosynth\output\group27\decoding_results_G1_group',num2str(g),'.txt']);
    Z_matrix                                        = decoding_results.data;
    Z_matrix                                        = Z_matrix(heatmaporder,:);
    Z_binarized                                     = Z_matrix;
    Z_binarized(Z_binarized<3.1)                    = 0;
    
    for i = 1:size(Z_binarized,1) % each term
        nonZbin                                     = find(Z_binarized(i,:));
        Width(g,i)                                  = max(nonZbin)-min(nonZbin);
        Median(g,i)                                 = median(nonZbin);
    end
    Spearman_Median_Rank(g,1)                         = corr(Median(g,:)',rank_sequence,'type','Spearman');
end
writematrix                                         (Spearman_Median_Rank,'.\neurosynth\output\meanWidth.csv')

% average across terms
meanWidth                                           = mean(Width,2);
writematrix                                         (meanWidth,'.\neurosynth\output\Spearman_Corrs_between_MedianandSequenceRank.csv')

%% individual level
Subinfo                                             = readtable('.\tables\Subinfo_HC.csv');

for s = 1:33247
    disp(num2str(s))
    decoding_results                                = importdata(['.\neurosynth\output\individual\decoding_results_G1_age',num2str(s),'.txt']);
    Z_matrix                                        = decoding_results.data;
    Z_matrix                                        = Z_matrix(heatmaporder,:);
    Z_binarized                                     = Z_matrix;
    Z_binarized(Z_binarized<3.1)                    = 0;
    
    for i = 1:size(Z_binarized,1)
        nonZbin                                     = find(Z_binarized(i,:));
        if isempty(nonZbin)
            Width(s,i)                              = 0;
            Median(i,1)                             = 0;
        else
            Width(s,i)                              = max(nonZbin)-min(nonZbin);
            Median(i,1)                             = median(nonZbin);
        end
    end
    Scor(s,1)                                       = corr(Median,rank_sequence,'type','Spearman');
end
MeanWidth                                           = mean(Width,2);
Subinfo_CogSpectrum                                 = [Subinfo,table(Scor),table(MeanWidth),table(Width)];
writetable                                          (Subinfo_CogSpectrum,'.\tables\Subinfo_CogSpectrum.csv')
