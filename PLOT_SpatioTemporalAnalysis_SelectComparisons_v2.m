%   PLOT_SpatioTemporalAnalysis_SelectComparisons_v2.m
%   Anders Sejr Hansen, October 2017
clear; clc; colour = jet; close all;

%   DESCRIPTION
%   This script will load a structured array with all the data from
%   SpatioTemporal angle analysis fpr several cell lines/samples and then
%   do a number of hopefully informative plots
%   But this script only plots select samples for making comparisons

%   UPDATE 2018-09-08 - version 2
%   A previous version did not correctly normalize for the amount of data
%   when calculating the anisotropy as a function of the mean displacement
%   length. This has now been fixed. 


DataSet = 13;
colours = [0/255, 153/255, 204/255; 237/255, 28/255, 36/255; 0/255, 161/255, 75/255;  102/255, 45/255, 145/255; 0,0,0; 157/255, 157/255, 54/255; ];
c_map = [1,1,1;1,1,0.992156862745098;1,1,0.984313725490196;1,1,0.976470588235294;1,1,0.968627450980392;1,1,0.960784313725490;1,1,0.952941176470588;1,1,0.945098039215686;1,1,0.937254901960784;1,1,0.929411764705882;1,1,0.921568627450980;1,1,0.913725490196078;1,1,0.905882352941177;1,1,0.898039215686275;1,1,0.890196078431373;1,1,0.882352941176471;1,1,0.874509803921569;1,1,0.866666666666667;1,1,0.858823529411765;1,1,0.850980392156863;1,1,0.843137254901961;1,1,0.835294117647059;1,1,0.827450980392157;1,1,0.819607843137255;1,1,0.811764705882353;1,1,0.803921568627451;1,1,0.796078431372549;1,1,0.788235294117647;1,1,0.780392156862745;1,1,0.772549019607843;1,1,0.764705882352941;1,1,0.756862745098039;1,1,0.749019607843137;1,1,0.741176470588235;1,1,0.733333333333333;1,1,0.725490196078431;1,1,0.717647058823529;1,1,0.709803921568628;1,1,0.701960784313725;1,1,0.694117647058824;1,1,0.686274509803922;1,1,0.678431372549020;1,1,0.674509803921569;1,1,0.666666666666667;1,1,0.658823529411765;1,1,0.650980392156863;1,1,0.643137254901961;1,1,0.635294117647059;1,1,0.627450980392157;1,1,0.619607843137255;1,1,0.611764705882353;1,1,0.603921568627451;1,1,0.596078431372549;1,1,0.588235294117647;1,1,0.580392156862745;1,1,0.572549019607843;1,1,0.564705882352941;1,1,0.556862745098039;1,1,0.549019607843137;1,1,0.541176470588235;1,1,0.533333333333333;1,1,0.525490196078431;1,1,0.517647058823530;1,1,0.509803921568627;1,1,0.501960784313726;1,0.992156862745098,0.494117647058824;1,0.984313725490196,0.486274509803922;1,0.976470588235294,0.478431372549020;1,0.968627450980392,0.470588235294118;1,0.960784313725490,0.462745098039216;1,0.949019607843137,0.454901960784314;1,0.945098039215686,0.447058823529412;1,0.933333333333333,0.439215686274510;1,0.929411764705882,0.431372549019608;1,0.921568627450980,0.423529411764706;1,0.913725490196078,0.415686274509804;1,0.905882352941177,0.407843137254902;1,0.898039215686275,0.400000000000000;1,0.890196078431373,0.392156862745098;1,0.882352941176471,0.384313725490196;1,0.874509803921569,0.376470588235294;1,0.866666666666667,0.368627450980392;1,0.858823529411765,0.360784313725490;1,0.850980392156863,0.352941176470588;1,0.843137254901961,0.345098039215686;1,0.835294117647059,0.337254901960784;1,0.827450980392157,0.329411764705882;1,0.819607843137255,0.317647058823529;1,0.811764705882353,0.309803921568627;1,0.803921568627451,0.301960784313725;1,0.796078431372549,0.294117647058824;1,0.788235294117647,0.286274509803922;1,0.780392156862745,0.278431372549020;1,0.772549019607843,0.270588235294118;1,0.764705882352941,0.262745098039216;1,0.756862745098039,0.254901960784314;1,0.749019607843137,0.247058823529412;1,0.741176470588235,0.239215686274510;1,0.733333333333333,0.231372549019608;1,0.725490196078431,0.223529411764706;1,0.717647058823529,0.215686274509804;1,0.709803921568628,0.207843137254902;1,0.701960784313725,0.200000000000000;1,0.694117647058824,0.192156862745098;1,0.686274509803922,0.184313725490196;1,0.678431372549020,0.176470588235294;1,0.670588235294118,0.168627450980392;1,0.662745098039216,0.160784313725490;1,0.654901960784314,0.152941176470588;1,0.647058823529412,0.145098039215686;1,0.639215686274510,0.137254901960784;1,0.631372549019608,0.129411764705882;1,0.623529411764706,0.121568627450980;1,0.615686274509804,0.113725490196078;1,0.607843137254902,0.105882352941176;1,0.600000000000000,0.0980392156862745;1,0.592156862745098,0.0901960784313726;1,0.584313725490196,0.0823529411764706;1,0.576470588235294,0.0745098039215686;1,0.568627450980392,0.0666666666666667;1,0.560784313725490,0.0588235294117647;1,0.552941176470588,0.0509803921568627;1,0.541176470588235,0.0431372549019608;1,0.533333333333333,0.0352941176470588;1,0.525490196078431,0.0274509803921569;1,0.517647058823530,0.0196078431372549;1,0.513725490196078,0.0117647058823529;1,0.505882352941176,0.00392156862745098;0.996078431372549,0.494117647058824,0;0.988235294117647,0.490196078431373,0;0.980392156862745,0.478431372549020,0;0.972549019607843,0.474509803921569,0;0.964705882352941,0.462745098039216,0;0.956862745098039,0.454901960784314,0;0.949019607843137,0.450980392156863,0;0.941176470588235,0.443137254901961,0;0.933333333333333,0.435294117647059,0;0.925490196078431,0.427450980392157,0;0.917647058823529,0.419607843137255,0;0.909803921568627,0.411764705882353,0;0.901960784313726,0.400000000000000,0;0.894117647058824,0.392156862745098,0;0.890196078431373,0.384313725490196,0;0.882352941176471,0.380392156862745,0;0.874509803921569,0.368627450980392,0;0.866666666666667,0.364705882352941,0;0.858823529411765,0.356862745098039,0;0.850980392156863,0.349019607843137,0;0.843137254901961,0.341176470588235,0;0.835294117647059,0.329411764705882,0;0.827450980392157,0.325490196078431,0;0.819607843137255,0.317647058823529,0;0.811764705882353,0.309803921568627,0;0.803921568627451,0.301960784313725,0;0.796078431372549,0.294117647058824,0;0.788235294117647,0.286274509803922,0;0.780392156862745,0.274509803921569,0;0.772549019607843,0.266666666666667,0;0.764705882352941,0.258823529411765,0;0.756862745098039,0.250980392156863,0;0.749019607843137,0.247058823529412,0;0.741176470588235,0.239215686274510,0;0.733333333333333,0.231372549019608,0;0.725490196078431,0.223529411764706,0;0.717647058823529,0.211764705882353,0;0.709803921568628,0.203921568627451,0;0.701960784313725,0.200000000000000,0;0.694117647058824,0.192156862745098,0;0.686274509803922,0.184313725490196,0;0.682352941176471,0.172549019607843,0;0.674509803921569,0.164705882352941,0;0.666666666666667,0.156862745098039,0;0.658823529411765,0.152941176470588,0;0.650980392156863,0.145098039215686,0;0.643137254901961,0.133333333333333,0;0.635294117647059,0.129411764705882,0;0.627450980392157,0.121568627450980,0;0.619607843137255,0.113725490196078,0;0.611764705882353,0.105882352941176,0;0.603921568627451,0.0980392156862745,0;0.596078431372549,0.0862745098039216,0;0.588235294117647,0.0784313725490196,0;0.580392156862745,0.0705882352941177,0;0.572549019607843,0.0666666666666667,0;0.564705882352941,0.0549019607843137,0;0.556862745098039,0.0509803921568627,0;0.549019607843137,0.0431372549019608,0;0.541176470588235,0.0352941176470588,0;0.533333333333333,0.0235294117647059,0;0.525490196078431,0.0156862745098039,0;0.517647058823530,0.00784313725490196,0;0.509803921568627,0,0;0.501960784313726,0,0;0.494117647058824,0,0;0.486274509803922,0,0;0.478431372549020,0,0;0.470588235294118,0,0;0.462745098039216,0,0;0.454901960784314,0,0;0.447058823529412,0,0;0.439215686274510,0,0;0.431372549019608,0,0;0.423529411764706,0,0;0.415686274509804,0,0;0.407843137254902,0,0;0.400000000000000,0,0;0.392156862745098,0,0;0.384313725490196,0,0;0.376470588235294,0,0;0.368627450980392,0,0;0.360784313725490,0,0;0.352941176470588,0,0;0.345098039215686,0,0;0.337254901960784,0,0;0.325490196078431,0,0;0.317647058823529,0,0;0.309803921568627,0,0;0.301960784313725,0,0;0.294117647058824,0,0;0.286274509803922,0,0;0.278431372549020,0,0;0.270588235294118,0,0;0.262745098039216,0,0;0.254901960784314,0,0;0.247058823529412,0,0;0.239215686274510,0,0;0.231372549019608,0,0;0.223529411764706,0,0;0.215686274509804,0,0;0.207843137254902,0,0;0.200000000000000,0,0;0.192156862745098,0,0;0.184313725490196,0,0;0.176470588235294,0,0;0.168627450980392,0,0;0.160784313725490,0,0;0.152941176470588,0,0;0.145098039215686,0,0;0.137254901960784,0,0;0.129411764705882,0,0;0.121568627450980,0,0;0.113725490196078,0,0;0.101960784313725,0,0;0.0941176470588235,0,0;0.0862745098039216,0,0;0.0784313725490196,0,0;0.0705882352941177,0,0;0.0627450980392157,0,0;0.0549019607843137,0,0;0.0470588235294118,0,0;0.0392156862745098,0,0;0.0313725490196078,0,0;0.0235294117647059,0,0;0.0156862745098039,0,0;0.00784313725490196,0,0;0,0,0];
plot_path = './2018_April_Plots/';
savePDF = true;

