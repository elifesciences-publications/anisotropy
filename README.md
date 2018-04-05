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
3. **Step 3** Classify all trajectories using a Hidden-Markov Model
	   1. Open script `Batch_vbSPT_classify.m` and click run.
4. **Step 4**
5. **Step 5**
6. **Step 6**

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




## Author
The code was written by and is maintained by Anders Sejr Hansen:

email: AndersSejrHansen@post.harvard.edu or
Anders.Sejr.Hansen@berkeley.edu

Twitter: @Anders_S_Hansen

Web: https://anderssejrhansen.wordpress.com

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

vbSPT





