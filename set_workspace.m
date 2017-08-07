% Choose 'Change folder', not 'Add to path' when running this first thing.

%% Set the MATLAB path to the libraries in this file's path
disp('Restoring default MATLAB path')
restoredefaultpath

disp('Adding path for manyd package')
prefix = mfilename('fullpath');
dirs = regexp(prefix,'[\\/]');
addpath('.')

%% Set a default for plot text style
set(0,'DefaultAxesFontSize',13); 
set(0,'DefaultTextFontSize',16);

