Anisotropy
--------------------------

# Overview of code for data processing and spatiotemporal anisotropy calculations
This repository contains Matlab code for processing SPT trajectory data
and for calculating anisotropy at multiple spatiotemporal
scales.

## Quick tutorial: going through each step

1. **Step 1**: Obtain SPT data at multiple temporal scales
   1. Here we will use the provided example data for U2OS C32
      Halo-hCTCF, which is provided in the directory
      `UnProcessedExampleData` and contains data at 3 frame rates:
      ~223 Hz, ~133 Hz, ~74 Hz. 
2. **Step 2**: Merge and QC the SPT data from many different single
cells
	1. Open script `MergeQC_SPT_data.m` and click run (~1-2 min).
	2. Use the script to merge data from multiple cells. Dependent
       function: `RemoveAmbigiousTracks.m`
	3. Adjust `ClosestDist` to set the threshold in micrometers for
       when particles are too close and trajectories should be
       aborted.
    4. At the end of this step, the directory `QC_data` should contain
       a single MAT file for each frame rate,
       e.g. `U2OS_C32_Halo-hCTCF_74Hz_pooled_QC_CD2.mat`
3. **Step 3** Classify all trajectories using a Hidden-Markov Model (HMM)
   1. Open script `Batch_vbSPT_classify.m` and click run.
   2. This script uses the HMM vbSPT to classify trajectories into
      *BOUND* and *FREE* segments using a 2-state model. Please see
	  acknowlegdements for a full citation of Persson et al. for vbSPT.
  3. Since vbSPT cannot handle gaps, `Batch_vbSPT_classify.m` goes
         through trajectories with gaps splits them into
         subtrajectories. vbSPT runs in parallel by default. 
  4. At the end, HMM-classified trajectories are saved to
     `HMM_first_QC_data` containing two variables: `CellTracks` is a
     cell array with the xy data. `CellTrackViterbiClass` is the
     HMM-classification, with `1`=*BOUND* and `2`=*FREE*. 
4. **Step 4** Temporally subsample the HMM-classified SPT data
	1. Open script `CompileTemporalSubSamplesOfHMM.m` and click run.
	2. This script subsamples the data to generate trajectories at
    longer lag times (e.g. 100 Hz --> 50 Hz).
	3. It also carries over the HMM-classification from the faster
       frame rates. Dependent function: `TemporallyReSampleCellTracks.m`
5. **Step 5** Perform full SpatioTemporal analysis of anisotropy
   1.	Open script `Process_SpatioTemporal_AngleAnalysis_v2.m` and
   click run.
   2. This will do a full analysis of anistropy at multiple
      spatiotemporal scales. The relevant parameters for the analysis
      should be specificied in
      `Process_SpatioTemporal_AngleAnalysis_v2.m`.
   3. The bulk of the analysis is performed in
      `angleFWHM_Amp_HMM_analyzer_v5.m`. Additional dependent functions
      `AngleMatrix_analyzer.m` and `ComputeAmpFWHM.m`.
    4. At the end of the run, the analysis results are saved as MAT
      file: `U2OS_C32_SpatioTemporalAnalysis.mat` 
6. **Step 6** Plot the results
	  1. Open the script `PLOT_SpatioTemporalAnalysisResults_v4.m` and
      click run.
	  2. Adjust which datasets to analyze and where to save the
         plots. 2 PDFs with 27 total subplots will be save per
         sample.
	  3. Although the code is ~600 lines, it only does plotting of
         data already processed in Step 5. 

## Detailed description of each step
Below we will describe each step in more details. 

#### Step 1 - Obtain SPT data at multiple temporal scales
Here we will use the provided example data for U2OS C32 Halo-hCTCF, which is provided in the directory `UnProcessedExampleData` and contains data at 3 frame rates: ~223 Hz, ~133 Hz, ~74 Hz. 

