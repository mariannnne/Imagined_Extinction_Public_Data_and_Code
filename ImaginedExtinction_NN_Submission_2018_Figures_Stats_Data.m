%% IMAGINED EXTINCTION
% final figures and statistics to accompany paper and share publicly
cd('/Users/maus/Desktop/SCR/analyses/2018_NN_Paper_Dat_and_Stat') % old folder
% /Users/maus/MausCode/Imagined_Extinction_Public_Data_and_Code %new one
addpath(genpath('/Users/maus/Documents/MATLAB/spm8/'));
addpath(genpath('/Users/maus/CanlabPrivate'));
addpath(genpath('/Users/maus/CanlabCore'));

% this script uses code from
% https://github.com/canlab

% effect size resources
% http://www.uccs.edu/lbecker/glm_effectsize.html
% http://www.statisticshowto.com/hedges-g/

%% FIGURE 1 - Method Schematic
% made in powerpoint
% share paradigm (in eprime)

%% FIGURE 2 - Multivariate Threat Signature Trained on Acquisition

% Figure 2. Imagined Extinction Reduces Whole-Brain Threat Expression. 
load IE_Figure2_TrainedThreatSignature_ForPatternAnalysis
ROC = roc_plot(stats.dist_from_hyperplane_xval, logical(stats.Y > 0), 'unpaired');
% -------------------- output --------------------
% ROC_PLOT Output: Single-interval, Optimal overall accuracy
% Threshold:	0.21	Sens:	 71% CI(61%-79%)	Spec:	 84% CI(76%-91%)	PPV:	 81% CI(72%-90%)	Nonparametric AUC:	0.82	Parametric d_a:	1.22	  Accuracy:	 77% +- 3.6% (SE), P = 0.000000

%% FIGURE 3 - Imagined Extinction Reduces Neural and Physiological Threat Expression 
% % Outlier removal for single trial model 
% -- removed trials and the trial immediately following a
% trial with a VIF > 100. 
% There were two trials removed from two subjects in NE's extinction
% period, two trials removed from one subject in SE during the acq period,
% two trials removed from one subject in IE during the extinction period,
% two trials removed from one subject in SE during re-extinction, two
% trials removed from subject in IE during re-extinction.
% [For this analysis specifically: There were only two trials during 
% re-extinction in two different
% subjects eliminated. One subject was in IE one was in SE.]

% FIG 3A
load IE_Figure3A_dat;
Plot_Title='Whole Brain Threat Pattern Expression during Recovery Test';
Y_Label='Average Pattern Expression';
ie_getstats(IE, SE, NE, Plot_Title, Y_Label);
% -------------------- output --------------------
% ---- Whole Brain Threat Pattern Expression during Recovery Test----
% sig anova
% F(2,63)=3.535460, p=0.035058, Eta Sq=0.100911, means IE: -0.202705 SE: -0.114120 NE: 0.548541
% IE v SE: t(31.842222)=-0.273660,p=0.786113, CI=[-0.748075 0.570906], STD=[1.234971 0.792197], Hedges g=-0.084661
% SE v NE: t(42.248941)=-2.404495,p=0.020655, CI=[-1.218731 -0.106590], STD=[0.792197 1.066864], Hedges g=-0.688641
% IE v NE: t(37.878622)=-2.136129,p=0.039193, CI=[-1.463270 -0.039220], STD=[1.234971 1.066864], Hedges g=-0.643777

% FIG 3B
% SCR during Late Re-Extinction / Recovery Test
close all;clear all;
load IE_Figure3B_dat;
Plot_Title='SCR during Recovery Test';
Y_Label='microsemens';
ie_getstats(IE, SE, NE, Plot_Title, Y_Label);
% -------------------- output --------------------
% ---- SCR during Recovery Test----
% sig anova
% F(2,39)=3.609121, p=0.036467, Eta Sq=0.156177, means IE: -0.000381 SE: -0.004815 NE: 0.034581
% IE v SE: t(26.468711)=0.317683,p=0.753218, CI=[-0.024229 0.033096], STD=[0.028098 0.046825], Hedges g=0.107032
% SE v NE: t(26.206415)=-2.306155,p=0.029263, CI=[-0.074497 -0.004295], STD=[0.046825 0.046012], Hedges g=-0.824712
% IE v NE: t(20.079422)=-2.312186,p=0.031495, CI=[-0.066496 -0.003429], STD=[0.028098 0.046012], Hedges g=-0.878209