max_x_jump_for_plot = 810;

% Load the appropriate dataset
if DataSet == 1
    load('20180531_AllFinalResults_HMMfirst'); % give name of dataset with multiple different conditions
    % 
    SelectSamples = [1,2]; % pick them based on their numbers
    SaveName = 'mESC_CTCF_and_mutants_comparison'; % give them an appropriate name. 

    
end

figure1 = figure('position',[100 100 1200 1000]); %[x y width height]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% SUB-PLOT 1 to 3: ANGLE HISTOGRAMS FOR 223, 133 and 74 Hz %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
normPDF = FinalResults(1,1).normPDF{1};
legend_info = {''};
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

% Loop over all the samples: 223 Hz
TimeIter = 1;
subplot(3,3,1); 
hold on;
for SelectSampleIter = 1:length(SelectSamples)
    SampleIter = SelectSamples(SelectSampleIter);
    legend_info{SelectSampleIter} = FinalResults(1,SampleIter).SampleName;
    plot(x_theta(x_index_vector), FinalResults(1,SampleIter).normPDF{1,TimeIter}(y_index_vector), '-', 'LineWidth', 2, 'Color', colours(SelectSampleIter,:));
end
title(['angle distribution at ', FinalResults(1,SampleIter).FrameRates(1,TimeIter).FrameRate], 'FontSize', 9, 'FontName', 'Helvetica', 'Interpreter', 'none');
xlabel('\theta / 2\pi', 'FontSize',9, 'FontName', 'Helvetica');
ylabel('probability', 'FontSize',9, 'FontName', 'Helvetica');
legend(legend_info, 'Location', 'NorthEast',  'Interpreter', 'none');
legend boxoff
axis([0 1 0.015 0.095]);
hold off; 

