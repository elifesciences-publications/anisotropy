%   PLOT_SpatioTemporalAnalysisResults.m
%   Anders Sejr Hansen, October 2017
clear; clc; colour = jet; close all;

%   DESCRIPTION
%   This script will load a structured array with all the data from
%   SpatioTemporal angle analysis fpr several cell lines/samples and then
%   do a number of hopefully informative plots

%   UPDATE - v2
%   When plot anisotropy metrics over space, average over all timepoints.

%   UPDATE - v4
%   When analyzing displacements over lengths, you will have much fewer
%   angles for the long lag times. So weigh the angle metrics according to
%   the number of angles for each time point
%   Also plot metrics for MIN instead of MEAN displacement
%   Finally plot the full spatiotemporal matrix, where the first dimension
%   is the first jump and the second dimension is the second jump

DataSet = 12;
c_map = [1,1,1;1,1,0.992156862745098;1,1,0.984313725490196;1,1,0.976470588235294;1,1,0.968627450980392;1,1,0.960784313725490;1,1,0.952941176470588;1,1,0.945098039215686;1,1,0.937254901960784;1,1,0.929411764705882;1,1,0.921568627450980;1,1,0.913725490196078;1,1,0.905882352941177;1,1,0.898039215686275;1,1,0.890196078431373;1,1,0.882352941176471;1,1,0.874509803921569;1,1,0.866666666666667;1,1,0.858823529411765;1,1,0.850980392156863;1,1,0.843137254901961;1,1,0.835294117647059;1,1,0.827450980392157;1,1,0.819607843137255;1,1,0.811764705882353;1,1,0.803921568627451;1,1,0.796078431372549;1,1,0.788235294117647;1,1,0.780392156862745;1,1,0.772549019607843;1,1,0.764705882352941;1,1,0.756862745098039;1,1,0.749019607843137;1,1,0.741176470588235;1,1,0.733333333333333;1,1,0.725490196078431;1,1,0.717647058823529;1,1,0.709803921568628;1,1,0.701960784313725;1,1,0.694117647058824;1,1,0.686274509803922;1,1,0.678431372549020;1,1,0.674509803921569;1,1,0.666666666666667;1,1,0.658823529411765;1,1,0.650980392156863;1,1,0.643137254901961;1,1,0.635294117647059;1,1,0.627450980392157;1,1,0.619607843137255;1,1,0.611764705882353;1,1,0.603921568627451;1,1,0.596078431372549;1,1,0.588235294117647;1,1,0.580392156862745;1,1,0.572549019607843;1,1,0.564705882352941;1,1,0.556862745098039;1,1,0.549019607843137;1,1,0.541176470588235;1,1,0.533333333333333;1,1,0.525490196078431;1,1,0.517647058823530;1,1,0.509803921568627;1,1,0.501960784313726;1,0.992156862745098,0.494117647058824;1,0.984313725490196,0.486274509803922;1,0.976470588235294,0.478431372549020;1,0.968627450980392,0.470588235294118;1,0.960784313725490,0.462745098039216;1,0.949019607843137,0.454901960784314;1,0.945098039215686,0.447058823529412;1,0.933333333333333,0.439215686274510;1,0.929411764705882,0.431372549019608;1,0.921568627450980,0.423529411764706;1,0.913725490196078,0.415686274509804;1,0.905882352941177,0.407843137254902;1,0.898039215686275,0.400000000000000;1,0.890196078431373,0.392156862745098;1,0.882352941176471,0.384313725490196;1,0.874509803921569,0.376470588235294;1,0.866666666666667,0.368627450980392;1,0.858823529411765,0.360784313725490;1,0.850980392156863,0.352941176470588;1,0.843137254901961,0.345098039215686;1,0.835294117647059,0.337254901960784;1,0.827450980392157,0.329411764705882;1,0.819607843137255,0.317647058823529;1,0.811764705882353,0.309803921568627;1,0.803921568627451,0.301960784313725;1,0.796078431372549,0.294117647058824;1,0.788235294117647,0.286274509803922;1,0.780392156862745,0.278431372549020;1,0.772549019607843,0.270588235294118;1,0.764705882352941,0.262745098039216;1,0.756862745098039,0.254901960784314;1,0.749019607843137,0.247058823529412;1,0.741176470588235,0.239215686274510;1,0.733333333333333,0.231372549019608;1,0.725490196078431,0.223529411764706;1,0.717647058823529,0.215686274509804;1,0.709803921568628,0.207843137254902;1,0.701960784313725,0.200000000000000;1,0.694117647058824,0.192156862745098;1,0.686274509803922,0.184313725490196;1,0.678431372549020,0.176470588235294;1,0.670588235294118,0.168627450980392;1,0.662745098039216,0.160784313725490;1,0.654901960784314,0.152941176470588;1,0.647058823529412,0.145098039215686;1,0.639215686274510,0.137254901960784;1,0.631372549019608,0.129411764705882;1,0.623529411764706,0.121568627450980;1,0.615686274509804,0.113725490196078;1,0.607843137254902,0.105882352941176;1,0.600000000000000,0.0980392156862745;1,0.592156862745098,0.0901960784313726;1,0.584313725490196,0.0823529411764706;1,0.576470588235294,0.0745098039215686;1,0.568627450980392,0.0666666666666667;1,0.560784313725490,0.0588235294117647;1,0.552941176470588,0.0509803921568627;1,0.541176470588235,0.0431372549019608;1,0.533333333333333,0.0352941176470588;1,0.525490196078431,0.0274509803921569;1,0.517647058823530,0.0196078431372549;1,0.513725490196078,0.0117647058823529;1,0.505882352941176,0.00392156862745098;0.996078431372549,0.494117647058824,0;0.988235294117647,0.490196078431373,0;0.980392156862745,0.478431372549020,0;0.972549019607843,0.474509803921569,0;0.964705882352941,0.462745098039216,0;0.956862745098039,0.454901960784314,0;0.949019607843137,0.450980392156863,0;0.941176470588235,0.443137254901961,0;0.933333333333333,0.435294117647059,0;0.925490196078431,0.427450980392157,0;0.917647058823529,0.419607843137255,0;0.909803921568627,0.411764705882353,0;0.901960784313726,0.400000000000000,0;0.894117647058824,0.392156862745098,0;0.890196078431373,0.384313725490196,0;0.882352941176471,0.380392156862745,0;0.874509803921569,0.368627450980392,0;0.866666666666667,0.364705882352941,0;0.858823529411765,0.356862745098039,0;0.850980392156863,0.349019607843137,0;0.843137254901961,0.341176470588235,0;0.835294117647059,0.329411764705882,0;0.827450980392157,0.325490196078431,0;0.819607843137255,0.317647058823529,0;0.811764705882353,0.309803921568627,0;0.803921568627451,0.301960784313725,0;0.796078431372549,0.294117647058824,0;0.788235294117647,0.286274509803922,0;0.780392156862745,0.274509803921569,0;0.772549019607843,0.266666666666667,0;0.764705882352941,0.258823529411765,0;0.756862745098039,0.250980392156863,0;0.749019607843137,0.247058823529412,0;0.741176470588235,0.239215686274510,0;0.733333333333333,0.231372549019608,0;0.725490196078431,0.223529411764706,0;0.717647058823529,0.211764705882353,0;0.709803921568628,0.203921568627451,0;0.701960784313725,0.200000000000000,0;0.694117647058824,0.192156862745098,0;0.686274509803922,0.184313725490196,0;0.682352941176471,0.172549019607843,0;0.674509803921569,0.164705882352941,0;0.666666666666667,0.156862745098039,0;0.658823529411765,0.152941176470588,0;0.650980392156863,0.145098039215686,0;0.643137254901961,0.133333333333333,0;0.635294117647059,0.129411764705882,0;0.627450980392157,0.121568627450980,0;0.619607843137255,0.113725490196078,0;0.611764705882353,0.105882352941176,0;0.603921568627451,0.0980392156862745,0;0.596078431372549,0.0862745098039216,0;0.588235294117647,0.0784313725490196,0;0.580392156862745,0.0705882352941177,0;0.572549019607843,0.0666666666666667,0;0.564705882352941,0.0549019607843137,0;0.556862745098039,0.0509803921568627,0;0.549019607843137,0.0431372549019608,0;0.541176470588235,0.0352941176470588,0;0.533333333333333,0.0235294117647059,0;0.525490196078431,0.0156862745098039,0;0.517647058823530,0.00784313725490196,0;0.509803921568627,0,0;0.501960784313726,0,0;0.494117647058824,0,0;0.486274509803922,0,0;0.478431372549020,0,0;0.470588235294118,0,0;0.462745098039216,0,0;0.454901960784314,0,0;0.447058823529412,0,0;0.439215686274510,0,0;0.431372549019608,0,0;0.423529411764706,0,0;0.415686274509804,0,0;0.407843137254902,0,0;0.400000000000000,0,0;0.392156862745098,0,0;0.384313725490196,0,0;0.376470588235294,0,0;0.368627450980392,0,0;0.360784313725490,0,0;0.352941176470588,0,0;0.345098039215686,0,0;0.337254901960784,0,0;0.325490196078431,0,0;0.317647058823529,0,0;0.309803921568627,0,0;0.301960784313725,0,0;0.294117647058824,0,0;0.286274509803922,0,0;0.278431372549020,0,0;0.270588235294118,0,0;0.262745098039216,0,0;0.254901960784314,0,0;0.247058823529412,0,0;0.239215686274510,0,0;0.231372549019608,0,0;0.223529411764706,0,0;0.215686274509804,0,0;0.207843137254902,0,0;0.200000000000000,0,0;0.192156862745098,0,0;0.184313725490196,0,0;0.176470588235294,0,0;0.168627450980392,0,0;0.160784313725490,0,0;0.152941176470588,0,0;0.145098039215686,0,0;0.137254901960784,0,0;0.129411764705882,0,0;0.121568627450980,0,0;0.113725490196078,0,0;0.101960784313725,0,0;0.0941176470588235,0,0;0.0862745098039216,0,0;0.0784313725490196,0,0;0.0705882352941177,0,0;0.0627450980392157,0,0;0.0549019607843137,0,0;0.0470588235294118,0,0;0.0392156862745098,0,0;0.0313725490196078,0,0;0.0235294117647059,0,0;0.0156862745098039,0,0;0.00784313725490196,0,0;0,0,0];
plot_path = './2018_April_Plots/';