#### Step 2 - Merge and QC the SPT data from many different single cells
When performing tracking and localization, each single cell results in
a single file. Thus, to keep things manageable, we use
`MergeQC_SPT_data.m` to merge data from all these single cells (~20-30
cells) into a single file for a given frame rate, by concatenating the
frames (e.g. if two movies with 20,000 frames are merged, frame 1 in
the second movie becomes frame 20,001). To minimize tracking errors,
we also use `ClosestDist = 2` (in units of μm) to abort trajectories
where two particles came closer than 2 μm to each other. This is
achieved by calling the function `RemoveAmbigiousTracks.m`. At the end of this step, the directory `QC_data` should contain a single MAT file for each frame rate, e.g. `U2OS_C32_Halo-hCTCF_74Hz_pooled_QC_CD2.mat`.

#### Step 3 - Classify all trajectories using a Hidden-Markov Model (HMM)
We use `Batch_vbSPT_classify.m` to classify trajectory segments into
*BOUND* and *FREE* segments. `Batch_vbSPT_classify.m` first removes
gaps from all the trajectories and then calls vbSPT. We implemented a
2-state Hidden Markov Model (HMM) through vbSPT, which uses a Bayesian
approach to infer the most likely state for each displacement in a
trajectory (“bound” or “free”) based on displacement lengths and
trajectory history. This is important, because the apparent movement
of bound molecules is dominated by localization errors. Thus, we want
to exclude bound/immobile molecules from the analysis since we are
interested in understanding the nuclear search mechanism, which only
applies to diffusing/free molecules and also because bound/immobile
molecules will artefactual appear anisotropic due to localization
errors around a relatively fixed position. Thus, by using a 2-state
HMM we can filter out the bound population and restrict our subsequent
analysis to the free population (the number of states is controlled by
the variable `maxHidden`. `Batch_vbSPT_classify.m` will automatically
run on all SPT datasets in the directory `input_path`, reformat data
to remove gaps and save the reformatted data to `path_reformatted` and
finally save the classified data to `path_classified`. The final
classified SPT data contains 4 variables:
* `CellTracks`, a cell array where each element is a trajectory and is
a Nx2 matrix with the XY coordinates for each of the N frames.
* `CellTrackViterbiClass`, a cell array where each element is a N-1
  column vector corresponding to the relevant trajectory in
  `CellTracks`. In other words, `CellTrackViterbiClass` classifies
  each displacement and thus is one length shorter than the number of
  localizations in `CellTracks`. `1` corresponds to *BOUND* and `2`
  corresponds to *FREE*. E.g. if a trajectory had 5 localizations,
  `CellTrackViterbiClass` will have length 4.
* `vbSPT_metadata`, a structure array object containing the most
    relevant vbSPT metadata such as the inferred diffusion constants,
    subpopulation sizes and transition matrix.	
* `LagTime`, the time between frames in units of seconds.
	
`Batch_vbSPT_classify.m` calls two dependent functions: `InferFrameRateFromName.m`, which infers the frame rate from the filename and `EditRunInputFile_for_batch.m` which edits the file `vbSPT_RunInputFileBatch.m` to automatically feed the relevant information to vbSPT. In summary, at the end of this step the trajectories have been classified to allow subsequent analysis to focus exclusively on the free/diffusing population. 

#### Step 4 - Temporally subsample the HMM-classified SPT data
Next, we use `CompileTemporalSubSamplesOfHMM.m` to temporally
subsample the existing SPT data and generate trajectories with longer
lag times. E.g. by subsampling every 10th frame (frames 1, 11, 21, …)
of the 223 Hz data and every 6th frame (frames 1, 7, 13, …) of the 133
Hz data, we can generate new SPT trajectories at 22.2 Hz. Full details
on how the 223 Hz, 133 Hz and 74 Hz SPT data was temporally subsampled
is given in the structure array, `TempSubSampleStruc` in lines
40-117. We use this approach to generate SPT data at the following
frame rates: 44.4 Hz, 34.2 Hz, 26 Hz, 22.2 Hz, 18.8 Hz, 16.5 Hz, 14.8
Hz, 12.2 Hz, 10.6 Hz, 9.2 Hz. The subsampling is performed in the
dependent function `TemporallyReSampleCellTracks.m` and we note an
important  potential ambiguity here. To illustrate, suppose we want to take every 3rd frame of a trajectory (i.e. frames 1, 4, 7, …). Since the SPT data has already been HMM-classified, a trajectory of length N will have N-1 displacements classified as either bound or free. We would like to carry over this classification to the temporally subsampled trajectory. While most trajectories are either entirely free (`2`) or bound (`1`), some trajectories show transitions. In this example, say the HMM-classification is [1,2,2,2,2,1] for frames 1-7. In this case, the subsampled displacement from frame 1-to-4 will have HMM-classification [1,2,2], but we have to label it as either “1” or “2’ in the sub-sampled data. In these cases, we took the most conservative approach. Since our primary goal is to filter out the bound population, we labelled any temporally subsampled displacement as bound as long as any one of the intermediate displacements were classified as bound, even if the majority were free. This is implemented in the function `TemporallyReSampleCellTracks.m`. Finally, at the end of this procedure, all the temporally subsampled and HMM-classified SPT datasets are saved to the directory `HMM_first_QC_data`. 


#### Step 5 - Perform full SpatioTemporal analysis of anisotropy
We wrote `Process_SpatioTemporal_AngleAnalysis_v2.m` to perform all
the analysis of the HMM-classified trajectory data at multiple spatial
and temporal scales. The bulk of the analysis is performed in the
dependent function `angleFWHM_Amp_HMM_analyzer_v5.m` and the code also
calls `AngleMatrix_analyzer.m` and `ComputeAmpFWHM.m`. The analysis is
somewhat complicated and for full details, we refer the reader to the
underlying function `angleFWHM_Amp_HMM_analyzer_v5.m`. But briefly, we
describe the analysis, input parameters and output results here. For a
given trajectory, as long as it consists of at least 3 localizations
and thus 2 displacements, it is possible to calculate an angle between
adjacent displacements. If we define the 3 localizations making up the
angle as p1, p2 and p3, we can define 2 column vectors and calculate
the angle between them as follows (using Matlab syntax):
```matlab
v1 = (p2-p1)';
v2 = (p3-p2)';
angle(1,1) = abs(atan2(det([v1,v2]),dot(v1,v2)));
angle(1,2) = 2*pi-angle(1,1);
```
Here, the second element in the angle is due to the factor that
whether a 150 degree angle is classified as 150 or 210 degrees is
arbitrary. Note though that the above calculation is in units of
radians. We then loop over all the trajectories. However, we want to
be careful to filter out the bound population and we therefore apply
two criteria. First, the displacements must be HMM-classified as
*FREE* and, second, both displacements must be at least of length
`MinMinJumpThres`. Only if both criteria are satisfied, do we count
the angle.  These criteria are used for the bulk analysis of the
angles (subplots 1-6 in the plotting step (Step 6)). Afterwards, the
analysis quantifies 4 different anisotropy metrics:

* `AC`: anisotropy coefficient which is define as: AC =
  log2(P(a[150-210])/ P(a[330-30])), and this metric was introduced
  previously by Izeddin et al. (eLife 2014). Thus, the AC quantifies how much more
  likely a molecule is to go in the backwards after having going
  forwards.
  
* `Amp`: how the amplitude is calculated in illustrated in Figure X and
	detailed in the function `ComputeAmpFWHM.m`. Briefly, we build a
	histogram of the probability as a function of the binned angle. We
	then use fine-scale interpolation to overcome the binning. From
	this we fit the background density and then calculate the “excess”
	anisotropy. Since the histogram sums to 1, the amplitude takes
	values between 0 and 1. This provides a related but somewhat
	orthogonal metric or anisotropy.
	
* f(180+/-30/0+/-30) or `f(180/0)` for short: is identical to the AC, but does
	not use a logarithm. Essentially, f(180/0) quantifies how many
	times more likely a particle is to go backwards relative to
	continuing forwards. For example, if f(180/0)=1.6, the particle
	is 1.6-fold more likely to return in the backwards direction than
	to continue forwards.
	
* `FWHM` (full width at half-maximum): quantifies the width of the
  anisotropy histogram and is defined as the full width of the
  histogram peak centered around 180 at the half-maximal value
  (i.e. when the probability is half-way in between the peak of the of
  the angle histogram and the background probability). This analysis quantifies the “bulk” anisotropy.

To analyze how the anisotropy changes with space and time, we do binning. For spatial analysis, i.e. how the anisotropy metrics depend on the length of the two displacements making up the angle, we control the range of translocations in the variable `MovingThreshold`, which we allow to run from 100 nm to 950 nm in bins of 50 nm. Thus, in this case we additionally consider displacements that are HMM-classified as free and also which are at least 100 nm long (set by the variable `GlotbalMinJumpThres`). Since there are two displacements making up the angle, one can either quantify their mean displacement, their minimal displacement (univariate analysis) or the length of both displacements (bivariate analysis), and we took all three approaches here. For spatial analysis, we averaged over all 13 time-scales (from 223 Hz to 9.2 Hz) and calculated the anisotropy metrics. For example, for `f(180/0)` as a function of mean displacement, we populated the [100 nm ; 150 nm] bin by taking all angles from all 13 frame rates where the mean of the two displacements making up the angle is between 100 and 150 nm and then calculated `f(180/0)` using all of these angles. And likewise for the other metrics. For analysis of anisotropy as a function of time, we use all the angles making up a single frame rate satisfying the both of the two criteria listed above: HMM-classified as *FREE* both displacements at length `MinMinJumpThres` (200 nm).
Errorbars were estimated using re-sampling and is controlled by the variables `JackKnife_fraction` and `JackKnife_iterations`. Specifically, we resampled 50% of the angles with replacement 50 times and calculated the anisotropy metrics for each iteration. The error bars reported here show the standard deviation between these 50 iterations. 
We noticed that at very long displacements, we would occasionally see very strange trajectories such as a particle shifting back and forth between 2 points separated by a large distance (~800 nm). These are almost certainly a tracking artifact, perhaps from 2 bound molecules blinking out-of-frequency. To remove this and avoid these biasing the analysis especially at long displacements, we removed trajectories where more than half of the angles were highly anisotropic using the variables `MaxNumAngles` and `MaxAsymAnglesFrac`. 
Finally, all of the anisotropy metrics are saved to the structured array `FinalResults` and saved. With the example data provided on GitLab, the workspace saved is `U2OS_C32_SpatioTemporalAnalysis.mat`.

#### Step 6 - Plot the results
Finally, we used `PLOT_SpatioTemporalAnalysisResults_v4.m` to plot and
visualize the results for each individual data set and similar code to
overlay results from multiple different samples. The code will
generate 27 sub-plots per cell line / condition and these are save as
2 PDF files in the directory `QC_Plots`. Please see these two plots:
![Plot1](https://gitlab.com/anders.sejr.hansen/anisotropy/blob/master/QC_Plots/U2OS_C32_Halo-hCTCF___HMMfirst_Plot1.pdf)
and
![Plot2](https://gitlab.com/anders.sejr.hansen/anisotropy/blob/master/QC_Plots/U2OS_C32_Halo-hCTCF___HMMfirst_Plot2.pdf)



#### Issues
This code was tested with Matlab 2014b on a Mac and comes with vbSPT
v1.1.2. Newer versions of Matlab (2015 and newer) may need to use
vbSPT v.1.1.4 instead.


## License
This program is released under the GNU General Public License version 3 or upper (GPLv3+).


    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


## Acknowledgements

This project makes heavy use of vbSPT for HMM-classification of
trajectories into *BOUND* and *FREE* segments. Please see the full
vbSPT paper below for details (see also SourceForge for the latest
version https://sourceforge.net/projects/vbspt/ ):

    Extracting intracellular reaction rates from single molecule tracking data
    Person F,Lindén M, Unoson C, Elf J
    Nature Methods 10, 265–269 (2013). doi:10.1038/nmeth.2367