% Loop over all the samples: 133 Hz
TimeIter = 2;
subplot(3,3,2); 
hold on;
for SelectSampleIter = 1:length(SelectSamples)
    SampleIter = SelectSamples(SelectSampleIter);
    legend_info{SelectSampleIter} = FinalResults(1,SampleIter).SampleName;
    plot(x_theta(x_index_vector), FinalResults(1,SampleIter).normPDF{1,TimeIter}(y_index_vector), '-', 'LineWidth', 2, 'Color', colours(SelectSampleIter,:));
end
title(['angle distribution at ', FinalResults(1,SampleIter).FrameRates(1,TimeIter).FrameRate], 'FontSize', 9, 'FontName', 'Helvetica', 'Interpreter', 'none');
xlabel('\theta / 2\pi', 'FontSize',9, 'FontName', 'Helvetica');
ylabel('probability', 'FontSize',9, 'FontName', 'Helvetica');
legend(legend_info, 'Location', 'NorthEast',  'Interpreter', 'none');
legend boxoff
axis([0 1 0.015 0.095]);
hold off; 

% Loop over all the samples: 74 Hz
TimeIter = 3;
subplot(3,3,3); 
hold on;
for SelectSampleIter = 1:length(SelectSamples)
    SampleIter = SelectSamples(SelectSampleIter);
    legend_info{SelectSampleIter} = FinalResults(1,SampleIter).SampleName;
    plot(x_theta(x_index_vector), FinalResults(1,SampleIter).normPDF{1,TimeIter}(y_index_vector), '-', 'LineWidth', 2, 'Color', colours(SelectSampleIter,:));