% Load the appropriate dataset
if DataSet == 1
    load('full_dataset_20171028_AllExp_50nmSteps_v2.mat');
    SaveAppend = '_v2';
elseif DataSet == 2
    load('full_dataset_20171028_MatchedSims_50nmSteps_v2.mat');
    SaveAppend = '_v2';
elseif DataSet == 3
    load('full_dataset_20171028_AllExp_150nmGlobalMin_v2.mat');
    SaveAppend = '_min150_v2';
elseif DataSet == 4
    load('full_dataset_20171028_MatchedSims_150nmGlobalMin_v2.mat');
    SaveAppend = '_min150_v2';
elseif DataSet == 5
    load('full_dataset_20171031_AllExp_HMMfirst.mat');
    SaveAppend = '_HMMfirst';
elseif DataSet == 6
    load('full_dataset_20171031_MatchedSims_HMMfirst.mat');
    SaveAppend = '_HMMfirst';
elseif DataSet == 7
    load('full_dataset_20180216_AssafSims_HMMfirst.mat');
    SaveAppend = '_HMMfirst';
elseif DataSet == 8
    load('full_dataset_20180220_AssafSims_HMMfirst.mat');
    SaveAppend = '_HMMfirst';
elseif DataSet == 9
    load('full_dataset_20180220_RNA_mutant_HMMfirst.mat');
    SaveAppend = '_HMMfirst';
