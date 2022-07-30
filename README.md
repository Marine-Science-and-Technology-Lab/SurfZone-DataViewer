# SurfZone-DataViewer
Data viewer GUI for surf-zone experiments at IIHR wave basin.
1. 	Data Overview
Each data collection (3-12 sub-trials) is saved as a single data structure, named as 'VT###_Consolidated_TS.mat' (Phase 1) or 'MT###_Consolidated_TS.mat' (phase 2). Each trial in turn contains between 3 and 12 “sub-trials,” which are nominally replications of one another. The format of the data structure is proprietary, using MATLAB timeseries objects to leverage the many object functions (plot, interpolate, split, etc) available for this datatype. Figure 1 depicts five sub-trials for run MT044, with each sub-trial indicated by a colored portion of the continuous 600-second acquisition. The division of each master run into sub-trials is automatically handled by the GUI, using event markers, shown as filled red circles indicating the beginning of each sub-trial.
 
Figure 1. Example of X and Y velocities of the robot as functions of time. Five sub-trials can be seen in the single 600-second time record, each highlighted as a colored trace.


# 1.1. 	Data Format
The final format is depicted graphically in Figure 2. Each trial is stored as a single data structure containing a single ‘Info’ field with all run parameters and a collection of data type fields and a ‘Data’ field containing all measured data types as sub-fields. Each data type field contains individual data streams grouped together under that type (e.g. ‘Roll’, ‘Pitch’, and ‘Yaw’ streams are grouped together in the ‘Orientation’ type). Each stream is stored as a timeseries object, with additional metadata to describe its units, measurement location, and details of the data acquisition. Each trigger used to release the MQS and begin a transit is stored as a timeseries event. Not all sub-fields are present for all data types/streams. Data from Phase 1 tests and the more-recent Phase 2 tests have been consolidated using this structured format.
 
Figure 2. Format of final data structure used to disseminate experimental data. Fields enclosed in square brackets […] are not present for all data types or streams.

# 1.2. 	Clustering
Each set of test conditions was replicated for at least two data collection periods. While conditions were controlled as carefully as possible, we sometimes observed bifurcations in the robot’s response. These were attributed to either (a) failure of the wavemakers or robot actuation or (b) the zero-crossing of the wavemakers (on which the model release was triggered) was 180 degrees out of phase. As a result, the chronologically ordered raw data contains several potential response patterns for each set of experimental conditions. 
To make it easier to assess ensembles of similar data, a hierarchical clustering technique was used to remove outliers and sort data into self-similar groups or “clusters.” An example of the clustering applied to a deep-water wave gauge signal is shown in Figure 3.
 
Figure 3. Clustering of wave gauge signals, showing one outlier (wavemaker error) and two self-similar groups with a 180-degree phase shift.

Note that the clustered data are no different from the raw data; they are simply organized into self-similar groups for each set of run conditions for easier viewing and calculation of statistics.

# 2. 	DataViewer GUI Description
As a simpler alternative to using MATLAB to access the shared data, we have also written and published a graphical user interface (GUI) that can be used to open, view, and export desired subsets of the data contained in the shared files, in addition to overall run parameters, mass properties, and a catalog of all data included for each trial. The GUI is compatible with data from Phase 1 and Phase 2 testing. A snapshot of the GUI with its plotting functions is shown in Figure 3. The objective of the GUI is to enable easy access and viewing of experimental data, so that end-users may find desired data, choose the desired replications/transits, and plot and/or export that subset to easily-read TXT files. Among the key capabilities are:
-	(A) The ability to load either an arbitrary number of raw trials simultaneously or a set of pre-clustered trials, so that they may be plotted against one another. 
-	(B) A run parameters description window detailing the log entry for the run(s) being viewed, including programmed sequences, wave conditions, and experimenter comments.
-	(C) Plot customization area, in which any combination of recorded signals may be selected for plotting. Individual sub-trials may be selected/de-selected, and the window of time surrounding the MQS robot release trigger may be adjusted.
-	(1) Plotting functionality that allows any combination of signals to be plotted for any number of sub-trials / surf transits, across any combination of master trials. Data can be plotted sequentially (1A) (against time for the entire data collection) or in an overlay (1B) (time relative to the model release).
-	(2) Ensemble plotting will show ensemble mean and standard deviations of the selected signals for selected trials and subtrials. All data are resampled on a common timebase and aligned so that the experimental trigger event is coincident before taking cross-sectional statistics.
-	(3) FFT plotting shows individual and averaged frequency spectra for the selected signals and trials/sub-trials.
-	(4) Plot ensemble means and 1-sigma envelopes of arbitrary X-Y data pairs for selected subtrials.
-	(5) Export functionality will write a single CSV file for each of the sub-trials selected. Each CSV file contains all of the stored data, interpolated to the same timebase, along with headers to indicate the units and measurement locations.
-	(6) Video playback opens a child window with a hyperlinked list of all videos recorded for the trial being viewed. When a video is clicked, it will open in an internet browser and play from a shared cloud drive (Google drive).
-	(7) Mass property report that shows the mass, mass-center, and mass-moments-of-inertia for the version (Phase 1 or Phase 2) of the MQS being viewed.
-	(8) 3D plot showing the locations of wave measurement sensors relative to the beach and still waterplane.
-	(9) Signal catalog that reports the type, name, units, sampling rate, resolution, and description of every signal available for plotting and exporting in the trial being viewed.
 
 
 ![GUI Snapshot](.imgs/Fig4.png?raw=true "Snapshot")
