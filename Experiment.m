numOfPositron = 10000;
annihilateThreshold = 0.3;
vInitial = 5;
isTrack = 0;

% Different combinations of scattering and magnetic field
for scatterThreshold = 0:0.2:1
    for magneticField = [0, 100, 300, 500, 700, 900]
        record = PMRMC(numOfPositron, magneticField, ...
            annihilateThreshold, scatterThreshold, vInitial, isTrack);
        eval(['writematrix(record, ''.\result\V_INITIAL = ', ...
            num2str(vInitial), ', SCATTER_THRESHOLD = ', ...
            num2str(scatterThreshold * 10), ', MAGNETIC_FIELD = ', ...
            num2str(magneticField),'.csv'');']);
    end
end

% Different levels of initial velocity without magnetic field
scatterThreshold = 0;
magneticField = 500;
for vInitial = 1:2:11
    record = PMRMC(numOfPositron, magneticField, ...
            annihilateThreshold, scatterThreshold, vInitial, isTrack);
    eval(['writematrix(record, ''.\result\V_INITIAL = ', ...
        num2str(vInitial), ', SCATTER_THRESHOLD = ', ...
        num2str(scatterThreshold * 10),', MAGNETIC_FIELD = ', ...
        num2str(magneticField),'.csv'');']);
end