end
title(['angle distribution at ', FinalResults(1,SampleIter).FrameRates(1,TimeIter).FrameRate], 'FontSize', 9, 'FontName', 'Helvetica', 'Interpreter', 'none');
xlabel('\theta / 2\pi', 'FontSize',9, 'FontName', 'Helvetica');
ylabel('probability', 'FontSize',9, 'FontName', 'Helvetica');
legend(legend_info, 'Location', 'NorthEast',  'Interpreter', 'none');
legend boxoff
axis([0 1 0.015 0.095]);
hold off; 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% SUB-PLOT 4 to 6: METRICS vs. TimeLag %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% PLOT Amp vs. Time for all samples:
subplot(3,3,4); 
hold on;
for SelectSampleIter = 1:length(SelectSamples)
    SampleIter = SelectSamples(SelectSampleIter);
    std_Amp = zeros(1,length(FinalResults(1,SampleIter).mean_Amp));
    time_vector = zeros(1,length(FinalResults(1,SampleIter).FrameRates));
    for TimeIter = 1:length(std_Amp)
        std_Amp(1,TimeIter) = std(FinalResults(1,SampleIter).jack_Amp{TimeIter});
        time_vector(1,TimeIter) = 1000*FinalResults(1,SampleIter).FrameRates(1,TimeIter).LagTime;
    end
    h = plot(time_vector, FinalResults(1,SampleIter).mean_Amp, '-', 'LineWidth', 1, 'Color', colours(SelectSampleIter,:));
    errorbar(time_vector, FinalResults(1,SampleIter).mean_Amp, std_Amp, 'o', 'MarkerSize', 6,  'MarkerFaceColor', colours(SelectSampleIter,:), 'Color',colours(SelectSampleIter,:));
    set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
end
title(' amplitude vs. time', 'FontSize', 9, 'FontName', 'Helvetica', 'Interpreter', 'none');
ylabel('amplitude', 'FontSize',9, 'FontName', 'Helvetica');
xlabel('lag time (ms)', 'FontSize',9, 'FontName', 'Helvetica');
legend(legend_info, 'Location', 'NorthEast',  'Interpreter', 'none');
legend boxoff
axis([0 1.02*max(time_vector) 0 0.26]);
hold off;

%%% PLOT f(180/0) vs. Time for all samples:
subplot(3,3,5); 
hold on;
for SelectSampleIter = 1:length(SelectSamples)
    SampleIter = SelectSamples(SelectSampleIter);
    std_f_180_0 = zeros(1,length(FinalResults(1,SampleIter).mean_f_180_0));
    time_vector = zeros(1,length(FinalResults(1,SampleIter).FrameRates));
    for TimeIter = 1:length(std_Amp)
        std_f_180_0(1,TimeIter) = std(FinalResults(1,SampleIter).jack_f_180_0{TimeIter});
        time_vector(1,TimeIter) = 1000*FinalResults(1,SampleIter).FrameRates(1,TimeIter).LagTime;
    end
    h = plot(time_vector, FinalResults(1,SampleIter).mean_f_180_0, '-', 'LineWidth', 1, 'Color', colours(SelectSampleIter,:));
    errorbar(time_vector, FinalResults(1,SampleIter).mean_f_180_0, std_f_180_0, 'o', 'MarkerSize', 6,  'MarkerFaceColor', colours(SelectSampleIter,:), 'Color',colours(SelectSampleIter,:));
    set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