elseif DataSet == 10
    load('full_dataset_20180304_RNA_mutant_HMMfirst');
    SaveAppend = '_HMMfirst';
elseif DataSet == 11
    load('20180409_FinalResults_HMMfirst');
    SaveAppend = 'HMMfirst';
elseif DataSet == 12
    load('20180529_D2_RBR_FinalResults_HMMfirst');
    SaveAppend = 'HMMfirst';
end

% Loop over all the samples:
for SampleIter = 1:length(FinalResults)
    tic;
    close; close;
    %figure1 = figure('position',[10 100 600 1000]); %[x y width height] 
    figure1 = figure('position',[10 100 900 1400]); %[x y width height] 
    
    % make the legend:
    legend_info = {''};
    for TimeIter = 1:length(FinalResults(1,SampleIter).FrameRates)
        legend_info{TimeIter} = FinalResults(1,SampleIter).FrameRates(1,TimeIter).FrameRate;
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%% SUB-PLOT 1 to 3: ANGLE DISTRIBUTION FOR 223, 133 and 74 Hz %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% 223 Hz plot: TimeIter = 1
    %%% 133 Hz plot: TimeIter = 2
    %%% 74 Hz plot: TimeIter = 3
    for TimeIter = 1:3
        subplot(5,3,TimeIter);
        %Max limit:
        MaxLim = max([0.04 1.01*max(FinalResults(1,SampleIter).AllVals{TimeIter})]);
        h = polar(0,MaxLim);
        delete(h);
        set(gca, 'Nextplot','add')
        %# draw patches instead of lines: polar(t,r)
        [x,y] = pol2cart(FinalResults(1,SampleIter).Alla{TimeIter},FinalResults(1,SampleIter).AllVals{TimeIter});
        h = patch(reshape(x,4,[]), reshape(y,4,[]), [237/255, 28/255, 36/255]);
        title({[FinalResults(1,SampleIter).SampleName, FinalResults(1,SampleIter).FrameRates(1,TimeIter).FrameRate, ': angles'];...
                ['AC = ', num2str(FinalResults(1,SampleIter).mean_AC(1,TimeIter)), ...
                    ' +/- ', num2str(std(FinalResults(1,SampleIter).jack_AC{TimeIter}))];...
                ['f(180/0) = ', num2str(FinalResults(1,SampleIter).mean_f_180_0(1,TimeIter)), ...
                    ' +/- ', num2str(std(FinalResults(1,SampleIter).jack_f_180_0{TimeIter}))];}...
                ,'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
        xlabel('angle (degrees)', 'FontSize',9, 'FontName', 'Helvetica');
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%% SUB-PLOT 4 to 6: ANGLE HISTOGRAMS FOR 223, 133 and 74 Hz %%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % first generate the required index_vectors:
    normPDF = FinalResults(1,SampleIter).normPDF{1};
        % x-vector for displaying the angles
        x_index_vector = [1;];
        for i=2:length(normPDF)
            x_index_vector = [x_index_vector, i, i];
        end
        x_index_vector = [x_index_vector, length(normPDF)+1];
        y_index_vector = [];
        for i=1:length(normPDF)
            y_index_vector = [y_index_vector, i, i];
        end
        x_theta = 0:1/length(normPDF):1;
    
    %%% 223 Hz plot: TimeIter = 1
    %%% 133 Hz plot: TimeIter = 2
    %%% 74 Hz plot: TimeIter = 3
    for TimeIter = 1:3
        subplot(5,3,TimeIter+3);
        hold on;
        plot(x_theta(x_index_vector), FinalResults(1,SampleIter).normPDF{1,TimeIter}(y_index_vector), '-', 'LineWidth', 2, 'Color', 'r');
        title({[FinalResults(1,SampleIter).SampleName, FinalResults(1,SampleIter).FrameRates(1,TimeIter).FrameRate, ': angles'];...
                    ['Amp = ', num2str(FinalResults(1,SampleIter).mean_Amp(1,TimeIter)), ...
                        ' +/- ', num2str(std(FinalResults(1,SampleIter).jack_Amp{TimeIter}))];...
                    ['FWHM = ', num2str(FinalResults(1,SampleIter).mean_FWHM(1,TimeIter)), ...
                        ' +/- ', num2str(std(FinalResults(1,SampleIter).jack_FWHM{TimeIter}))];}...
                    ,'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
        xlabel('\theta / 2\pi', 'FontSize',9, 'FontName', 'Helvetica');
        ylabel('probability', 'FontSize',9, 'FontName', 'Helvetica');
        legend('angle PDF', 'Location', 'NorthEast');
        legend boxoff
        axis([0 1 0 0.085]);
        hold off;
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% SUB-PLOT 7 to 9: METRICS vs. TimeLag %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Plot Amp, f(180/0) and FWHM as a function of time with error bars
    % First need to get the standard deviations
    std_Amp = zeros(1,length(FinalResults(1,SampleIter).mean_Amp));
    std_f_180_0 = zeros(1,length(FinalResults(1,SampleIter).mean_f_180_0));
    std_FWHM = zeros(1,length(FinalResults(1,SampleIter).mean_FWHM));
    time_vector = zeros(1,length(FinalResults(1,SampleIter).FrameRates));
    for TimeIter = 1:length(std_Amp)
        std_Amp(1,TimeIter) = std(FinalResults(1,SampleIter).jack_Amp{TimeIter});
        std_f_180_0(1,TimeIter) = std(FinalResults(1,SampleIter).jack_f_180_0{TimeIter});
        std_FWHM(1,TimeIter) = std(FinalResults(1,SampleIter).jack_FWHM{TimeIter});
        time_vector(1,TimeIter) = 1000*FinalResults(1,SampleIter).FrameRates(1,TimeIter).LagTime;
    end
    
    % Plot Amp vs. time
    subplot(5,3,7);
    hold on;
    plot(time_vector, FinalResults(1,SampleIter).mean_Amp, 'k--', 'LineWidth', 1);
    errorbar(time_vector, FinalResults(1,SampleIter).mean_Amp, std_Amp, 'ko', 'MarkerSize', 6, 'MarkerFaceColor',[237/255, 28/255, 36/255]);
    title([FinalResults(1,SampleIter).SampleName, ' Amp vs. time'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    ylabel('amplitude', 'FontSize',9, 'FontName', 'Helvetica');
    xlabel('lag time (ms)', 'FontSize',9, 'FontName', 'Helvetica');
    max_y = 0.26;
    if mean(FinalResults(1,SampleIter).mean_Amp) > max_y
        max_y = 0.71;
    end
    axis([0 1.02*max(time_vector) 0 max_y]);
    hold off;
    
    % Plot f(180/0) vs. time
    subplot(5,3,8);
    hold on;
    plot(time_vector, FinalResults(1,SampleIter).mean_f_180_0, 'k--', 'LineWidth', 1);
    errorbar(time_vector, FinalResults(1,SampleIter).mean_f_180_0, std_f_180_0, 'ko', 'MarkerSize', 6, 'MarkerFaceColor',[237/255, 28/255, 36/255]);
    plot([0 1.02*max(time_vector)], [1 1], 'k--', 'LineWidth', 1);
    title([FinalResults(1,SampleIter).SampleName, ' f(180/0) vs. time'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    ylabel('fold(180+/-30 / 0+/-30)', 'FontSize',9, 'FontName', 'Helvetica');
    xlabel('lag time (ms)', 'FontSize',9, 'FontName', 'Helvetica');
    max_y = 3.1;
    if mean(FinalResults(1,SampleIter).mean_f_180_0) > max_y
        max_y = 6.1;
    end
    axis([0 1.02*max(time_vector) 0.9 max_y]);
    hold off;
    
    % Plot FWHM vs. time
    subplot(5,3,9);
    hold on;
    plot(time_vector, FinalResults(1,SampleIter).mean_FWHM, 'k--', 'LineWidth', 1);
    errorbar(time_vector, FinalResults(1,SampleIter).mean_FWHM, std_FWHM, 'ko', 'MarkerSize', 6, 'MarkerFaceColor',[237/255, 28/255, 36/255]);
    title([FinalResults(1,SampleIter).SampleName, ' FWHM vs. time'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    ylabel('FWHM (degrees)', 'FontSize',9, 'FontName', 'Helvetica');
    xlabel('lag time (ms)', 'FontSize',9, 'FontName', 'Helvetica');
    axis([0 1.02*max(time_vector) 0 151]);
    hold off;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% SUB-PLOT 10 to 12: METRICS vs. Displacement length (Space) %%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Plot a given anisotropy metric over space for all frame rates
    diff_to_add = .5*(input_struct.MovingThreshold(2)-input_struct.MovingThreshold(1));
    
    
    %%% PLOT THE AMPLITUDE VS. SPACE
    subplot(5,3,10);
    hold on;
    
    %%%%%%% CALCULATE USING WEIGHTS BASED ON NUMBER OF ANGLES %%%%%%%
    
    % Description of calculation:
    % We want to calculate the f(180/0) as a function of the mean
    % displacement, averaged over all the different deltaT. 
    % From the processed calculations we have a matrix: 
    % FinalResults.f_180_0_AtClosestMean. 
    % This is an TxL matrix, where:
    % There are T columns for the T timepoints: 223 Hz, 134 Hz, ... 9.2 Hz
    % There are L rows for the L displacement bins (contained in the "input_struct.MovingThreshold" vector
    % So here we want to take the mean anisotropy for a given mean
    % displacement length bin L and average over all the timepoints T. 
    % But here there are 2 issues to consider:
    % - empty elements (e.g. if there was not enough angles to accurately
    % calculate the f(180/0) it will be left empty or if it was restricted
    % (e.g. for 223 Hz data the f(180/0) is not calculated for
    % displacements > 450 nm and therefore empty at these distances)
    % - the number of angles are different. For example, if we calculate
    % the f(180/0) for 200 nm bins and the 223 Hz dataset contributes 50k
    % angles, but the 9.2 Hz dataset contributes 5k angles, we should weigh
    % them accordingly when we take the mean (in this examples, the 223 Hz
    % dataset should count 10x of the 9.2 Hz dataset). 
    % The code snippet below therefore does this:
    % It first removes any empty (NaN) values. It then calculates a
    % weighing vector "curr_NumAngles", which sums to 1. Finally, it
    % re-scales the f(180/0) value according to this. 
    
    dist_mean = zeros(1,length(input_struct.MovingThreshold));
    dist_std = zeros(1,length(input_struct.MovingThreshold));
    for DistIter = 1:length(dist_mean)
        curr_vals = FinalResults(1,SampleIter).AmpAtClosestMean(:,DistIter);
        curr_NumAngles = FinalResults(1,SampleIter).TotalMinMinAngles'; % convert to column vector
        % get rid of NaN's to be able to calculate mean/std
        ToRemove = isnan(curr_vals);
        curr_vals(ToRemove) = [];
        % remove the same elements in the TotalMinMinAngles counter:
        curr_NumAngles(ToRemove) = [];
        % normalize the curr_NumAngles:
        dist_mean(1,DistIter) = sum(curr_vals.*curr_NumAngles) / sum(curr_NumAngles);
        % SYNTAX of STD in MATLAB 2014b
        % std( value_vector, weight_vector );
        dist_std(1,DistIter) = std(curr_vals, curr_NumAngles)/ sqrt(length(curr_vals));
    end
    
    % now do the actual plotting:
    plot(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, 'k--','LineWidth',1);
    errorbar(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, dist_std, 'ko', 'MarkerSize', 6,  'MarkerFaceColor', [237/255, 28/255, 36/255]);

    title([FinalResults(1,SampleIter).SampleName, ' Amp vs. length'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    ylabel('amplitude', 'FontSize',9, 'FontName', 'Helvetica');
    xlabel('mean displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    max_y = 0.36;
    if mean(FinalResults(1,SampleIter).mean_Amp) > max_y
        max_y = 0.71;
    end
    axis([0 1000*(diff_to_add+1.03*max(input_struct.MovingThreshold(1,end))) 0 max_y]);
    hold off;
    
    %%% PLOT THE f(180/0) VS. SPACE
    subplot(5,3,11);
    hold on;
    %%%%%%% CALCULATE USING WEIGHTS BASED ON NUMBER OF ANGLES %%%%%%%
    
    % Description of calculation:
    % We want to calculate the f(180/0) as a function of the mean
    % displacement, averaged over all the different deltaT. 
    % From the processed calculations we have a matrix: 
    % FinalResults.f_180_0_AtClosestMean. 
    % This is an TxL matrix, where:
    % There are T columns for the T timepoints: 223 Hz, 134 Hz, ... 9.2 Hz
    % There are L rows for the L displacement bins (contained in the "input_struct.MovingThreshold" vector
    % So here we want to take the mean anisotropy for a given mean
    % displacement length bin L and average over all the timepoints T. 
    % But here there are 2 issues to consider:
    % - empty elements (e.g. if there was not enough angles to accurately
    % calculate the f(180/0) it will be left empty or if it was restricted
    % (e.g. for 223 Hz data the f(180/0) is not calculated for
    % displacements > 450 nm and therefore empty at these distances)
    % - the number of angles are different. For example, if we calculate
    % the f(180/0) for 200 nm bins and the 223 Hz dataset contributes 50k
    % angles, but the 9.2 Hz dataset contributes 5k angles, we should weigh
    % them accordingly when we take the mean (in this examples, the 223 Hz
    % dataset should count 10x of the 9.2 Hz dataset). 
    % The code snippet below therefore does this:
    % It first removes any empty (NaN) values. It then calculates a
    % weighing vector "curr_NumAngles", which sums to 1. Finally, it
    % re-scales the f(180/0) value according to this. 
    
    dist_mean = zeros(1,length(input_struct.MovingThreshold));
    dist_std = zeros(1,length(input_struct.MovingThreshold));
    for DistIter = 1:length(dist_mean)
        curr_vals = FinalResults(1,SampleIter).f_180_0_AtClosestMean(:,DistIter);
        curr_NumAngles = FinalResults(1,SampleIter).TotalMinMinAngles'; % convert to column vector
        % get rid of NaN's to be able to calculate mean/std
        ToRemove = isnan(curr_vals);
        curr_vals(ToRemove) = [];
        % remove the same elements in the TotalMinMinAngles counter:
        curr_NumAngles(ToRemove) = [];
        % normalize the curr_NumAngles:
        dist_mean(1,DistIter) = sum(curr_vals.*curr_NumAngles) / sum(curr_NumAngles);
        % SYNTAX of STD in MATLAB 2014b: std( value_vector, weight_vector );
        dist_std(1,DistIter) = std(curr_vals, curr_NumAngles)/ sqrt(length(curr_vals));
    end
    
    % now do the actual plotting:
    plot(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, 'k--','LineWidth',1);
    errorbar(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, dist_std, 'ko', 'MarkerSize', 6,  'MarkerFaceColor', [237/255, 28/255, 36/255]);
    plot([0 5000], [1 1], 'k--', 'LineWidth', 1);
    title([FinalResults(1,SampleIter).SampleName, ' f(180/0) vs. length'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    ylabel('fold(180+/-30 / 0+/-30)', 'FontSize',9, 'FontName', 'Helvetica');
    xlabel('mean displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    max_y = 3.6;
    if mean(FinalResults(1,SampleIter).mean_f_180_0) > max_y
        max_y = 6.1;
    end
    axis([0 1000*(diff_to_add+1.03*max(input_struct.MovingThreshold(1,end))) 0.9 max_y]);
    hold off;
    
    
    %%% PLOT THE FWHM VS. SPACE
    subplot(5,3,12);
    hold on;
    %%%%%%% CALCULATE USING WEIGHTS BASED ON NUMBER OF ANGLES %%%%%%%
    dist_mean = zeros(1,length(input_struct.MovingThreshold));
    dist_std = zeros(1,length(input_struct.MovingThreshold));
    for DistIter = 1:length(dist_mean)
        curr_vals = FinalResults(1,SampleIter).FWHMAtClosestMean(:,DistIter);
        curr_NumAngles = FinalResults(1,SampleIter).TotalMinMinAngles'; % convert to column vector
        % get rid of NaN's to be able to calculate mean/std
        ToRemove = isnan(curr_vals);
        curr_vals(ToRemove) = [];
        % remove the same elements in the TotalMinMinAngles counter:
        curr_NumAngles(ToRemove) = [];
        % normalize the curr_NumAngles:
        dist_mean(1,DistIter) = sum(curr_vals.*curr_NumAngles) / sum(curr_NumAngles);
        % SYNTAX of STD in MATLAB 2014b: std( value_vector, weight_vector );
        dist_std(1,DistIter) = std(curr_vals, curr_NumAngles)/ sqrt(length(curr_vals));
    end
    
    % now do the actual plotting:
    plot(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, 'k--','LineWidth',1);
    errorbar(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, dist_std, 'ko', 'MarkerSize', 6,  'MarkerFaceColor', [237/255, 28/255, 36/255]);
   title([FinalResults(1,SampleIter).SampleName, ' FWHM vs. length'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    ylabel('FWHM (degrees)', 'FontSize',9, 'FontName', 'Helvetica');
    xlabel('mean displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    axis([0 1000*(diff_to_add+1.03*max(input_struct.MovingThreshold(1,end))) 0 151]);
    hold off;
    

    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% SUB-PLOT 16 to 18: PLOT THE MATRICES %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    frame_rate_vector = 1:length(FinalResults(1,SampleIter).FrameRates);
    
    
    % Plot a heatmap of the Amplitude
    subplot(5,3,13);
    imagesc(1000*(input_struct.MovingThreshold), frame_rate_vector, FinalResults(1,SampleIter).AmpAtClosestMean);
    xlim([1000*(min(input_struct.MovingThreshold)-diff_to_add) 1000*(max(input_struct.MovingThreshold)+diff_to_add)]);
    ylim([min(frame_rate_vector)-0.5 max(frame_rate_vector)+0.5]);
    set(gca,'ytick',frame_rate_vector,'yticklabel',legend_info);
    xlabel('mean displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    title([FinalResults(1,SampleIter).SampleName, ' amplitude matrix'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    caxis([0 0.4]);
    colormap(c_map);
    colorbar;
    
    % Plot a heatmap of the f(180/0)
    subplot(5,3,14);
    imagesc(1000*(input_struct.MovingThreshold), frame_rate_vector, FinalResults(1,SampleIter).f_180_0_AtClosestMean);
    xlim([1000*(min(input_struct.MovingThreshold)-diff_to_add) 1000*(max(input_struct.MovingThreshold)+diff_to_add)]);
    ylim([min(frame_rate_vector)-0.5 max(frame_rate_vector)+0.5]);
    set(gca,'ytick',frame_rate_vector,'yticklabel',legend_info);
    xlabel('mean displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    title([FinalResults(1,SampleIter).SampleName, ' f(180/0) matrix'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    caxis([0.9 3.1]);
    colormap(c_map);
    colorbar;
    
    % Plot a heatmap of the FWHM
    subplot(5,3,15);
    imagesc(1000*(input_struct.MovingThreshold), frame_rate_vector, FinalResults(1,SampleIter).FWHMAtClosestMean);
    xlim([1000*(min(input_struct.MovingThreshold)-diff_to_add) 1000*(max(input_struct.MovingThreshold)+diff_to_add)]);
    ylim([min(frame_rate_vector)-0.5 max(frame_rate_vector)+0.5]);
    set(gca,'ytick',frame_rate_vector,'yticklabel',legend_info);
    xlabel('mean displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    title([FinalResults(1,SampleIter).SampleName, ' FWHM matrix'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    caxis([0 151]);
    colormap(c_map);
    colorbar;
    
    
    
    % Done with all the plotting: now save a PDF:
    set(figure1,'Units','Inches');
    pos = get(figure1,'Position');
    set(figure1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(figure1, [plot_path, FinalResults(1,SampleIter).SampleName, '_', SaveAppend, '_Plot1.pdf'], '-dpdf','-r0');
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%% PROCEED TO THE 2ND FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    disp('plotting figure number 2');
    
    %figure2 = figure('position',[400 100 600 1000]); %[x y width height] 
    figure2 = figure('position',[600 100 900 1400]); %[x y width height] 
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% FIGURE 2 SUB-PLOT 1 to 3: METRICS vs. MINIMUM Displacement length %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Plot a given anisotropy metric over space for all frame rates
    diff_to_add = .5*(input_struct.MovingThreshold(2)-input_struct.MovingThreshold(1));
    
    
    %%% PLOT THE AMPLITUDE VS. SPACE
    subplot(5,3,1);
    hold on;
    
    %%%%%%% CALCULATE USING WEIGHTS BASED ON NUMBER OF ANGLES %%%%%%%
    dist_mean = zeros(1,length(input_struct.MovingThreshold));
    dist_std = zeros(1,length(input_struct.MovingThreshold));
    for DistIter = 1:length(dist_mean)
        curr_vals = FinalResults(1,SampleIter).AmpAtClosestMin(:,DistIter);
        curr_NumAngles = FinalResults(1,SampleIter).TotalMinMinAngles'; % convert to column vector
        % get rid of NaN's to be able to calculate mean/std
        ToRemove = isnan(curr_vals);
        curr_vals(ToRemove) = [];
        % remove the same elements in the TotalMinMinAngles counter:
        curr_NumAngles(ToRemove) = [];
        % normalize the curr_NumAngles:
        curr_NumAngles = curr_NumAngles ./ sum(curr_NumAngles);
        Weighted_vals = curr_vals .* curr_NumAngles;
        
        dist_mean(1,DistIter) = sum(Weighted_vals);
        % SYNTAX of STD in MATLAB 2014b
        % std( value_vector, weight_vector );
        dist_std(1,DistIter) = std(curr_vals, curr_NumAngles)/ sqrt(length(curr_vals));
    end
    
    % now do the actual plotting:
    plot(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, 'k--','LineWidth',1);
    errorbar(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, dist_std, 'ko', 'MarkerSize', 6,  'MarkerFaceColor', [237/255, 28/255, 36/255]);

    title([FinalResults(1,SampleIter).SampleName, ' Amp vs. length'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    ylabel('amplitude', 'FontSize',9, 'FontName', 'Helvetica');
    xlabel('MIN displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    max_y = 0.36;
    if mean(FinalResults(1,SampleIter).mean_Amp) > max_y
        max_y = 0.71;
    end
    axis([0 1000*(diff_to_add+1.03*max(input_struct.MovingThreshold(1,end))) 0 max_y]);
    hold off;
    
    %%% PLOT THE f(180/0) VS. SPACE
    subplot(5,3,2);
    hold on;
    %%%%%%% CALCULATE USING WEIGHTS BASED ON NUMBER OF ANGLES %%%%%%%
    dist_mean = zeros(1,length(input_struct.MovingThreshold));
    dist_std = zeros(1,length(input_struct.MovingThreshold));
    for DistIter = 1:length(dist_mean)
        curr_vals = FinalResults(1,SampleIter).f_180_0_AtClosestMin(:,DistIter);
        curr_NumAngles = FinalResults(1,SampleIter).TotalMinMinAngles'; % convert to column vector
        % get rid of NaN's to be able to calculate mean/std
        ToRemove = isnan(curr_vals);
        curr_vals(ToRemove) = [];
        % remove the same elements in the TotalMinMinAngles counter:
        curr_NumAngles(ToRemove) = [];
        % normalize the curr_NumAngles:
        curr_NumAngles = curr_NumAngles ./ sum(curr_NumAngles);
        Weighted_vals = curr_vals .* curr_NumAngles;
        
        dist_mean(1,DistIter) = sum(Weighted_vals);
        % SYNTAX of STD in MATLAB 2014b
        % std( value_vector, weight_vector );
        dist_std(1,DistIter) = std(curr_vals, curr_NumAngles)/ sqrt(length(curr_vals));
    end
    
    % now do the actual plotting:
    plot(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, 'k--','LineWidth',1);
    errorbar(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, dist_std, 'ko', 'MarkerSize', 6,  'MarkerFaceColor', [237/255, 28/255, 36/255]);
    plot([0 5000], [1 1], 'k--', 'LineWidth', 1);
    title([FinalResults(1,SampleIter).SampleName, ' f(180/0) vs. length'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    ylabel('fold(180+/-30 / 0+/-30)', 'FontSize',9, 'FontName', 'Helvetica');
    xlabel('MIN displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    max_y = 3.6;
    if mean(FinalResults(1,SampleIter).mean_f_180_0) > max_y
        max_y = 6.1;
    end
    axis([0 1000*(diff_to_add+1.03*max(input_struct.MovingThreshold(1,end))) 0.9 max_y]);
    hold off;
    
    
    %%% PLOT THE FWHM VS. SPACE
    subplot(5,3,3);
    hold on;
    %%%%%%% CALCULATE USING WEIGHTS BASED ON NUMBER OF ANGLES %%%%%%%
    dist_mean = zeros(1,length(input_struct.MovingThreshold));
    dist_std = zeros(1,length(input_struct.MovingThreshold));
    for DistIter = 1:length(dist_mean)
        curr_vals = FinalResults(1,SampleIter).FWHMAtClosestMin(:,DistIter);
        curr_NumAngles = FinalResults(1,SampleIter).TotalMinMinAngles'; % convert to column vector
        % get rid of NaN's to be able to calculate mean/std
        ToRemove = isnan(curr_vals);
        curr_vals(ToRemove) = [];
        % remove the same elements in the TotalMinMinAngles counter:
        curr_NumAngles(ToRemove) = [];
        % normalize the curr_NumAngles:
        curr_NumAngles = curr_NumAngles ./ sum(curr_NumAngles);
        Weighted_vals = curr_vals .* curr_NumAngles;
        
        dist_mean(1,DistIter) = sum(Weighted_vals);
        % SYNTAX of STD in MATLAB 2014b
        % std( value_vector, weight_vector );
        dist_std(1,DistIter) = std(curr_vals, curr_NumAngles)/ sqrt(length(curr_vals));
    end
    
    % now do the actual plotting:
    plot(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, 'k--','LineWidth',1);
    errorbar(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, dist_std, 'ko', 'MarkerSize', 6,  'MarkerFaceColor', [237/255, 28/255, 36/255]);
    title([FinalResults(1,SampleIter).SampleName, ' FWHM vs. length'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    ylabel('FWHM (degrees)', 'FontSize',9, 'FontName', 'Helvetica');
    xlabel('MIN displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    axis([0 1000*(diff_to_add+1.03*max(input_struct.MovingThreshold(1,end))) 0 151]);
    hold off;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% FIGURE 2 SUB-PLOT 4 to 6: PLOT THE MATRICES for MINIMAL r %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    frame_rate_vector = 1:length(FinalResults(1,SampleIter).FrameRates);
    
    
    % Plot a heatmap of the Amplitude
    subplot(5,3,4);
    imagesc(1000*(input_struct.MovingThreshold), frame_rate_vector, FinalResults(1,SampleIter).AmpAtClosestMin);
    xlim([1000*(min(input_struct.MovingThreshold)-diff_to_add) 1000*(max(input_struct.MovingThreshold)+diff_to_add)]);
    ylim([min(frame_rate_vector)-0.5 max(frame_rate_vector)+0.5]);
    set(gca,'ytick',frame_rate_vector,'yticklabel',legend_info);
    xlabel('MIN displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    title([FinalResults(1,SampleIter).SampleName, ' amplitude matrix'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    caxis([0 0.4]);
    colormap(c_map);
    colorbar;
    
    % Plot a heatmap of the f(180/0)
    subplot(5,3,5);
    imagesc(1000*(input_struct.MovingThreshold), frame_rate_vector, FinalResults(1,SampleIter).f_180_0_AtClosestMin);
    xlim([1000*(min(input_struct.MovingThreshold)-diff_to_add) 1000*(max(input_struct.MovingThreshold)+diff_to_add)]);
    ylim([min(frame_rate_vector)-0.5 max(frame_rate_vector)+0.5]);
    set(gca,'ytick',frame_rate_vector,'yticklabel',legend_info);
    xlabel('MIN displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    title([FinalResults(1,SampleIter).SampleName, ' f(180/0) matrix'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    caxis([0.9 3.1]);
    colormap(c_map);
    colorbar;
    
    % Plot a heatmap of the FWHM
    subplot(5,3,6);
    imagesc(1000*(input_struct.MovingThreshold), frame_rate_vector, FinalResults(1,SampleIter).FWHMAtClosestMin);
    xlim([1000*(min(input_struct.MovingThreshold)-diff_to_add) 1000*(max(input_struct.MovingThreshold)+diff_to_add)]);
    ylim([min(frame_rate_vector)-0.5 max(frame_rate_vector)+0.5]);
    set(gca,'ytick',frame_rate_vector,'yticklabel',legend_info);
    xlabel('MIN displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    title([FinalResults(1,SampleIter).SampleName, ' FWHM matrix'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    caxis([0 151]);
    colormap(c_map);
    colorbar;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%% FIGURE 2 SUB-PLOT 7 to 9: FULL DISPLACEMENT MATRIX %%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % also plot the matrices for each individual displacement:
    % Plot a heatmap of the Amplitude
    subplot(5,3,7);
    imagesc(1000*(input_struct.MovingThreshold), 1000*(input_struct.MovingThreshold), FinalResults(1,SampleIter).Amp_JumpMatrix);
    xlim([1000*(min(input_struct.MovingThreshold)-diff_to_add) 1000*(max(input_struct.MovingThreshold)+diff_to_add)]);
    ylim([1000*(min(input_struct.MovingThreshold)-diff_to_add) 1000*(max(input_struct.MovingThreshold)+diff_to_add)]);
    %set(gca,'ytick',frame_rate_vector,'yticklabel',legend_info);
    xlabel('2nd displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    ylabel('1st displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    title(['1st/2nd jump amplitude matrix'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    caxis([0 0.4]);
    colormap(c_map);
    %colorbar;
    
    % Plot a heatmap of the fold(180/0)
    subplot(5,3,8);
    imagesc(1000*(input_struct.MovingThreshold), 1000*(input_struct.MovingThreshold), FinalResults(1,SampleIter).f_180_0_JumpMatrix);
    xlim([1000*(min(input_struct.MovingThreshold)-diff_to_add) 1000*(max(input_struct.MovingThreshold)+diff_to_add)]);
    ylim([1000*(min(input_struct.MovingThreshold)-diff_to_add) 1000*(max(input_struct.MovingThreshold)+diff_to_add)]);
    %set(gca,'ytick',frame_rate_vector,'yticklabel',legend_info);
    xlabel('2nd displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    ylabel('1st displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    title(['1st/2nd jump f(180/0) matrix'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    caxis([0.9 3.1]);
    colormap(c_map);
    %colorbar;
    
    % Plot a heatmap of the fold(180/0)
    subplot(5,3,9);
    imagesc(1000*(input_struct.MovingThreshold), 1000*(input_struct.MovingThreshold), FinalResults(1,SampleIter).FWHM_JumpMatrix);
    xlim([1000*(min(input_struct.MovingThreshold)-diff_to_add) 1000*(max(input_struct.MovingThreshold)+diff_to_add)]);
    ylim([1000*(min(input_struct.MovingThreshold)-diff_to_add) 1000*(max(input_struct.MovingThreshold)+diff_to_add)]);
    %set(gca,'ytick',frame_rate_vector,'yticklabel',legend_info);
    xlabel('2nd displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    ylabel('1st displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
    title(['1st/2nd jump FWHM matrix'], 'FontSize', 8, 'FontName', 'Helvetica', 'Interpreter', 'none');
    caxis([0 151]);
    colormap(c_map);
    %colorbar;
    
    
    % Done with all the plotting: now save a PDF:
    set(figure2,'Units','Inches');
    pos = get(figure2,'Position');
    set(figure2,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(figure2, [plot_path, FinalResults(1,SampleIter).SampleName, '_', SaveAppend, '_Plot2.pdf'], '-dpdf','-r0');
    toc;
    
end