% FIG 3C
% SCR during Late Re-Extinction & Threat Pattern Expression
% stored here cd('/Users/maus/Desktop/SCR/Submissions/NatureNeuroscienceArticle2017/Stats')
load IE_Figure3C_dat;
[r p]=corr(ALL42);
% -------------------- output --------------------
% r = 0.3911, p = 0.0104

%% FIGURE 4 - Extinction Connectivity Network

load IE_Figure4_dat.mat
load IE_MultiVar_Connect_SetUp.mat
% addpath('/Users/maus/CANLabRepos/trunk/densityUtility/additional_utilities_and_imgs/')

% OUT came from: canlab_connectivity_predict(dat, subject_grouping, 'partialr');
% t's from: OUT.stats.fdr_thresholded_tvalues;

% Figure 4 A-C force directed graph
% need to adjust 'names'
OUT = ieOUT;
t = iet;
[ie_stats, handles] = canlab_force_directed_graph(t,'rset', OUT.parcelindx,'cl',cl);
close all;
% change blending options of patch faces in the editor to get rid of the
% grey bands on the brain image

OUT = seOUT;
t = set;
[se_stats, handles] = canlab_force_directed_graph(t,'rset', OUT.parcelindx,'cl',cl);
close all;

OUT = neOUT;
t = net;
[ne_stats, handles] = canlab_force_directed_graph(t,'rset', OUT.parcelindx,'cl',cl);
close all;

% Figure 4D - do stats on betweenness centrality
for i = 1:size(ieOUT.betweenness_centrality,2)
    fprintf('Node: %s\n',names{i})
    % set up dat
    IE=ieOUT.betweenness_centrality(:,i);
    SE=seOUT.betweenness_centrality(:,i);
    NE=neOUT.betweenness_centrality(:,i);
    Plot_Title=names{i};
    Y_Label='Betweenness Centrality';
    ie_getstats(IE, SE, NE, Plot_Title, Y_Label);
    pause;
    figure(1);
%     saveas(gcf,sprintf('nodesize_%s.png',Plot_Title));
    close all; 
end

% subplot
fig_pos_size=[.01 .3 .3 .9];figure('units','normalized','position',fig_pos_size);

for i = 1:size(ieOUT.betweenness_centrality,2)
    subplot(3,4,i)
    IE=ieOUT.betweenness_centrality(:,i);
    SE=seOUT.betweenness_centrality(:,i);
    NE=neOUT.betweenness_centrality(:,i);
    pe_means=[mean(IE) mean(SE) mean(NE)];
    pe_ste=[ste(IE) ste(SE) ste(NE)];
    x=1:length(pe_means);wd = 0.6;
    bar(x,[pe_means(1) nan nan],wd,'FaceColor',([80/255 162/255 206/255]),'EdgeColor',([0 0 0]),'LineWidth',1.5);
    hold on
    bar(x,[nan pe_means(2) nan],wd,'FaceColor',([179/255 179/255 179/255]),'EdgeColor',([0 0 0]),'LineWidth',1.5);
    hold on
    bar(x,[nan nan pe_means(3)],wd,'FaceColor',([76/255 76/255 76/255]),'EdgeColor',([0 0 0]),'LineWidth',1.5);
    errorbar(x,pe_means,pe_ste,'.','Color','k','LineWidth',1.5);
    ylim([0 80]);
    title(sprintf('%s',names{i}),'FontSize',14); 
    hold off;
end
saveas(gcf,sprintf('nodesize_subplot_allnodes.png'));

% IE 50A2CE / [80/255 162/255 206/255]
% SE B3B3B3 / [179/255 179/255 179/255]
% NE 4C4C4C / [76/255 76/255 76/255]
% FDR corrected p = 0.0365 (for 12 tests - anovas)

