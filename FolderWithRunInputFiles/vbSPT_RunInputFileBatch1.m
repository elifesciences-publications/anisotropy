% Anders Sejr Hansen, October 2017
% Input fule for vbSPT to run in batch mode

% To run the HMM analysis manually type:
% >> VB3_HMManalysis('runinputfilename')


% Inputs
inputfile = './QC_data_reformatted/U2OS_C32_Halo-hCTCF_133Hz_pooled_QC_CD2_reformatted.mat';
trajectoryfield = 'CellTracks';

% Computing strategy
parallelize_config = 1;
parallel_start = 'theVBpool=gcp';  % executed before the parallelizable loop.
parallel_end = 'delete(theVBpool)'; % executed after the parallelizable loop.

% Saving options
outputfile = './HMM_first_QC_data/U2OS_C32_Halo-hCTCF_133Hz_pooled_QC_CD2_classified.mat';
jobID = 'Anders: vbSPT job is running';

% Data properties
timestep = 0.0075188; %timesep in [s]
dim = 2;
trjLmin = 2;

% Convergence and computation alternatives
runs = 3;
maxHidden = 2;

% Evaluate extra estimates including Viterbi paths
stateEstimate = 1; %set to 1 if you want each tracjectory classified

maxIter = [];    % maximum number of VB iterations ([]: use default values).
relTolF = 1e-8;  % convergence criterion for relative change in likelihood bound.
tolPar = [];     % convergence criterion for M-step parameters (leave non-strict).

% Bootstrapping
bootstrapNum = 10;
fullBootstrap = 0;

% Limits for initial conditions
init_D = [0.001, 16];   % interval for diffusion constant initial guess [length^2/time] in same length units as the input data.
init_tD = [2, 20]*timestep;     % interval for mean dwell time initial guess in [s].
% It is recommended to keep the initial tD guesses on the lower end of the expected spectrum.

% Prior distributions
% The priors are generated by taking the geometrical average of the initial guess range.
% units: same time units as timestep, same length unit as input data.
prior_type_D = 'mean_strength';
prior_D = 1;         % prior diffusion constant [length^2/time] in same length units as the input data.
prior_Dstrength = 5;   % strength of diffusion constant prior, number of pseudocounts (positive).

%% default prior choices (according nat. meth. 2013 paper)
prior_type_Pi = 'natmet13';
prior_piStrength = 5;  % prior strength of initial state distribution (assumed uniform) in pseudocounts.
prior_type_A = 'natmet13';
prior_tD = 10*timestep;      % prior dwell time in [s].
prior_tDstrength = 2*prior_tD/timestep;  % transition rate strength (number of pseudocounts). Recommended to be at least 2*prior_tD/timestep.

%% new prior choices (for advanced users, as they are not yet systematically tested)
%prior_type_Pi = 'flat';
%prior_type_A = 'dwell_Bflat';
%prior_tD = 10*timestep;      % prior dwell time in [s]. Must be greater than timestep (recommended > 2*timestep)
%prior_tDstd = 100*prior_tD;  % standard deviation of prior dwell times [s].






































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































