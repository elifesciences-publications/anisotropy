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
	1. Open script `MergeQC_SPT_data.m` and click run.
	2. Use the script to merge data from multiple cells. Dependent
       function: 
	3. Adjust `ClosestDist` to set the threshold in micrometers for
       when particles are too close and trajectories should be aborted.
3.

Update 2017-07-26

Fixed plotting issue on small screen. Enabled weighting: if
UseWeights=1, Spot-On will now weigh each histogram at each dT
according to the relative amount of data in the least-squares
fitting.


Update 2018-02-02 version 1.04

The variable controlling whether all displacements from all
trajectories will be used has been renamed. "UseAllTraj" is now called
"UseEntireTraj" based on user feedback that the original name was
confusing. We would like to clarify that all trajectories are always
used, but that UseEntireTraj controls whether all displacements from a
given trajectory is used (yes if =1, no if =0).
Also improved plotting and performance. Compiling histograms is now
about 30-40% faster. 

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





