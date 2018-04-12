%   ProcessPlotFit_MSD.m
%   written by Anders Sejr Hansen (AndersSejrHansen@post.harvard.edu;
%   @Anders_S_Hansen; https://anderssejrhansen.wordpress.com)
%   License: GNU GPL v3
clear; clc; close all;

%   DESCRIPTION
%   Take as input HMM-classified SPT data at 223 Hz, 133 Hz or 74 Hz and
%   the calculate the MSD for each. Finally, fit and plot the MSD for each
%   frame rate individually and also together. Also save the MSD-data for
%   later plotting to save time on the processing
%   It averages over all times and all trajectories, so it's the time- and
%   ensemble-averaged MSD. The trajectories are too short to do MSD-fits to
%   individual trajectories, see also Michalet & Berglund Phys. Rev. E.
%   2012

% When fitting the MSD-curve, Saxton off-the-cuff recommends using only 1/4
% of the time-point:
% Saxton. Modeling 2D and 3D diffusion. Methods Mol Biol (2007) vol. 400 pp. 295-321
% Jean-Yves Tinevez in @MSDAnalyzer uses the first 25% of the points. 
% Saxton is really not very clear, specifically he says: 
%    "Calculation of the MSD is discussed in detail in the appendix of ref. 81. Given
%     that the standard deviation of ?r2? is proportional to ?r2?, in single-particle tracking it is necessary
%     to cut off the data at, say, one-quarter of the total number of time steps."
% 
% In an earlier paper (Saxton: Single-particle tracking: the distribution of diffusion coefficients; Biophys J. 1997 Apr; 72(4): 1744?1753. )
% Saxton wrote this:
%  "There are simply not enough data points at
%   large time lags to give a reliable value of the MSD, and the
%   trajectory should be cut off at approximately one-quarter of
%   the total number of data points. In least-squares fits to the
%   MSD, the appropriate statistical weighting factors should be
%   used (Qian et al., 1991), in their analytical form without
%   approximation. The use of the weighting factors automatically
%   enforces the cutoff for large time lags."
%
%
%   CONCLUSION:
%   So the point is that when you fit the MSD to a SINGLE trajectory, you
%   should only use approximately 1/4 of that trajectory length to allow
%   sufficient averaging.
%   However, when we do ensemble averaging, we have much more data and if
%   we were to use 1/4 of the Longest trajectory, it would be a lot of
%   points.
%   So as a compromise, use 1/2, rounded up, of all the points for fitting
%   the MSD. 

% add path for dependent functions:
addpath('Functions');

% Define the 3 conditions:
Conditions = struct();
Conditions(1,1).names = {'223Hz', '133Hz', '74Hz'};
Conditions(1,1).LagTime = [0.00447, 0.00747, 0.01347];
Conditions(1,1).MSD_timepoints = [20, 18, 16];
Conditions(1,1).MSD_time = cell(1,3);
for iter = 1:length(Conditions(1,1).names)
    Conditions(1,1).MSD_time{iter} = Conditions(1,1).LagTime(iter) .* (1:Conditions(1,1).MSD_timepoints(iter));
end

% Define global parameters:
JackKnife_fraction = 0.5; % fraction of dataset to use for sub-sampling
JackKnife_iterations = 25; % sub-sampling iterations
data_path = ['.', filesep, 'HMM_first_QC_data', filesep];
plot_path = ['.', filesep, 'QC_plots', filesep];
sample_suffix = '_pooled_QC_CD2_classified.mat';
DataSet = 1;
MSD_fit_fraction = 0.5; % fraction of MSD data points to use in the fitting
% Classify the states HMM-states:
BoundState = 1;
FreeState = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%% Define Data sets %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if DataSet == 1;
    sample_prefixes = {'U2OS_C32_Halo-hCTCF_'}; % add more files to analyze more samples
end

% Define the Data Struct
DataStruct = struct([]);
for SampleIter = 1:length(sample_prefixes)
    disp('======================================================'); tic;
    disp(['Processing sample ', num2str(SampleIter), ' of ', num2str(length(sample_prefixes)), ' samples']);
    disp(['Analyzing data for ', sample_prefixes{SampleIter}]);
    % define some arrays for storing data
    DataStruct(1,SampleIter).prefix = sample_prefixes{SampleIter};
    DataStruct(1,SampleIter).mean_MSD = cell(1,length(Conditions(1,1).names));
    DataStruct(1,SampleIter).Jack_MSD = cell(1,length(Conditions(1,1).names));
    DataStruct(1,SampleIter).Jack_std = cell(1,length(Conditions(1,1).names));
    DataStruct(1,SampleIter).MSD_fit_params = cell(1,length(Conditions(1,1).names));
    for ConditionIter = 1:length(Conditions(1,1).names)
        clear CellTracks CellTrackViterbiClass
        disp(['   Analyzing at ', Conditions(1,1).names{ConditionIter}]);
        % load the data
        load([data_path, sample_prefixes{SampleIter}, Conditions(1,1).names{ConditionIter}, sample_suffix]);
        
        %%% CALCULATE THE mean MSD USING THE FUNCTION MSD_HMM_ANALYZER %%%
        DataStruct(1,SampleIter).mean_MSD{ConditionIter} = MSD_HMM_analyzer(CellTracks, CellTrackViterbiClass, Conditions(1,1).MSD_time{ConditionIter}, FreeState);
        
        % Perform Jack-Knife re-sampling to get error bars:
        MSD_JackKnife = zeros(JackKnife_iterations, Conditions(1,1).MSD_timepoints(ConditionIter));
        Num_samples = round(length(CellTracks) * JackKnife_fraction);
        % sub-sample the dataset
        for JackIter = 1:JackKnife_iterations
            [subsampled_CellTracks, indices] = datasample(CellTracks, Num_samples, 'Replace', false);
            subsampled_CellTrackViterbiClass = CellTrackViterbiClass(indices);
            % now calculate the subsample MSD:
            MSD_JackKnife(JackIter,:) = MSD_HMM_analyzer(subsampled_CellTracks, subsampled_CellTrackViterbiClass, Conditions(1,1).MSD_time{ConditionIter}, FreeState);
        end
        
        % save the jack-knife sampled data:
        DataStruct(1,SampleIter).Jack_MSD{ConditionIter} = MSD_JackKnife;
        % Save the Jack-knife STD:
        DataStruct(1,SampleIter).Jack_std{ConditionIter} = std(MSD_JackKnife,1);
        
    end
    
    % merge the data in a sensible way taking the distinct time-points
    merged_MSD_time = [];
    merged_MSD_mean = [];
    merged_MSD_std = [];
    for ConditionIter = 1:length(Conditions(1,1).names)
        merged_MSD_time = horzcat(merged_MSD_time, Conditions(1,1).MSD_time{ConditionIter});
        merged_MSD_mean = horzcat(merged_MSD_mean, DataStruct(1,SampleIter).mean_MSD{ConditionIter});
        merged_MSD_std = horzcat(merged_MSD_std, DataStruct(1,SampleIter).Jack_std{ConditionIter});
    end
    % now sort according to increasing time
    [~, ordered_idx] = sort(merged_MSD_time);
    % no need to keep the un-sorted vectors:
    merged_MSD_time = merged_MSD_time(ordered_idx);
    merged_MSD_mean = merged_MSD_mean(ordered_idx);
    merged_MSD_std = merged_MSD_std(ordered_idx);
    % save this
    DataStruct(1,SampleIter).merged_MSD_time = merged_MSD_time;
    DataStruct(1,SampleIter).merged_MSD_mean = merged_MSD_mean;
    DataStruct(1,SampleIter).merged_MSD_std = merged_MSD_std;
    
    
    figure1 = figure('position',[100 100 1000 1100]); %[x y width height] 
    % Fit a Power Law to the MSD:
    f = fittype('4*D*x^a + 4*b^2');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% SUB-PLOT 1 to 6: MSD FIT FOR 223, 133 and 74 Hz LINEAR + LOG %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    xMin = 0;  yMin = 0; 
    for ConditionIter = 1:length(Conditions(1,1).names)
        
        % find how much of the MSD to use for fitting:
        Max_idx = ceil(MSD_fit_fraction * length(Conditions(1,1).MSD_time{ConditionIter}));
        % take the required 
        MSD_time_for_fit = Conditions(1,1).MSD_time{ConditionIter}(1:Max_idx);
        MSD_for_fit = DataStruct(1,SampleIter).mean_MSD{ConditionIter}(1:Max_idx);
        
        
        % fit the current data: 
        [MSD_fit, MSD_param] = fit(MSD_time_for_fit', MSD_for_fit', f, 'Lower', [0 0 0.02], 'Upper', [20 2 0.04], 'StartPoint', [3 0.8 0.035]); 
        % get the Confidence Interval:
        MSD_fit_CI = confint(MSD_fit);
        
        % generate fit for plotting the MSD fit:
        xTime = 0:0.005:1.2*max(Conditions(1,1).MSD_time{ConditionIter});
        yMSD = 4 .* MSD_fit.D .* xTime.^MSD_fit.a + 4*MSD_fit.b^2;
        
        % generate text for display in the plot
        Fit1_text(1) = {'Power Law fit: MSD = 4*D*t^a + 4*LocError^2'};
        Fit1_text(2) = {['D = ', num2str(MSD_fit.D), ' um^2/s']};
        Fit1_text(3) = {['D (95% CI): [', num2str(MSD_fit_CI(1,1)), ';', num2str(MSD_fit_CI(2,1)), ']']};
        Fit1_text(4) = {['alpha = ', num2str(MSD_fit.a)]};
        Fit1_text(5) = {['alpha (95% CI): [', num2str(MSD_fit_CI(1,2)), ';', num2str(MSD_fit_CI(2,2)), ']']};
        Fit1_text(6) = {['LocError = ', num2str(MSD_fit.b), ' um']};
        Fit1_text(7) = {['LocError (95% CI): [', num2str(MSD_fit_CI(1,3)), ';', num2str(MSD_fit_CI(2,3)), ']']};
  
        
        % save the fits as objects
        DataStruct(1,SampleIter).MSD_fit(1,ConditionIter).MSD_fit = MSD_fit;
        DataStruct(1,SampleIter).MSD_fit(1,ConditionIter).MSD_param = MSD_param;
        
        % display the fit as a plot:
        subplot(3,3,ConditionIter);
        % LINEAR SCALE
        xMax = 1.05*max(Conditions(1,1).MSD_time{ConditionIter}); yMax = 1.1*max(DataStruct(1,SampleIter).mean_MSD{ConditionIter});
        hold on;
        errorbar(Conditions(1,1).MSD_time{ConditionIter}, DataStruct(1,SampleIter).mean_MSD{ConditionIter}, DataStruct(1,SampleIter).Jack_std{ConditionIter}, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
        plot(xTime, yMSD, 'k-', 'LineWidth', 2);
        text(0.02*xMax, 0.85*yMax, Fit1_text,'HorizontalAlignment','Left', 'FontSize',8, 'FontName', 'Helvetica');
        title([sample_prefixes{SampleIter}, Conditions(1,1).names{ConditionIter} ], 'FontSize',9, 'FontName', 'Helvetica', 'Interpreter', 'none');
        xlabel('lag time (s)', 'FontSize',9, 'FontName', 'Helvetica', 'Color', 'k');
        ylabel('time-averaged MSD (um^2)', 'FontSize',9, 'FontName', 'Helvetica', 'Color', 'k');
        axis([xMin xMax yMin yMax]);
        hold off;
        
        % display the fit as a plot:
        subplot(3,3,ConditionIter+3);
        % LOG SCALE
        xMax = 1.05*max(Conditions(1,1).MSD_time{ConditionIter}); yMax = 1.1*max(DataStruct(1,SampleIter).mean_MSD{ConditionIter});
        hold on;
        errorbar(Conditions(1,1).MSD_time{ConditionIter}, DataStruct(1,SampleIter).mean_MSD{ConditionIter}, DataStruct(1,SampleIter).Jack_std{ConditionIter}, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
        plot(xTime, yMSD, 'k-', 'LineWidth', 2);
        %text(0.02*xMax, 0.85*yMax, Fit1_text,'HorizontalAlignment','Left', 'FontSize',8, 'FontName', 'Helvetica');
        title([sample_prefixes{SampleIter}, Conditions(1,1).names{ConditionIter} ], 'FontSize',9, 'FontName', 'Helvetica', 'Interpreter', 'none');
        xlabel('lag time (s)', 'FontSize',9, 'FontName', 'Helvetica', 'Color', 'k');
        ylabel('time-averaged MSD (um^2)', 'FontSize',9, 'FontName', 'Helvetica', 'Color', 'k');
        set(gca, 'YScale', 'log');
        set(gca, 'XScale', 'log');
        axis([0.85*Conditions(1,1).LagTime(ConditionIter) xMax yMin yMax]);
        hold off;
        
    
    
    end
    
    
    %%%%%%% Merged all the data and then do the fitting %%%%%%%
    
    % find how much of the MSD to use for fitting:
    Max_idx = ceil(MSD_fit_fraction * length(merged_MSD_time));
    % take the required 
    MSD_time_for_fit = merged_MSD_time(1:Max_idx);
    MSD_for_fit = merged_MSD_mean(1:Max_idx);


    % fit the current data: 
    [MSD_fit, MSD_param] = fit(MSD_time_for_fit', MSD_for_fit', f, 'Lower', [0 0 0.02], 'Upper', [20 2 0.04], 'StartPoint', [3 0.8 0.035]); 
    % get the Confidence Interval:
    MSD_fit_CI = confint(MSD_fit);

    % generate fit for plotting the MSD fit:
    xTime = 0:0.005:1.2*max(merged_MSD_time);
    yMSD = 4 .* MSD_fit.D .* xTime.^MSD_fit.a + 4*MSD_fit.b^2;

    % generate text for display in the plot
    Fit2_text(1) = {'Power Law fit: MSD = 4*D*t^a + 4*LocError^2'};
    Fit2_text(2) = {['D = ', num2str(MSD_fit.D), ' um^2/s']};
    Fit2_text(3) = {['D (95% CI): [', num2str(MSD_fit_CI(1,1)), ';', num2str(MSD_fit_CI(2,1)), ']']};
    Fit2_text(4) = {['alpha = ', num2str(MSD_fit.a)]};
    Fit2_text(5) = {['alpha (95% CI): [', num2str(MSD_fit_CI(1,2)), ';', num2str(MSD_fit_CI(2,2)), ']']};
    Fit2_text(6) = {['LocError = ', num2str(MSD_fit.b), ' um']};
    Fit2_text(7) = {['LocError (95% CI): [', num2str(MSD_fit_CI(1,3)), ';', num2str(MSD_fit_CI(2,3)), ']']};
    
    % display the fit as a plot:
    subplot(3,3,7);
    % LINEAR SCALE
    xMax = 1.05*max(merged_MSD_time); yMax = 1.1*max(merged_MSD_mean);
    hold on;
    errorbar(merged_MSD_time, merged_MSD_mean, merged_MSD_std, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    plot(xTime, yMSD, 'k-', 'LineWidth', 2);
    text(0.02*xMax, 0.85*yMax, Fit2_text,'HorizontalAlignment','Left', 'FontSize',8, 'FontName', 'Helvetica');
    title([sample_prefixes{SampleIter}, ': all merged' ], 'FontSize',9, 'FontName', 'Helvetica', 'Interpreter', 'none');
    xlabel('lag time (s)', 'FontSize',9, 'FontName', 'Helvetica', 'Color', 'k');
    ylabel('time-averaged MSD (um^2)', 'FontSize',9, 'FontName', 'Helvetica', 'Color', 'k');
    axis([xMin xMax yMin yMax]);
    hold off;
    
    
    subplot(3,3,8);
    % LOG SCALE
    xMax = 1.05*max(merged_MSD_time); yMax = 1.1*max(merged_MSD_mean);
    hold on;
    errorbar(merged_MSD_time, merged_MSD_mean, merged_MSD_std, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    plot(xTime, yMSD, 'k-', 'LineWidth', 2);
    %text(0.02*xMax, 0.85*yMax, Fit2_text,'HorizontalAlignment','Left', 'FontSize',8, 'FontName', 'Helvetica');
    title([sample_prefixes{SampleIter}, ': all merged' ], 'FontSize',9, 'FontName', 'Helvetica', 'Interpreter', 'none');
    xlabel('lag time (s)', 'FontSize',9, 'FontName', 'Helvetica', 'Color', 'k');
    ylabel('time-averaged MSD (um^2)', 'FontSize',9, 'FontName', 'Helvetica', 'Color', 'k');
    set(gca, 'XScale', 'log');
    set(gca, 'YScale', 'log');
    axis([0.85*min(Conditions(1,1).LagTime) xMax yMin yMax]);
    hold off;
    
    % Done with all the plotting: now save a PDF:
    set(figure1,'Units','Inches');
    pos = get(figure1,'Position');
    set(figure1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(figure1, [plot_path, sample_prefixes{SampleIter},  'MSD-Plot.pdf'], '-dpdf','-r0');
    toc;
    
    close all;
    
end
