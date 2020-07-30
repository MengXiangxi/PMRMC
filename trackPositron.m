function [p_out, track] = trackPositron(p_in, recordTrack)
% trackPositron
%    Input Argument:
%    p_in - the input positron, (class Positron).
%    Output Argument:
%    p_out - the positron after propogation.
p = p_in;
terminate = 0;
track = [p_in.coord, p_in.dir];

while terminate == 0
    p = propagate(p);
    p = scatter(p);
    if recordTrack == 1
        track = [track; p.coord, p.dir];
    end
    terminate = isTerminate(p);
end
p_out = p;
end