end
plot([0 1.02*max(time_vector)], [1 1], 'k--', 'LineWidth', 1);
title(' f(180 / 0) vs. time', 'FontSize', 9, 'FontName', 'Helvetica', 'Interpreter', 'none');
ylabel('fold(180+/-30 / 0+/-30)', 'FontSize',9, 'FontName', 'Helvetica');
xlabel('lag time (ms)', 'FontSize',9, 'FontName', 'Helvetica');
legend(legend_info, 'Location', 'NorthEast',  'Interpreter', 'none');
legend boxoff
axis([0 1.02*max(time_vector) 0.90 2.8]);
hold off;

%%% PLOT FWHM vs. Time for all samples:
subplot(3,3,6); 
hold on;
for SelectSampleIter = 1:length(SelectSamples)
    SampleIter = SelectSamples(SelectSampleIter);
    std_FWHM = zeros(1,length(FinalResults(1,SampleIter).mean_FWHM));
    time_vector = zeros(1,length(FinalResults(1,SampleIter).FrameRates));
    for TimeIter = 1:length(std_Amp)
        std_FWHM(1,TimeIter) = std(FinalResults(1,SampleIter).jack_FWHM{TimeIter});
        time_vector(1,TimeIter) = 1000*FinalResults(1,SampleIter).FrameRates(1,TimeIter).LagTime;
    end
    h = plot(time_vector, FinalResults(1,SampleIter).mean_FWHM, '-', 'LineWidth', 1, 'Color', colours(SelectSampleIter,:));
    errorbar(time_vector, FinalResults(1,SampleIter).mean_FWHM, std_FWHM, 'o', 'MarkerSize', 6,  'MarkerFaceColor', colours(SelectSampleIter,:), 'Color',colours(SelectSampleIter,:));
    set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
end
plot([0 1.02*max(time_vector)], [1 1], 'k--', 'LineWidth', 1);
title(' FWHM vs. time', 'FontSize', 9, 'FontName', 'Helvetica', 'Interpreter', 'none');
ylabel('FWHM (degrees)', 'FontSize',9, 'FontName', 'Helvetica');
xlabel('lag time (ms)', 'FontSize',9, 'FontName', 'Helvetica');
legend(legend_info, 'Location', 'SouthEast',  'Interpreter', 'none');
legend boxoff
axis([0 1.02*max(time_vector) 0 181]);
hold off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% SUB-PLOT 7 to 9: METRICS vs. Displacement length (Space) %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% average over all frame-rates for a given displacement bin
diff_to_add = .5*(input_struct.MovingThreshold(2)-input_struct.MovingThreshold(1));
%%% PLOT Amp vs. space for all samples:
subplot(3,3,7); 
hold on;
for SelectSampleIter = 1:length(SelectSamples)
    SampleIter = SelectSamples(SelectSampleIter);
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
        % SYNTAX of STD in MATLAB 2014b: std( value_vector, weight_vector );
        dist_std(1,DistIter) = std(curr_vals, curr_NumAngles)/ sqrt(length(curr_vals));
    end
    
    % now do the actual plotting:
    h = plot(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, '-','LineWidth',1, 'Color', colours(SelectSampleIter,:));
    set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    errorbar(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, dist_std, 'o', 'MarkerSize', 6,  'MarkerFaceColor', colours(SelectSampleIter,:), 'Color',colours(SelectSampleIter,:));
    
