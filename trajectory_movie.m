clear
close all

numOfPositron = 10;
annihilateThreshold = 0.1;
vInitial = 3;
isTrack = 1;
scatterThreshold = 0.1;
magneticField = 0;

tic;
record = PMRMC(numOfPositron, magneticField, ...
    annihilateThreshold, scatterThreshold, vInitial, isTrack);
dur = toc;
disp(['scatter: ' num2str(scatterThreshold) ...
      ', magnetic field: ' num2str(magneticField), ...
      ', time consumed: ' num2str(dur) ' s.'])

newplot(record);

function [] = newplot(rec)
max_steps = 0;
for ii = 1:length(rec)
    [n_rec, ~] = size(rec{ii});
    if n_rec > max_steps
        max_steps = n_rec;
    end
end

for jj = 1:max_steps
    for ii = 1:length(rec)
        [size_ii,~] = size(rec{ii});
        annihi_site = [0,0,0];
        if jj<size_ii
            plot3(rec{ii}(1:jj,1),rec{ii}(1:jj,2),rec{ii}(1:jj,3), ...
            'color', colormapping(ii), 'LineWidth', 1)
            scatter_site = scatterSort(rec{ii}(1:jj,:));
        else
            plot3(rec{ii}(:,1),rec{ii}(:,2),rec{ii}(:,3), ...
            'color',colormapping(ii), 'LineWidth', 1)
            scatter_site = scatterSort(rec{ii});
            annihi_site = rec{ii}(end,:);
        end
        hold on
        pseudo_annihi = rec{ii}(end,:);
        scatter3(scatter_site(:,1), scatter_site(:,2), scatter_site(:,3), ...
            'x','MarkerEdgeColor',colormapping(ii+2),  'SizeData', 8)
        scatter3(annihi_site(1), annihi_site(2), annihi_site(3), ...
            'o', 'filled', 'MarkerFaceColor', colormapping(ii+1), 'SizeData', 12)
        scatter3(pseudo_annihi(1), pseudo_annihi(2), pseudo_annihi(3), ...
            'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha',0.5,...
            'SizeData', 1, 'MarkerEdgeColor', colormapping(ii+1))
        axis equal, 
        grid off
        axis off
    end
    fname = sprintf('./result/movie/%s.png',num2str(jj, '%02d'));
    print(gcf, fname, '-dpng', '-r300');
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

function c = colormapping(c_num)
switch mod(c_num,6)
    case 0
        c = [0 0.4470 0.7410];
    case 1
        c = [0.8500 0.3250 0.0980];
    case 2
        c = [0.9290 0.6940 0.1250];
    case 3
        c = [0.4940 0.1840 0.5560];
    case 4
        c = [0.4660 0.6740 0.1880];
    case 5
        c = [0.6350 0.0780 0.1840];
end
end
    