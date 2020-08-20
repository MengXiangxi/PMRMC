clear
clf

numOfPositron = 20;
annihilateThreshold = 0.3;
vInitial = 5;
isTrack = 1;

t = tiledlayout(4, 4);
k = 0;

for scatterThreshold = 0:0.3333:1
    for magneticField = [0, 100, 500, 900]
        tic;
        record = PMRMC(numOfPositron, magneticField, ...
            annihilateThreshold, scatterThreshold, vInitial, isTrack);
        k = k + 1;
        eval(['t',num2str(k), ' = nexttile;']);
        oneplot(record)
        dur = toc;
        disp(['scatter: ' num2str(scatterThreshold) ...
              ', magnetic field: ' num2str(magneticField), ...
              ', time consumed: ' num2str(dur) ' s.'])
    end
end
t.TileSpacing = 'none';
t.Padding = 'none';
export_fig('trajectory.png')

function [] = oneplot(rec)
for ii = 1:length(rec)
    plot3(rec{ii}(:,1),rec{ii}(:,2),rec{ii}(:,3), 'LineWidth', 1)
    hold on
    scatter_site = scatterSort(rec{ii});
    scatter3(scatter_site(:,1), scatter_site(:,2), scatter_site(:,3), ...
        'x', 'SizeData', 8)
    annihi_site = rec{ii}(end,:);
    scatter3(annihi_site(1), annihi_site(2), annihi_site(3), ...
        'o', 'filled', 'SizeData', 12)
    axis equal, 
    grid off
    axis off
end
end

function scat_coord = scatterSort(record)

scatter_list = record(:,7);

if max(scatter_list) == 0
    scat_coord = [0, 0, 0];
else
    [~,ind] = unique(scatter_list, 'first');
    scat_coord = record(ind,:);
end

scat_coord(1,:) = [];

end