Figure 4. Snapshot of GUI and functions

# 3. 	Installation Notes for DataViewer GUI
Several versions of the GUI are available. The best installation option will depend upon whether you have admin access and/or MATLAB installed on your computer.
•	[RECOMMENDED] Run the DataViewer_GUI_Installer_Vxxx.exe file. This requires administrator permissions. This will install both the data viewer application and the necessary MATLAB runtime environment (unless the runtime is already installed, in which case it will only install the executable).

Note: The installer will default to the 'program files' directory for the app installation. I recommend checking the box to create a shortcut on the desktop so the application is easier to open.
If you lack administrator permissions on your computer, try one of the options below
•	If you have MATLAB 2020 or later already installed, you may run the UI_MQS_DataViewer_Vxxx.m file as a MATLAB script. No additional steps should be necessary.

•	If you have a recent version of matlab (we haven’t tested exactly what years will work, but probably requires 2021a or newer), you may also run the matlab app installer. This will install the program as an application within MATLAB.

•	If you do not have matlab, but you have the R2021A matlab runtime (version 9.10) installed, you may use the portable version of the executable by copying and unzipping the UI_MQS_DataViewer_Portable.zip folder.




#4. 	Basic Usage of DataViewer GUI
Before use, you must download one of the compatible datasets. The master set of all data may be downloaded as a single .zip file here, or individual datasets may be accessed using the links below:
-	Phase 1 – TE2 Maneuvers
-	Phase 2 – TE2 Environment Tests
-	Phase2 – TE2 Maneuvers

1.	There are two ways to load data:
a.	Click Open Raw Data File(s): This allows you to load one or more trial datasets from the chronologically-ordered database. Select one or more .mat files. Each .mat file is the result of a single data acquisition session. You may select an arbitrary number of .mat files. Consult the Master_RunList.xlsx table to find runs matching specific conditions of interest.
b.	Click Open Test Condition Group: This will load a subset of trials and subtrials that have have been grouped by run conditions and similarity of response. Runs have been clustered using a heirarchical clustering technique so that a larger ensemble of similar trials can be loaded without the need to manually find those with similar responses. 
2.	The various listboxes in the GUI will self-populate with the names of available signals of each type. NOTE: when multiple .mat files are loaded simultaneously, only the signals common to both files will be shown here. E.g. If Trial001 contains thrust measurements, but Trial002 does not, then the thrust measurements will be omitted when both Trial001 and Trial002 are loaded simulataneously.
3.	Check that the File(s) Currently Open window has been populated with your selected files. The Run Parameters & Metadata window contains a table of the experimental conditions for each of the selected trials. Use the scroll-bar to view additional details.
4.	Click List of Signals to view a catalog of all signals available in the selected trial(s).
5.	Click Wave Sensor Locations to view a 3D model of the wave basin with the locations of each wave measurement instrument for the currently-loaded trial.
6.	Select one or more signals. Use the CTRL key to select/de-select multiple signals. You may select as many as desired.
7.	Select at least one sub-trial from the Sub-Trials to Include listbox.
8.	Click Plot Selection and view the resulting timeseries plots. (Note that this will close any currently-open time-series plot windows). Plotting can be performed in two ways
a.	Sub-Trials Sequential will show all data against global time, so that sequential sub-trials are plotted in order. 
b.	Sub-Trials Overlaid will align the moment at which the MQS robot was released for each sub-trial and set that time to T=0. Each subtrial will also be trimmed to the pre- and post- release window times.
9.	Select/De-select sub-trials as needed to remove outliers, etc.
10.	Click Plot Ensemble Average to generate a figure showing the ensemble mean and standard deviation across the selected sub-trials. This will close any currently-open ensemble average plot windows.
11. Click 'Plot Custom X vs Y' to select the independent and dependent variables for plotting. The selected subtrials will be averaged and the ensemble mean will be plotted with a one-sigma envelope around it (determined from the covariance in X-Y pairs at each timestep).
12.	Click FFT to plot the frequency spectra of the selected signals and sub-trials. A mean spectrum will be overlaid onto each window. This will close any currently-open FFT plot windows.
13.	Click Export Selection to TXT. Specify a filename. ALL measurement signals will be exported to a tab-delimited ASCII text file, with time dictated by the window size settings. One txt file will be created per sub-trial, with the filename: [YOUR_FILENAME]_RUNID_Rep[Sub_Trial#].txt. You can select whether or not to re-interpolate each subtrial to a common (relative) time vector.
14.	Click Play Videos. One child window will open per loaded trial. Each window will contain an HTML table listing available videos of that experimental trial. Click on the entry to open the video in an internet browser window. 

Note 1: Videos will play from a shared web location (Kaltura), so you must have internet access to use this feature.
Note 2: Videos are not available for all trials. If no videos exist for your selected trial(s), the table will display a message indicating that no videos were found.