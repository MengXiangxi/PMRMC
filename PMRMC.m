function record = PMRMC(numOfPositron, magneticField, ...
    annihilateThreshold, scatterThreshold, vInitial, isTrack)
% PMRMC (PET/MR Monte Carlo)
% Xiangxi Meng (Beijing Cancer Hospital) and Lujia Jin (Peking Univeristy)
% A Monte Carlo simulation of positron propagation in the magnetic field.
%
% This code presents a minimum environment for Monte Carlo simulation of 
% positron propagation, emphasizing on the effect of the magnetic field.
% It is meant to qualitatively demonstrate the physical effect in medical
% PET/MR scanners.
%
% Input parameters:
% numOfPositron - number of positrons simulated;
% magneticField - the unitless magnetic field;
% annihilatedTreshold - annihilation threshold, [0,1], the higher the more
%                       likely to annihilate;
% scatterThreshold - scattering threshold, [0,1], the higher the more like-
%                    ly to scatter;
% vInitial - initial velocity distribution parameter;
% isTrack - track mode or point cloud mode; 0 - point cloud output, 1 - 
%           positron trajectory tracking.
%
% Output parameter:
% record - the record of the annihilated point or positron trajectory.
% record can either be a cell (containing matrice) or a matrix, depending
% on isTrack.
% The contents of record are in the format specified.
% The first three columns of the matrix are the corresponding coordinates.
% The next three columns of the matrix are the corresponding velocity.
% These are in the Cartesian coordinates.
% The last column records the number of scattering events.
%
% mengxiangxi_{a]_pku.edu.cn
% Created: 20200801
%

% Load and initiate the parameters
global NUM_OF_POSITRON MAGNETIC_FIELD ANNIHILATE_THRESHOLD ...
    SCATTER_THRESHOLD V_INITIAL STEP_TIME ELECTRICITY_OF_POSITRON ...
    MASS_OF_POSITRON;

NUM_OF_POSITRON = numOfPositron;
MAGNETIC_FIELD = magneticField;
ANNIHILATE_THRESHOLD = annihilateThreshold;
SCATTER_THRESHOLD = scatterThreshold;
V_INITIAL = vInitial;
STEP_TIME = 0.001;
ELECTRICITY_OF_POSITRON = 1;
MASS_OF_POSITRON = 1;

% Create the output parameter
if isTrack
    record = cell(1);
else
    record = zeros(NUM_OF_POSITRON, 7);
end

% Launch the positrons
for ii = 1:NUM_OF_POSITRON
    p = Positron(V_INITIAL); % Specified in the class Positron
    [p, track] = trackPositron(p,isTrack);
    % Record the results
    if isTrack
        record{ii} = track; % record is a cell
    else
        record(ii,:) = [p.coord, p.dir, p.scatter]; % record is a matrix
    end
end

end

function [p_out, track] = trackPositron(p_in, recordTrack)
% trackPositron
%    Input Argument:
%    p_in - the input positron, (class Positron);
%    recordTrack - track trajectory or annihilation.
%    Output Argument:
%    p_out - the positron after propogation.

p = p_in;
terminate = 0; % termination flag
track = [p_in.coord, p_in.dir, p_in.scatter]; % Initiate using the input

while terminate == 0
    p = propagate(p); % Positron propagate
    p = scattering(p); % Positron scattering
    if recordTrack == 1
        track = [track; p.coord, p.dir, p.scatter];
    end
    terminate = isTerminate(p);
end

p_out = p;

end

function p_out = propagate(p_in)
% propagate
%    Take care of the positron propagate.
%    Input Argument:
%    p_in - the input positron, (class Positron).
%    Output Argument:
%    p_out - the positron after propogation.
%    The influence of Lorentz force on positron motion is considered in the
%    propagation of positron.

% the default direction of magnetic is parallel to the Z-axis
global MAGNETIC_FIELD ELECTRICITY_OF_POSITRON MASS_OF_POSITRON STEP_TIME; 

p = p_in;

if MAGNETIC_FIELD ~= 0
    [dir_theta, dir_phi, dir_r] = p.getDirSph();
    % the angular velocity of circular motion
    w = MAGNETIC_FIELD * ELECTRICITY_OF_POSITRON / MASS_OF_POSITRON; 
    % the radius of circular motion
    R = MASS_OF_POSITRON * dir_r * cos(dir_phi) / ...
        ELECTRICITY_OF_POSITRON / MAGNETIC_FIELD; 
    v_x = dir_r * cos(dir_phi) * cos(dir_theta - w * STEP_TIME);
    v_y = dir_r * cos(dir_phi) * sin(dir_theta - w * STEP_TIME);
    v_z = p.dir(3);
    x = R * (sin(w * STEP_TIME - dir_theta) +  sin(dir_theta)) + ...
        p.coord(1);
    y = R * (cos(w * STEP_TIME - dir_theta) - cos(dir_theta)) + ...
        p.coord(2);
    z = p.dir(3) * STEP_TIME + p.coord(3);
    p.coord = [x, y, z];
    p.dir = [v_x, v_y, v_z];
else % No magnetic field, just propagate
    for i = 1:3
        p.coord(i) = p.dir(i) * STEP_TIME + p.coord(i);
    end
end

p_out = p;

end

function p_out = scattering(p_in)
% scatter
%   Scatter the positron
%    Input Argument:
%    p_in - the input positron, (class Positron).
%    Output Argument:
%    p_out - the positron after scattering.

global SCATTER_THRESHOLD;
p = p_in;
[dir_theta, dir_phi, dir_r] = p.getDirSph();

if rand() < SCATTER_THRESHOLD
    % In this simplified model, the difference between spatial
    % uniformity and time uniformity is ignored.
    scat_ang_dev = asin(2 * rand() - 1);
    scat_ang_azim = 2 * pi * rand();
    % The Angle between the post-scatter velocity and the positive Y axis
    % in the new coordinate system.
    v_x_temp = dir_r * cos(scat_ang_dev);
    v_y_temp = dir_r * sin(scat_ang_dev) * cos(scat_ang_azim);
    v_z_temp = dir_r * sin(scat_ang_dev) * sin(scat_ang_azim);
    v_x = (- v_z_temp * sin(dir_phi) + v_x_temp * cos(dir_phi)) * ...
        cos(dir_theta) - v_y_temp * sin(dir_theta);
    v_y = (- v_z_temp * sin(dir_phi) + v_x_temp * cos(dir_phi)) * ...
        sin(dir_theta) - v_y_temp * cos(dir_theta);
    v_z = v_z_temp * cos(dir_phi) + v_x_temp * sin(dir_phi);
    p.dir = [v_x, v_y, v_z];
    p.scatter = p.scatter + 1;
end

p_out = p;

end

function terminate_flag = isTerminate(~)
% isAnnihilate
%   Determine if the positron is annihilated
% Output paramter:
% terminate_flag - 0 - not teminate, 1 - terminate

global ANNIHILATE_THRESHOLD

if rand() < ANNIHILATE_THRESHOLD
    % In this simplified model, the difference between spatial uniformity
    % and time uniformity is ignored.
    terminate_flag = 1;
else
    terminate_flag = 0;
end

end