% Node: L_NAc
% -------------------- output --------------------
% ---- Node Size: L_NAc Group Comparison----
% sig anova
% F(2,63)=35.166730, p=0.000000, Eta Sq=0.527500, means IE: 0.000000 SE: 23.818182 NE: 40.583333
% IE v SE: t(21.000000)=-8.039325,p=0.000000, CI=[-29.979473 -17.656890], STD=[0.000000 13.896339], Hedges g=-2.320898
% SE v NE: t(38.390517)=-3.028048,p=0.004383, CI=[-27.969709 -5.560594], STD=[13.896339 22.913669], Hedges g=-0.860582
% IE v NE: t(23.000000)=-8.676782,p=0.000000, CI=[-50.258927 -30.907739], STD=[0.000000 22.913669], Hedges g=-2.350397
% Node: L_a_cm
% -------------------- output --------------------
% ---- Node Size: L_a_cm Group Comparison----
% sig anova
% F(2,63)=58.509542, p=0.000000, Eta Sq=0.650037, means IE: 45.900000 SE: 8.090909 NE: 44.916667
% IE v SE: t(25.803196)=13.586098,p=0.000000, CI=[32.086582 43.531599], STD=[4.024922 12.351630], Hedges g=3.959133
% SE v NE: t(40.868152)=-8.142170,p=0.000000, CI=[-45.960719 -27.690796], STD=[12.351630 18.014286], Hedges g=-2.324524
% IE v NE: t(25.726404)=0.259750,p=0.797124, CI=[-6.802290 8.768957], STD=[4.024922 18.014286], Hedges g=0.070990
% Node: L_a_lb
% -------------------- output --------------------
% ---- Node Size: L_a_lb Group Comparison---- [n.s. for fdr at .05, p = 0.0365]
% sig anova
% F(2,63)=3.490030, p=0.036520, Eta Sq=0.099744, means IE: 6.400000 SE: 1.818182 NE: 4.583333
% IE v SE: t(35.004770)=2.631013,p=0.012573, CI=[1.046472 8.117164], STD=[6.344496 4.737252], Hedges g=0.808674
% SE v NE: t(43.312852)=-1.762352,p=0.085066, CI=[-5.928704 0.398401], STD=[4.737252 5.882300], Hedges g=-0.506441
% IE v NE: t(39.307953)=0.977443,p=0.334327, CI=[-1.941746 5.575079], STD=[6.344496 5.882300], Hedges g=0.292669
% Node: L_aud_te10
% -------------------- output --------------------
% ---- Node Size: L_aud_te10 Group Comparison----
% sig anova
% F(2,63)=761.660377, p=0.000000, Eta Sq=0.960285, means IE: 0.000000 SE: 21.090909 NE: 0.000000
% IE v SE: t(21.000000)=-27.598195,p=0.000000, CI=[-22.680178 -19.501640], STD=[0.000000 3.584478], Hedges g=-7.967410
% SE v NE: t(21.000000)=27.598195,p=0.000000, CI=[19.501640 22.680178], STD=[3.584478 0.000000], Hedges g=8.370982
% IE v NE: t(NaN)=NaN,p=NaN, CI=[0.000000 0.000000], STD=[0.000000 0.000000], Hedges g=NaN
% Node: L_h_ca1
% -------------------- output --------------------
% ---- Node Size: L_h_ca1 Group Comparison----
% sig anova
% F(2,63)=251.052246, p=0.000000, Eta Sq=0.888516, means IE: 0.600000 SE: 47.000000 NE: 0.083333
% IE v SE: t(21.838141)=-15.728367,p=0.000000, CI=[-52.520729 -40.279271], STD=[1.846761 13.700886], Hedges g=-4.548588
% SE v NE: t(21.034184)=16.055106,p=0.000000, CI=[40.840164 52.993170], STD=[13.700886 0.408248], Hedges g=4.869390
% IE v NE: t(20.550852)=1.226442,p=0.233900, CI=[-0.360585 1.393919], STD=[1.846761 0.408248], Hedges g=0.396913
% Node: PAG
% -------------------- output --------------------
% ---- Node Size: PAG Group Comparison----
% sig anova
% F(2,63)=46.953158, p=0.000000, Eta Sq=0.598487, means IE: 15.000000 SE: 3.090909 NE: 21.416667
% IE v SE: t(28.773944)=5.317280,p=0.000011, CI=[7.326834 16.491348], STD=[8.885233 4.849242], Hedges g=1.654982
% SE v NE: t(43.999851)=-12.257455,p=0.000000, CI=[-21.338874 -15.312641], STD=[4.849242 5.290818], Hedges g=-3.542208
% IE v NE: t(29.741949)=-2.837530,p=0.008109, CI=[-11.036654 -1.796680], STD=[8.885233 5.290818], Hedges g=-0.881995
% Node: R_NAc
% -------------------- output --------------------
% ---- Node Size: R_NAc Group Comparison----
% sig anova
% F(2,63)=21.029184, p=0.000000, Eta Sq=0.400333, means IE: 67.500000 SE: 35.272727 NE: 40.250000
% IE v SE: t(24.171260)=8.132733,p=0.000000, CI=[24.051806 40.402740], STD=[4.718385 17.915627], Hedges g=2.362776
% SE v NE: t(43.213467)=-0.834262,p=0.408721, CI=[-17.007293 7.052747], STD=[17.915627 22.452365], Hedges g=-0.239646
% IE v NE: t(25.416007)=5.794242,p=0.000005, CI=[17.572137 36.927863], STD=[4.718385 22.452365], Hedges g=1.582018
% Node: R_a_cm
% -------------------- output --------------------
% ---- Node Size: R_a_cm Group Comparison---- n.s.
% F(2,63)=1.593838, p=0.211226, Eta Sq=0.048161, means IE: 12.500000 SE: 18.272727 NE: 18.583333
% IE v SE: t(39.094058)=-1.778095,p=0.083167, CI=[-12.339051 0.793596], STD=[10.777657 10.203556], Hedges g=-0.540431
% SE v NE: t(40.429248)=-0.081876,p=0.935149, CI=[-7.975251 7.354039], STD=[10.203556 15.225598], Hedges g=-0.023354
% IE v NE: t(41.021318)=-1.546815,p=0.129589, CI=[-14.025684 1.859017], STD=[10.777657 15.225598], Hedges g=-0.445904
% Node: R_a_lb
% -------------------- output --------------------
% ---- Node Size: R_a_lb Group Comparison----
% sig anova
% F(2,63)=17.604456, p=0.000001, Eta Sq=0.358510, means IE: 9.200000 SE: 27.000000 NE: 6.416667
% IE v SE: t(39.419333)=-4.212804,p=0.000142, CI=[-26.343398 -9.256602], STD=[12.163794 15.165751], Hedges g=-1.263562
% SE v NE: t(35.891180)=5.381718,p=0.000005, CI=[12.825712 28.340955], STD=[15.165751 10.008330], Hedges g=1.588806
% IE v NE: t(36.807742)=0.818220,p=0.418497, CI=[-4.110364 9.677031], STD=[12.163794 10.008330], Hedges g=0.247681
% Node: R_aud_te10
% -------------------- output --------------------
% ---- Node Size: R_aud_te10 Group Comparison----
% sig anova
% F(2,63)=45619.843874, p=0.000000, Eta Sq=0.999310, means IE: 20.000000 SE: -0.000000 NE: 0.083333
% IE v SE: t(NaN)=Inf,p=0.000000, CI=[20.000000 20.000000], STD=[0.000000 0.000000], Hedges g=Inf
% SE v NE: t(23.000000)=-1.000000,p=0.327716, CI=[-0.255721 0.089055], STD=[0.000000 0.408248], Hedges g=-0.277490
% IE v NE: t(23.000000)=239.000000,p=0.000000, CI=[19.744279 20.089055], STD=[0.000000 0.408248], Hedges g=64.741146
% Node: R_h_ca1
% -------------------- output --------------------
% ---- Node Size: R_h_ca1 Group Comparison----
% sig anova
% F(2,63)=78.753124, p=0.000000, Eta Sq=0.714294, means IE: 13.700000 SE: -0.000000 NE: 14.666667
% IE v SE: t(19.000000)=15.677025,p=0.000000, CI=[11.870927 15.529073], STD=[3.908156 0.000000], Hedges g=4.990331
% SE v NE: t(23.000000)=-11.477789,p=0.000000, CI=[-17.310060 -12.023273], STD=[0.000000 6.260064], Hedges g=-3.184971
% IE v NE: t(39.172607)=-0.624432,p=0.535964, CI=[-4.097502 2.164168], STD=[3.908156 6.260064], Hedges g=-0.178228
% Node: vmPFC
% -------------------- output --------------------
% ---- Node Size: vmPFC Group Comparison----
% sig anova
% F(2,63)=30.785807, p=0.000000, Eta Sq=0.494267, means IE: 54.500000 SE: 33.454545 NE: 12.083333
% IE v SE: t(25.476355)=4.330761,p=0.000204, CI=[11.046551 31.044358], STD=[6.801703 21.648111], Hedges g=1.261273
% SE v NE: t(42.959511)=3.449606,p=0.001270, CI=[8.876937 33.865487], STD=[21.648111 20.246130], Hedges g=1.003721
% IE v NE: t(29.007815)=9.632054,p=0.000000, CI=[33.410196 51.423137], STD=[6.801703 20.246130], Hedges g=2.659046