end
title(' amplitude vs. displacement length', 'FontSize', 9, 'FontName', 'Helvetica', 'Interpreter', 'none');
ylabel('aplitude', 'FontSize',9, 'FontName', 'Helvetica');
xlabel('mean displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
legend(legend_info, 'Location', 'NorthEast',  'Interpreter', 'none');
legend boxoff
axis([0 max_x_jump_for_plot 0 0.36]);
hold off;

%%% PLOT f(180/0) vs. space for all samples:
subplot(3,3,8); 
hold on;
for SelectSampleIter = 1:length(SelectSamples)
    SampleIter = SelectSamples(SelectSampleIter);
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
    h = plot(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, '-','LineWidth',1, 'Color', colours(SelectSampleIter,:));
    set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    errorbar(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, dist_std, 'o', 'MarkerSize', 6,  'MarkerFaceColor', colours(SelectSampleIter,:), 'Color',colours(SelectSampleIter,:));
    
end
plot([0 50000], [1 1], 'k--', 'LineWidth', 1);
title(' fold(180/0) vs. displacement length', 'FontSize', 9, 'FontName', 'Helvetica', 'Interpreter', 'none');
ylabel('fold(180+/-30 / 0+/-30)', 'FontSize',9, 'FontName', 'Helvetica');
xlabel('mean displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
legend(legend_info, 'Location', 'NorthEast',  'Interpreter', 'none');
legend boxoff
axis([0 max_x_jump_for_plot 0.90 2.8]);
hold off;

%%% PLOT FWHM vs. space for all samples:
subplot(3,3,9); 
hold on;
for SelectSampleIter = 1:length(SelectSamples)
    SampleIter = SelectSamples(SelectSampleIter);
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
    h = plot(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, '-','LineWidth',1, 'Color', colours(SelectSampleIter,:));
    set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    g = errorbar(1000*(input_struct.MovingThreshold+diff_to_add),dist_mean, dist_std, 'o', 'MarkerSize', 6, 'MarkerFaceColor', colours(SelectSampleIter,:), 'Color',colours(SelectSampleIter,:));
    
end
title(' amplitude vs. displacement length', 'FontSize', 9, 'FontName', 'Helvetica', 'Interpreter', 'none');
ylabel('aplitude', 'FontSize',9, 'FontName', 'Helvetica');
xlabel('mean displacement (nm)', 'FontSize',9, 'FontName', 'Helvetica');
legend(legend_info, 'Location', 'SouthEast',  'Interpreter', 'none');
legend boxoff
axis([0 max_x_jump_for_plot 0 181]);
hold off;

if savePDF == true
    % Done with all the plotting: now save a PDF:
    set(figure1,'Units','Inches');
    pos = get(figure1,'Position');
    set(figure1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(figure1, [plot_path, SaveName, '.pdf'], '-dpdf','-r0');
end

figure2 = figure('position',[400 400 350 300]); %[x y width height]
% average Angle PDF for 223 Hz, 133 Hz, 74 Hz and overlay them. 
legend_info_with_extra = {''};
% Loop over all the samples: 223 Hz
TimeIterVector = 1:3;
hold on;
for SelectSampleIter = 1:length(SelectSamples)
    SampleIter = SelectSamples(SelectSampleIter);
    place_holder = zeros(length(TimeIterVector), length(FinalResults(1,SampleIter).normPDF{1,1}(y_index_vector)));
    for iter = 1:length(TimeIterVector)
        TimeIter = TimeIterVector(iter);
        place_holder(iter,:) = FinalResults(1,SampleIter).normPDF{1,TimeIter}(y_index_vector);
    end
    plot(x_theta(x_index_vector), mean(place_holder,1), '-', 'LineWidth', 2, 'Color', colours(SelectSampleIter,:));
    
    % save legend with extra info:
    legend_info_with_extra{SelectSampleIter} = [FinalResults(1,SampleIter).SampleName, '; f(180/0) = ' num2str(mean(FinalResults(1,SampleIter).mean_f_180_0(1:3))), ' +/- ', num2str(std(FinalResults(1,SampleIter).mean_f_180_0(1:3))), '; FWHM = ', num2str(mean(FinalResults(1,SampleIter).mean_FWHM(1:3))), ' +/- ', num2str(std(FinalResults(1,SampleIter).mean_FWHM(1:3)))];
    
end
title('mean angle distribution', 'FontSize', 9, 'FontName', 'Helvetica', 'Interpreter', 'none');
xlabel('\theta / 2\pi', 'FontSize',9, 'FontName', 'Helvetica');
ylabel('probability', 'FontSize',9, 'FontName', 'Helvetica');
legend(legend_info_with_extra, 'Location', 'NorthEast',  'Interpreter', 'none', 'FontSize',6, 'FontName', 'Helvetica');
legend boxoff
axis([0 1 0.0195 0.056]);
if savePDF == true
    % Done with all the plotting: now save a PDF:
    set(figure2,'Units','Inches');
    pos = get(figure2,'Position');
    set(figure2,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(figure2, [plot_path, SaveName, 'MeanAnglePDF.pdf'], '-dpdf','-r0');
    hold off; 
end

