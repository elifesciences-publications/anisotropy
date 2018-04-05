%   MergeQC_SPT_data.m
%   written by Anders Sejr Hansen (AndersSejrHansen@post.harvard.edu;
%   @Anders_S_Hansen; https://anderssejrhansen.wordpress.com/)
%   License: GNU GPL v3
clear; clc; close all;
% add path for dependent functions:
addpath('Functions');

%   DESCRIPTION
%   Merge and QC SPT data: 
%       - read in individual MAT files from single cells
%       - Filter out trajectories that got too close
%       - merge all individual trackedPar into a single long one

ClosestDist = 2; % closest distance between particle in micrometers. This is the user-specified threshold that determines which particles will be removed
% where to save to?
SavePath = ['.', filesep, 'QC_data', filesep];

for DataSet = 1:3
    clear input_struct SampleName NumbFrames
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% STEP 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% LIST OF DATASETS %%%%%%%%%%%%%%%%%%%%%%%%
    
    if DataSet == 1  % 5 replicates of U2OS C32 Halo-hCTCF PA-JF646 data.
        input_struct = struct([]);
        %20160518 data
        input_struct(1).path = ['.', filesep, 'UnProcessedExampleData', filesep, '223Hz', filesep, '20160518_U2OS_C32_Halo-hCTCF_PA-JF646', filesep];
        input_struct(1).workspaces = {'20160518_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_4-405_4msExposure_cell1.rpt_tracked_TrackedParticles.mat', '20160518_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_5-405_4msExposure_cell2.rpt_tracked_TrackedParticles.mat', '20160518_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_5-405_4msExposure_cell3.rpt_tracked_TrackedParticles.mat', '20160518_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_5-405_4msExposure_cell4.rpt_tracked_TrackedParticles.mat', '20160518_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_5-405_4msExposure_cell5.rpt_tracked_TrackedParticles.mat', '20160518_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_5-405_4msExposure_cell6.rpt_tracked_TrackedParticles.mat', '20160518_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_5-405_4msExposure_cell7.rpt_tracked_TrackedParticles.mat', '20160518_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_5-405_4msExposure_cell8.rpt_tracked_TrackedParticles.mat'};
        input_struct(1).Include = [1,1,1,1,1,1,1,1];
        %20160520 data
        input_struct(2).path = ['.', filesep, 'UnProcessedExampleData', filesep, '223Hz', filesep, '20160520_U2OS_C32_Halo-hCTCF_PA-JF646', filesep];
        input_struct(2).workspaces = {'20160520_U2OS_Halo-hCTCF_25nM_PA-JF646_1ms633_5-405_4msExposure_cell1.rpt_tracked_TrackedParticles.mat', '20160520_U2OS_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msExposure_cell2.rpt_tracked_TrackedParticles.mat', '20160520_U2OS_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msExposure_cell3.rpt_tracked_TrackedParticles.mat', '20160520_U2OS_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msExposure_cell4.rpt_tracked_TrackedParticles.mat', '20160520_U2OS_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msExposure_cell5.rpt_tracked_TrackedParticles.mat', '20160520_U2OS_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msExposure_cell6.rpt_tracked_TrackedParticles.mat', '20160520_U2OS_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msExposure_cell7.rpt_tracked_TrackedParticles.mat', '20160520_U2OS_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msExposure_cell8.rpt_tracked_TrackedParticles.mat'};
        input_struct(2).Include = [1,1,1,1,1,0,1,1];
        %20160523 data
        input_struct(3).path = ['.', filesep, 'UnProcessedExampleData', filesep, '223Hz', filesep, '20160523_U2OS_C32_Halo-hCTCF_PA-JF646', filesep];
        input_struct(3).workspaces = {'20160523_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell1.mn_tracked_TrackedParticles.mat', '20160523_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell2.mn_tracked_TrackedParticles.mat', '20160523_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell3.mn_tracked_TrackedParticles.mat', '20160523_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell4.mn_tracked_TrackedParticles.mat', '20160523_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell5.mn_tracked_TrackedParticles.mat', '20160523_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell6.mn_tracked_TrackedParticles.mat', '20160523_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell7.mn_tracked_TrackedParticles.mat', '20160523_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell8.mn_tracked_TrackedParticles.mat'};
        input_struct(3).Include = [1,1,1,1,1,1,0,1];
        %20160524 data
        input_struct(4).path = ['.', filesep, 'UnProcessedExampleData', filesep, '223Hz', filesep, '20160524_U2OS_C32_Halo-hCTCF_PA-JF646', filesep];
        input_struct(4).workspaces = {'20160524_U2OS_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell1.mn_tracked_TrackedParticles.mat', '20160524_U2OS_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell2.mn_tracked_TrackedParticles.mat', '20160524_U2OS_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell3.mn_tracked_TrackedParticles.mat', '20160524_U2OS_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell4.mn_tracked_TrackedParticles.mat', '20160524_U2OS_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell5.mn_tracked_TrackedParticles.mat', '20160524_U2OS_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell6.mn_tracked_TrackedParticles.mat', '20160524_U2OS_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell7.mn_tracked_TrackedParticles.mat', '20160524_U2OS_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell8.mn_tracked_TrackedParticles.mat'};
        input_struct(4).Include = [1,0,1,1,1,1,1,1];
        %20160526 data
        input_struct(5).path = ['.', filesep, 'UnProcessedExampleData', filesep, '223Hz', filesep, '20160526_U2OS_C32_Halo-hCTCF_PA-JF646', filesep];
        input_struct(5).workspaces = {'20160526_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell1.rpt_tracked_TrackedParticles.mat', '20160526_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell2.rpt_tracked_TrackedParticles.mat', '20160526_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell3.rpt_tracked_TrackedParticles.mat', '20160526_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell4.rpt_tracked_TrackedParticles.mat', '20160526_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell5.rpt_tracked_TrackedParticles.mat', '20160526_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell6.rpt_tracked_TrackedParticles.mat', '20160526_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell7.rpt_tracked_TrackedParticles.mat', '20160526_U2OS_C32_Halo-hCTCF_25nM_PA-JF646_1ms633_6-405_4msCam_cell8.rpt_tracked_TrackedParticles.mat'};
        input_struct(5).Include = [1,1,1,0,0,1,1,1];
        
        SampleName = 'U2OS_C32_Halo-hCTCF_223Hz_pooled';
        NumbFrames = 20000;
        
    elseif DataSet == 2 % U2OS C32 pooled Halo-hCTCF; 7 ms Cam; 50 nM PA-JF549
        input_struct(1).path = ['.', filesep, 'UnProcessedExampleData', filesep, '133Hz', filesep, '20170522_U2OS_C32_Halo-hCTCF_PA-JF549', filesep];
        input_struct(1).workspaces = {'20170522_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_5-405_7msCam_cell01_Tracked.mat',  '20170522_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_6-405_7msCam_cell02_Tracked.mat', '20170522_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_12-405_7msCam_cell03_Tracked.mat', '20170522_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_17-405_7msCam_cell04_Tracked.mat', '20170522_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_6-405_7msCam_cell05_Tracked.mat', '20170522_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_7-405_7msCam_cell06_Tracked.mat', '20170522_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_13-405_7msCam_cell07_Tracked.mat', '20170522_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_7-405_7msCam_cell08_Tracked.mat'};
        input_struct(1).Include = [0,1,1,1,1,1,1,0];

        input_struct(2).path = ['.', filesep, 'UnProcessedExampleData', filesep, '133Hz', filesep, '20170525_U2OS_C32_Halo-hCTCF_PA-JF549', filesep];
        input_struct(2).workspaces = {'20170525_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_3-405_7msCam_cell01_Tracked.mat',  '20170525_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_5-405_7msCam_cell02_Tracked.mat', '20170525_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_10-405_7msCam_cell03_Tracked.mat', '20170525_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_12-405_7msCam_cell04_Tracked.mat', '20170525_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_6-405_7msCam_cell05_Tracked.mat', '20170525_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_11-405_7msCam_cell06_Tracked.mat', '20170525_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_13-405_7msCam_cell07_Tracked.mat', '20170525_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_6-405_7msCam_cell08_Tracked.mat'};
        input_struct(2).Include = [1,1,1,1,1,1,1,1];

        input_struct(3).path = ['.', filesep, 'UnProcessedExampleData', filesep, '133Hz', filesep, '20170526_U2OS_C32_Halo-hCTCF_PA-JF549', filesep];
        input_struct(3).workspaces = {'20170526_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_4-405_7msCam_cell01_Tracked.mat',  '20170526_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_5-405_7msCam_cell02_Tracked.mat', '20170526_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_9-405_7msCam_cell03_Tracked.mat', '20170526_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_9-405_7msCam_cell04_Tracked.mat', '20170526_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_6-405_7msCam_cell05_Tracked.mat', '20170526_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_11-405_7msCam_cell06_Tracked.mat', '20170526_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_6-405_7msCam_cell07_Tracked.mat', '20170526_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_6-405_7msCam_cell08_Tracked.mat'};
        input_struct(3).Include = [1,1,1,1,1,1,1,1];

        input_struct(4).path = ['.', filesep, 'UnProcessedExampleData', filesep, '133Hz', filesep, '20170527_U2OS_C32_Halo-hCTCF_PA-JF549', filesep];
        input_struct(4).workspaces = {'20170527_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_5-405_7msCam_cell01_Tracked.mat',  '20170527_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_5-405_7msCam_cell02_Tracked.mat', '20170527_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_7-405_7msCam_cell03_Tracked.mat', '20170527_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_7-405_7msCam_cell04_Tracked.mat', '20170527_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_7-405_7msCam_cell05_Tracked.mat', '20170527_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_7-405_7msCam_cell06_Tracked.mat', '20170527_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_5-405_7msCam_cell07_Tracked.mat', '20170527_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_6-405_7msCam_cell08_Tracked.mat'};
        input_struct(4).Include = [1,1,1,1,1,1,1,1];
        
        SampleName = 'U2OS_C32_Halo-hCTCF_133Hz_pooled';
        NumbFrames = 30000;           
        
    elseif DataSet == 3 % U2OS C32 pooled Halo-hCTCF; 13 ms Cam; 50 nM PA-JF549
        input_struct = struct([]);
        input_struct(1).path = ['.', filesep, 'UnProcessedExampleData', filesep, '74Hz', filesep, '20170522_U2OS_C32_Halo-hCTCF_PA-JF549', filesep];
        input_struct(1).workspaces = {'20170522_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_12-405_13msCam_cell01_Tracked.mat',  '20170522_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_12-405_13msCam_cell02_Tracked.mat', '20170522_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_7-405_13msCam_cell03_Tracked.mat', '20170522_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_7-405_13msCam_cell04_Tracked.mat', '20170522_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_14-405_13msCam_cell05_Tracked.mat', '20170522_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_13-405_13msCam_cell06_Tracked.mat', '20170522_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_7-405_13msCam_cell07_Tracked.mat', '20170522_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_13-405_13msCam_cell08_Tracked.mat'};
        input_struct(1).Include = [0,1,1,1,1,0,1,0];

        input_struct(2).path = ['.', filesep, 'UnProcessedExampleData', filesep, '74Hz', filesep, '20170522_U2OS_C32_Halo-hCTCF_PA-JF549', filesep];
        input_struct(2).workspaces = {'20170525_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_5-405_13msCam_cell01_Tracked.mat',  '20170525_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_8-405_13msCam_cell02_Tracked.mat', '20170525_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_5-405_13msCam_cell03_Tracked.mat', '20170525_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_5-405_13msCam_cell04_Tracked.mat', '20170525_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_11-405_13msCam_cell05_Tracked.mat', '20170525_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_5-405_13msCam_cell06_Tracked.mat', '20170525_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_6-405_13msCam_cell07_Tracked.mat', '20170525_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_12-405_13msCam_cell08_Tracked.mat'};
        input_struct(2).Include = [1,1,1,1,1,1,1,1];

        input_struct(3).path = ['.', filesep, 'UnProcessedExampleData', filesep, '74Hz', filesep, '20170522_U2OS_C32_Halo-hCTCF_PA-JF549', filesep];
        input_struct(3).workspaces = {'20170526_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_6-405_13msCam_cell01_Tracked.mat',  '20170526_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_6-405_13msCam_cell02_Tracked.mat', '20170526_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_5-405_13msCam_cell03_Tracked.mat', '20170526_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_6-405_13msCam_cell04_Tracked.mat', '20170526_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_9-405_13msCam_cell05_Tracked.mat', '20170526_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_5-405_13msCam_cell06_Tracked.mat', '20170526_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_12-405_13msCam_cell07_Tracked.mat', '20170526_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_12-405_13msCam_cell08_Tracked.mat'};
        input_struct(3).Include = [1,1,1,1,1,1,1,1];

        input_struct(4).path = ['.', filesep, 'UnProcessedExampleData', filesep, '74Hz', filesep, '20170522_U2OS_C32_Halo-hCTCF_PA-JF549', filesep];
        input_struct(4).workspaces = {'20170527_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_6-405_13msCam_cell01_Tracked.mat',  '20170527_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_11-405_13msCam_cell02_Tracked.mat', '20170527_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_5-405_13msCam_cell03_Tracked.mat', '20170527_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_5-405_13msCam_cell04_Tracked.mat', '20170527_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_5-405_13msCam_cell05_Tracked.mat', '20170527_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_5-405_13msCam_cell06_Tracked.mat', '20170527_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_7-405_13msCam_cell07_Tracked.mat', '20170527_U2OS_C32_Halo-hCTCF_50nM_PA-JF549_1ms-AOTF100-1100mW-549nm_7-405_13msCam_cell08_Tracked.mat'};
        input_struct(4).Include = [0,1,1,1,1,1,1,1];
        
        SampleName = 'U2OS_C32_Halo-hCTCF_74Hz_pooled';
        NumbFrames = 30000;
        
        
      
        
    end
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% STEP 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%% PERFORM QC ON DATA %%%%%%%%%%%%%%%%%%%%%%%%
    disp('==============================================================');
    tic;
    disp(['Analyzing ', SampleName, '; DataSet number ', num2str(DataSet)]);
    
    trackedPar_QC = struct();
    trackedParCounter = 0;
    % loop over each replicate
    for RepIter = 1:length(input_struct)
        curr_path = input_struct(RepIter).path;
        curr_workspaces = input_struct(RepIter).workspaces;
        curr_Include = input_struct(RepIter).Include;
        for CellIter = 1:length(curr_workspaces)
            if curr_Include(CellIter) == 1
                % load in the data
                load([curr_path, curr_workspaces{CellIter}]);
                % perform QC
                temp_trackedPar_merged = RemoveAmbigiousTracks( trackedPar, ClosestDist );
                
                % because you are silly, your old data uses a row vector
                % format for Frame and TimeStamp and your new format uses a
                % column vector for this; so need to check if they were in
                % a row vector format and then convert to column vector
                % format:
                for TrackIter = 1:length(temp_trackedPar_merged)
                    if isrow(temp_trackedPar_merged(1,TrackIter).Frame)
                        temp_trackedPar_merged(1,TrackIter).Frame = temp_trackedPar_merged(1,TrackIter).Frame';
                        temp_trackedPar_merged(1,TrackIter).TimeStamp = temp_trackedPar_merged(1,TrackIter).TimeStamp';
                    end
                end
                
                
                
                % merge the dataset
                if trackedParCounter == 0
                    trackedPar_QC = temp_trackedPar_merged;
                    % update the counter:
                    trackedParCounter = trackedParCounter + 1;
                else
                    % how much to add to the frame number
                    ToAdd = trackedParCounter * NumbFrames;
                    % update the frame number:
                    for TrackIter = 1:length(temp_trackedPar_merged)
                        temp_trackedPar_merged(1,TrackIter).Frame = temp_trackedPar_merged(1,TrackIter).Frame + ToAdd;
                    end
                    % append the new trackedPar:
                    trackedPar_QC = horzcat(trackedPar_QC, temp_trackedPar_merged);
                    % update the counter:
                    trackedParCounter = trackedParCounter + 1;
                end
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% STEP 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%% SAVE THE QC'ed DATA %%%%%%%%%%%%%%%%%%%%%%%%
    disp('saving the merged and QCed dataset');
    save([SavePath, SampleName, '_QC_CD', num2str(ClosestDist), '.mat'], 'trackedPar_QC');
    
    toc;
    disp('==============================================================');
end