% Figure 4E
% load Compare_IE_v_NE.mat
% load Compare_IE_v_SE.mat
% load Compare_SE_v_NE.mat

% IE_MultiVar_Connect_Final_NoContrast_2017.m
% ROC = roc_plot(OUT.PREDICT.pairwise_association.other_output{2}, logical(OUT.PREDICT.pairwise_association.Y > 0));
%  
% For pairwise
% ie v ne
% ROC_PLOT Output: Single-interval, Optimal overall accuracy
% Threshold:	-0.22	Sens:	 85% CI(71%-96%)	Spec:	 92% CI(81%-100%)	PPV:	 89% CI(75%-100%)	Nonparametric AUC:	0.95	Parametric d_a:	2.18	  Accuracy:	 89% +- 4.8% (SE), P = 0.000000
%  
% Ie v se
% ROC_PLOT Output: Single-interval, Optimal overall accuracy
% Threshold:	-0.16	Sens:	 85% CI(71%-100%)	Spec:	 91% CI(80%-100%)	PPV:	 89% CI(76%-100%)	Nonparametric AUC:	0.92	Parametric d_a:	1.90	  Accuracy:	 88% +- 5.0% (SE), P = 0.000000
%  
% Se v ne
% ROC_PLOT Output: Single-interval, Optimal overall accuracy
% Threshold:	-0.10	Sens:	100% CI(100%-100%)	Spec:	 83% CI(71%-96%)	PPV:	 85% CI(73%-96%)	Nonparametric AUC:	0.97	Parametric d_a:	2.50	  Accuracy:	 91% +- 4.2% (SE), P = 0.000000


