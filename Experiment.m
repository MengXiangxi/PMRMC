clear

numOfPositron = 10000;
annihilateThreshold = 5;
vInitial = 5;
isTrack = 0;

% Different combinations of scattering and magnetic field
for scatterThreshold = 0:0.3:1
    for magneticField = [0, 200, 400, 600]
        record = PMRMC(numOfPositron, magneticField, ...
            annihilateThreshold, scatterThreshold, vInitial, isTrack);
        eval(['writematrix(record, ''.\result\V_INITIAL = ', ...
            num2str(vInitial), ', SCATTER_THRESHOLD = ', ...
            num2str(scatterThreshold * 10), ', MAGNETIC_FIELD = ', ...
            num2str(magneticField),'.csv'');']);
        disp(['Scatter threshold: ',...
            num2str(scatterThreshold),...
            ', Magnetic field: ',...
            num2str(magneticField), '; status: done.'])
    end
end