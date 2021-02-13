%% Load results

close all

% read data from .csv files
for ii = 0:0.3:1
    for jj = [0, 200, 400, 600]
        eval(['scat', num2str(ii * 10), '_mag', num2str(jj), ...
            ' = csvread(''.\result\V_INITIAL = 5, SCATTER_THRESHOLD = ',...
            num2str(ii * 10), ', MAGNETIC_FIELD = ', num2str(jj), ...
            '.csv'');']);
    end
end

% plot figure of variant SCATTER_THRESHOLD and MAGNETIC_FIELD
figure
t = tiledlayout(4, 4);
k = 0;

for ii = 0:3:10
    for jj = [0, 200, 400, 600]
        k = k + 1;
        eval(['t',num2str(k), ' = nexttile;']);
        eval(['scatter3(scat', num2str(ii), '_mag',num2str(jj), ...
            '(:,1), scat', num2str(ii), '_mag', num2str(jj), ...
            '(:,2), scat', num2str(ii), '_mag', num2str(jj), ...
            '(:,3), ''.'');']);
        axis equal; % make the scale division ​​in the X, Y and Z coordinate axises equal
        grid off;
        axis off;
        view(0,0); % fix the viewing angle
        set(gcf, 'Color', [1, 1, 1]);
    end
end

t.TileSpacing = 'none';
t.Padding = 'none';
hlink = linkprop([t1, t2],{'XLim', 'YLim', 'ZLim'});

% associate the coordinate axes of the sub-graphs so that the sub-graphs can be compared under the same coordinate scale
for l = 3:16
    eval(['addtarget(hlink, t',num2str(l),');']);
end
t1.XLim = [-0.25, 0.25];
t1.YLim = [-0.25, 0.25];
t1.ZLim = [-0.25, 0.25];

export_fig('Figures/InitialVelocity.png')
% exportgraphics(gcf, 'Tile.pdf', 'ContentType','vector')