function terminate_flag = isTerminate(p_in)
% isAnnihilate
%   Determine if the positron is annihilated
if p_in.coord(1)^2 + p_in.coord(2)^2 + p_in.coord(3)^2 >= ParamConst.SIZE^2 % Out of boundary
    terminate_flag = -1;
elseif rand() < ParamConst.ANNIHILATE_THRESHOLD
    % In this simplified model, the difference between spatial uniformity and time uniformity is ignored.
    terminate_flag = 1;
else
    terminate_flag = 0;
end
end