%% Figure 5 - IMAGINED EXTINCTION ACTIVATION IN UNIVARIATE ROIS

% Single trial model outlier removal (same as before)
% -- removed trials and the trial immediately following a
% trial with a VIF > 100. There were only two trials in four different
% subjects eliminated. two subjects in NE, One subject was in IE one was in SE.
% removed one trial from vmpfc data that was more than 25x the std from
% mean

% FIG 4A - vmPFC
% avg univariate activation during extinction
load IE_Figure5A_dat
% rm anova on across all phases
t = table(group,ALL(:,1),ALL(:,2),ALL(:,3),ALL(:,4),ALL(:,5),ALL(:,6),ALL(:,7),...
'VariableNames',{'group','acq','ext1','ext2','ext3','ext4','reext1','reext2'});
Meas = dataset([1 2 3 4 5 6 7]','VarNames',{'Measurements'});
rm = fitrm(t,'acq-reext2~group','WithinDesign',Meas);
ranovatbl = ranova(rm);
%                                 SumSq     DF     MeanSq       F        pValue      pValueGG    pValueHF    pValueLB
%                                 ______    ___    _______    ______    _________    ________    ________    ________
% 
%     (Intercept):Measurements      8.92      6     1.4867    3.7181    0.0013222    0.017482    0.015966    0.058335
%     group:Measurements          8.7903     12    0.73252     1.832     0.041645     0.10765     0.10405     0.16852
%     Error(Measurements)         151.14    378    0.39984                                                           
NE=ALL(1:24,1:end);
SE=ALL(25:46,1:end);
IE=ALL(47:end,1:end);
Plot_Title='vmPFC activation across all Phases';
Y_Label=sprintf('Differential (CS+ > CS-) \n Beta Weights');
ie_get_lineplot(IE, SE, NE, Plot_Title, Y_Label)

% POST HOC ANALYSIS
% extinction timepoint 3
NE=ALL(1:24,4);
SE=ALL(25:46,4);
IE=ALL(47:end,4);
Plot_Title='vmPFC activity Ext Tp3';
Y_Label='avg univariate activation';
ie_getstats(IE, SE, NE, Plot_Title, Y_Label);
% -------------------- output -------------------- UPDATED
% ---- vmPFC activity Ext Tp3----
% sig anova
% F(2,63)=3.448032, p=0.037929, Eta Sq=0.098662, means IE: 0.287539 SE: 0.295542 NE: -0.070659
% IE v SE: t(39.014477)=-0.044879,p=0.964433, CI=[-0.368686 0.352680], STD=[0.593766 0.558343], Hedges g=-0.013645
% SE v NE: t(41.257217)=2.394899,p=0.021248, CI=[0.057454 0.674948], STD=[0.558343 0.470169], Hedges g=0.700047
% IE v NE: t(35.937537)=2.186465,p=0.035376, CI=[0.025925 0.690471], STD=[0.593766 0.470169], Hedges g=0.664122

% late re-ext post hoc tests
NE=ALL(1:24,7);
SE=ALL(25:46,7);
IE=ALL(47:end,7);
Plot_Title='vmPFC activity Late Re-Extinction';
Y_Label='avg univariate activation';
ie_getstats(IE, SE, NE, Plot_Title, Y_Label);
% -------------------- output --------------------
% ---- vmPFC activity Late Re-Extinction----
% F(2,63)=1.108448, p=0.336421, Eta Sq=0.033993, means IE: 0.075482 SE: 0.113296 NE: -0.046079
% IE v SE: t(36.708924)=-0.298076,p=0.767326, CI=[-0.294921 0.219295], STD=[0.323663 0.488684], Hedges g=-0.088651
% SE v NE: t(34.406868)=1.316791,p=0.196612, CI=[-0.086486 0.405237], STD=[0.488684 0.301750], Hedges g=0.389695
% IE v NE: t(39.411388)=1.279119,p=0.208335, CI=[-0.070602 0.313725], STD=[0.323663 0.301750], Hedges g=0.382801

%% FIGURE 6 - PREDICT THREAT RECOVERY
% this analysis runs an OLS regression for each group on the whole brain
% univariate maps of CS+>CS- in extinction timepoint 3 with subject threat
% pattern expression during late extinction as the predictor
% the purpose is to find a brain activity during extinction that is related
% to the amount of 'threat' they extinguish

load IE_Figure6_dat
% extract white matter
ie_m = extract_gray_white_csf(IE);
se_m = extract_gray_white_csf(SE);
ne_m = extract_gray_white_csf(NE);
% mean-center success scores and attach them to dat in dat.X
IE.X = [scale(IE_PE, 1) ie_m(:,2:3)];
SE.X = [scale(SE_PE, 1) se_m(:,2:3)];
NE.X = [scale(NE_PE, 1) ne_m(:,2:3)];
% run the regresion, OL with nuisnace
IE_out = regress(IE,.05, 'fdr');
SE_out = regress(SE,.05, 'fdr');
NE_out = regress(NE,.05, 'fdr');

% make plots and table
load IE_threatrec_OLSregress_wm_csf_nuisance_statsimg %only regressor of interest
sp_color={[0 0 1] [0 1 1] [1 .5 0] [1 1 0]}; %regular
ie_p=IE_out.t.threshold(1);
se_p=SE_out.t.threshold(1);
% plot fdr corr sig neg clusters only
ie_datT=fmri_data(IE_out.t);
ie_datT.dat=datT.dat .* (IE_out.t.p<ie_p);
ie_datT.dat=datT.dat .* (IE_out.t.dat<0);

se_datT=fmri_data(SE_out.t);
se_datT.dat=se_datT.dat .* (SE_out.t.p<se_p);
se_datT.dat=se_datT.dat .* (SE_out.t.dat<0);

for g=1:2
    if g ==1
        cl=region(datT); name='IE_NEG'; display('IMAGINED');
    elseif g ==2
        cl=region(se_datT); name='SE_NEG'; display('STANDARD');
    end
    o2 = fmridisplay;o2 = montage(o2, 'saggital', 'slice_range', [40 55], 'onerow', 'spacing', 5);
    o2=addblobs(o2,cl,'splitcolor', sp_color);
    o2=addblobs(o2,cl,'color',[0 0 0],'outline');
    saveas(gcf, sprintf('IE_SuppFig_3rdExtCorrThreatPE_wmcontrol_fdr05_t_map_%s_sag1.png',name));

    close all;
    o2 = fmridisplay;o2 = montage(o2, 'saggital', 'slice_range', [-5 5], 'onerow', 'spacing', 5);
    o2=addblobs(o2,cl,'splitcolor', sp_color);
    o2=addblobs(o2,cl,'color',[0 0 0],'outline');
    saveas(gcf, sprintf('IE_SuppFig_3rdExtCorrThreatPE_wmcontrol_fdr05_t_map_%s_sag2.png',name));

    close all;
    o2 = fmridisplay;o2 = montage(o2, 'saggital', 'slice_range', [-55 -40], 'onerow', 'spacing', 5);
    o2=addblobs(o2,cl,'splitcolor', sp_color);
    o2=addblobs(o2,cl,'color',[0 0 0],'outline');
    saveas(gcf, sprintf('IE_SuppFig_3rdExtCorrThreatPE_wmcontrol_fdr05_t_map_%s_sag3.png',name));

    close all;o2 = canlab_results_fmridisplay_marianne([],'full');
    o2=addblobs(o2,cl,'splitcolor', sp_color);
    o2=addblobs(o2,cl,'color',[0 0 0],'outline');
    saveas(gcf, sprintf('IE_SuppFig_3rdExtCorrThreatPE_wmcontrol_fdr05_t_map_%s_full.png',name));

    close all;
end

%% SUPPLEMENTARY

%% Supplementary Table 1 - Table of regions from threat signature
cl = region(THREAT)
cluster_table(cl, 1, 1,'writefile','ThreatMap_Fdr05_cluster_table');

%% Supplementary 2 - Univariate version of threat signature + table
load IE_SuppFigure2_dat %relocate
cl=region(statsimg)
o2 = canlab_results_fmridisplay_marianne([],'full');
o2=addblobs(o2,cl,'splitcolor', {[0 0 1] [0 1 1] [1 .5 0] [1 1 0]});
o2=addblobs(o2,cl,'color',[0 0 0],'outline','transparent');
legend(o2);
cluster_table(cl,1,1,'writefile','IE_Supp_UnivariateAcqMap_Fdr05_k_cluster_table');

%% Supplementary 3 - Amygdala ROI Threat Recovery
% bilateral amygdala roi from FSL (1675 voxels)applied to whole brain
% classifier from Fig 2, this partial pattern is applied to late
% re-extinciton contrast images (CS+ & CS-) from all 66 subj

% example code -- needs imaging data
[pattern_exp_values] = apply_mask(test_dat, wtmap, 'pattern_expression', 'ignore_missing');
pattern_exp_values = pattern_exp_values + stats.other_output{3};
roc = roc_plot(pattern_exp_values,ie_dat.Y > 0, 'twochoice');

% Imagined extinction
% -------------------PHASE: L Reext-------------------
% ROC for two-choice classification of paired observations.
% Assumes pos and null outcome observations have the same subject order.
% Using a priori threshold of 0 for pairwise differences.
% 
% ROC_PLOT Output: Two-alternative forced choice, A priori threshold
% Threshold:	0.00	Sens:	 50% CI(30%-69%)	Spec:	 50% CI(31%-67%)	PPV:	 50% CI(31%-68%)	Nonparametric AUC:	0.56	Parametric d_a:	0.06	  Accuracy:	 50% +- 11.2% (SE), P = 1.000000
% 
% 
% Standard extinction
% ROC for two-choice classification of paired observations.
% Assumes pos and null outcome observations have the same subject order.
% Using a priori threshold of 0 for pairwise differences.
% 
% ROC_PLOT Output: Two-alternative forced choice, A priori threshold
% Threshold:	0.00	Sens:	 50% CI(32%-67%)	Spec:	 50% CI(32%-68%)	PPV:	 50% CI(32%-69%)	Nonparametric AUC:	0.45	Parametric d_a:	-0.26	  Accuracy:	 50% +- 10.7% (SE), P = 1.000000
% 
% No extinction
% -------------------ACC: 1-------------------
% -------------------PHASE: L Reext-------------------
% ROC for two-choice classification of paired observations.
% Assumes pos and null outcome observations have the same subject order.
% Using a priori threshold of 0 for pairwise differences.
% 
% ROC_PLOT Output: Two-alternative forced choice, A priori threshold
% Threshold:	0.00	Sens:	 75% CI(61%-88%)	Spec:	 75% CI(60%-89%)	PPV:	 75% CI(60%-89%)	Nonparametric AUC:	0.77	Parametric d_a:	0.59	  Accuracy:	 75% +- 8.8% (SE), P = 0.022656

%% Supplementary 4 - SCR
% done in R - LMER
% IE_LMER_SCR_66.csv
% IE_LMER_SCR_42.csv
% IE_SuppFig4_MixedModel_SCR.R

%% Supplementary 5 - vmPFC pattern during extincton tp 3
% done in R
% dat = dat_iesene_vmpfc_3rdtp_forpermute.csv
% IE_SuppFig5_Permute_Test_vmPFCspatialpattern_R.R

%% Supplementary 5 - exploratory correlations with vmPFC during extinction
% Figure 5. Strength of vmPFC activation during extinction timepoint 3 in relation to ROIS
% make correlation plots
load IE_SuppFigure6_dat % for threat expression in late re-extinction
% rangenorm was for plotting purposes only
% FOR vmPFC ACTIVATION CORRELATION
% y is vmpfc, x is uni var
Y_Label='vmPFC';
X_Label={'CA1','Te1.0','NAc','Amyg'};Plot_Title='Extinction Tp3';
IE_Y=rangenorm(mean(ie_vm.dat)');
IE_X=rangenorm([mean(ie_ca1.dat)' mean(ie_te1.dat)' mean(ie_nc.dat)' mean(ie_am.dat)']);

SE_Y=rangenorm(mean(se_vm.dat)');
SE_X=rangenorm([mean(se_ca1.dat)' mean(se_te1.dat)' mean(se_nc.dat)' mean(se_am.dat)']);

NE_Y=rangenorm(mean(ne_vm.dat)');
NE_X=rangenorm([mean(ne_ca1.dat)' mean(ne_te1.dat)' mean(ne_nc.dat)' mean(ne_am.dat)']);

ie_get_corr_statsplot_multirows(IE_Y, SE_Y, NE_Y, IE_X, SE_X, NE_X, Plot_Title, Y_Label, X_Label)

%test group differences in correlations, correct for mc
% http://vassarstats.net/rdiff.html
% vmpfc - CA1
% ie v se z=5.07,  p <.00001 (one and two tail)
% ie v ne z=0.8, p 1 tail 0.2119, p two tail= 0.4237
% ne v se z=-4.52, p <.00001 (one and two tail)
% vmpfc - Te1
% ie v se z=0.37, one tail 0.3557, two tail 0.7114
% ie v ne z=-1.35, one tail p = 0.0885, two tail p = 0.177
% ne v se z=-1.78, one tail p = 0.0375, two tail p=0.0751
% vmpfc - NAC
% ie v ne  z=  1.88 , one tail p = 0.0301, two tail p = 0.0601
% ie v se  z=  -3.61 , one tail p = 0.0002, two tail p = 0.0003
% ne v se  z=  -5.75 , p <.00001 (one and two tail)=
% vmpfc - Amyg
% ie v se z=1.79, one tail 0.0367, two tail 0.0735
% ie v ne z=-0.12, one tail = 0.4522, two tail 0.9045
% ne v se z=-2.01, one tail p =0.0222, two tail p=0.0444
