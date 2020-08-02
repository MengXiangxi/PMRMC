clear
clf

numOfPositron = 30;
magneticField = 0;
annihilateThreshold = 0.1;
scatteringThreshold = 0;
vInitial = 30;

rec = PMRMC(numOfPositron, magneticField, annihilateThreshold,...
    scatteringThreshold, vInitial, 1);

for ii = 1:length(rec)
    plot3(rec{ii}(:,1),rec{ii}(:,2),rec{ii}(:,3), 'LineWidth', 2)
    hold on
    scatter_site = scatterSort(rec{ii});
    scatter3(scatter_site(:,1), scatter_site(:,2), scatter_site(:,3), ...
        'x', 'LineWidth', 2)
    annihi_site = rec{ii}(end,:);
    scatter3(annihi_site(1), annihi_site(2), annihi_site(3), ...
        'o', 'filled')
    axis equal, 
    grid on
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