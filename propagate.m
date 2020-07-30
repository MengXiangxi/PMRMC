function p_out = propagate(p_in)
% propagate
%    Take care of the positron propagate.
%    Input Argument:
%    p_in - the input positron, (class Positron).
%    Output Argument:
%    p_out - the positron after propogation.
%    The influence of Lorentz force on positron motion is considered in the propagation of positron.
global MAGNETIC_FIELD; % the default direction of magnetic is parallel to the Z-axis
if MAGNETIC_FIELD ~= 0
    [dir_theta, dir_phi, dir_r] = p_in.getDirSph();
    w = MAGNETIC_FIELD * ParamConst.ELECTRICITY_OF_POSITRON / ParamConst.MASS_OF_POSITRON; % the angular velocity of circular motion
    R = ParamConst.MASS_OF_POSITRON * dir_r * cos(dir_phi) / ParamConst.ELECTRICITY_OF_POSITRON / MAGNETIC_FIELD; % the radius of circular motion
    v_x = dir_r * cos(dir_phi) * cos(dir_theta - w * ParamConst.STEP_TIME);
    v_y = dir_r * cos(dir_phi) * sin(dir_theta - w * ParamConst.STEP_TIME);
    v_z = p_in.dir(3);
    x = R * (sin(w * ParamConst.STEP_TIME - dir_theta) +  sin(dir_theta)) + p_in.coord(1);
    y = R * (cos(w * ParamConst.STEP_TIME - dir_theta) - cos(dir_theta)) + p_in.coord(2);
    z = p_in.dir(3) * ParamConst.STEP_TIME + p_in.coord(3);
    p_out = Positron();
    p_out.coord = [x, y, z];
    p_out.dir = [v_x, v_y, v_z];
else
    p_out = p_in;
    for i = 1:3
        p_out.coord(i) = p_in.dir(i) * ParamConst.STEP_TIME + p_in.coord(i);
    end
end
end