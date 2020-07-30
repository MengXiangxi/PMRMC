function PMRMC()
% PMRMC (PET-MRI Monte Carlo)
%  main function
%  a Monte Carlo simulation of PET-MRI positron cloud

clear all;
close all;
clc;
global V_INITIAL; % parameter for initial positron velocity distribution
global SCATTER_THRESHOLD;
global MAGNETIC_FIELD; % the default direction of magnetic is parallel to the Z-axis

% explore the influences of SCATTER_THRESHOLD and MAGNETIC_FIELD on positron PSF morphology
V_INITIAL = 1;
for SCATTER_THRESHOLD = 0:0.2:1
    for MAGNETIC_FIELD = [0, 100, 300, 500, 700, 900]
        record = zeros(ParamConst.NUM_OF_POSITRON, 6);
        for ii = 1:ParamConst.NUM_OF_POSITRON
            p = Positron;
            [p, track] = trackPositron(p,0);
            record(ii, :) = [p.coord, p.dir];
        end
        eval(['writematrix(record, ''V_INITIAL = ',num2str(V_INITIAL),', SCATTER_THRESHOLD = ',num2str(SCATTER_THRESHOLD * 10),', MAGNETIC_FIELD = ',num2str(MAGNETIC_FIELD),'.csv'');']);
        % write result data to .csv file
    end
end

% explore the influences of V_INITIAL on positron PSF morphology
SCATTER_THRESHOLD = 0.5;
MAGNETIC_FIELD = 500;
for V_INITIAL = 1:2:11
    record = zeros(ParamConst.NUM_OF_POSITRON, 6);
    for ii = 1:ParamConst.NUM_OF_POSITRON
        p = Positron;
        [p, track] = trackPositron(p,0);
        record(ii, :) = [p.coord, p.dir];
    end
    eval(['writematrix(record, ''V_INITIAL = ',num2str(V_INITIAL),', SCATTER_THRESHOLD = ',num2str(SCATTER_THRESHOLD * 10),', MAGNETIC_FIELD = ',num2str(MAGNETIC_FIELD),'.csv'');']);
    % write result data to .csv file
end

Visualize();
end
