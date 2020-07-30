classdef Positron
    % Positron 
    %   The Class Positron defines the properties of a simulated positron.
    %   No input variables are needed for initiation.
    
    properties
        coord = [0, 0, 0];
        dir = [0, 0, 0];
    end
    
    methods
        function obj = Positron()
            global V_INITIAL; % parameter for initial positron velocity distribution
            obj.coord = [0, 0, 0];
            dir_r = randraw('maxwell', V_INITIAL);
            dir_theta = 2 * pi * rand();
            dir_phi = asin(2 * rand() - 1);
            [obj.dir(1), obj.dir(2), obj.dir(3)] =...\
                sph2cart(dir_theta, dir_phi, dir_r);
        end

        function [dir_theta, dir_phi, dir_r] = getDirSph(obj)
            [dir_theta, dir_phi, dir_r] =...\
                cart2sph(obj.dir(1), obj.dir(2), obj.dir(3));
        end
        
        function [coord_theta, coord_phi, coord_r] = getCoordSph(obj)
            [coord_theta, coord_phi, coord_r] =...\
                cart2sph(obj.coord(1), obj.coord(2), obj.coord(3));
        end
    end
end

