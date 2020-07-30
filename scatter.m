function p_out = scatter(p_in)
% scatter
%   Scatter the positron
global SCATTER_THRESHOLD;
[dir_theta, dir_phi, dir_r] = p_in.getDirSph();
if rand() < SCATTER_THRESHOLD
    % In this simplified model, the difference between spatial uniformity and time uniformity is ignored.
    scat_ang_dev = asin(2 * rand() - 1);
    scat_ang_azim = 2 * pi * rand();
    % The Angle between the post-scatter velocity and the positive Y axis in the new coordinate system.
    v_x_temp = dir_r * cos(scat_ang_dev);
    v_y_temp = dir_r * sin(scat_ang_dev) * cos(scat_ang_azim);
    v_z_temp = dir_r * sin(scat_ang_dev) * sin(scat_ang_azim);
    v_x = (- v_z_temp * sin(dir_phi) + v_x_temp * cos(dir_phi)) * cos(dir_theta) - v_y_temp * sin(dir_theta);
    v_y = (- v_z_temp * sin(dir_phi) + v_x_temp * cos(dir_phi)) * sin(dir_theta) - v_y_temp * cos(dir_theta);
    v_z = v_z_temp * cos(dir_phi) + v_x_temp * sin(dir_phi);
    p_out = p_in;
    p_out.dir = [v_x, v_y, v_z];
else
    p_out = p_in;
end
end

