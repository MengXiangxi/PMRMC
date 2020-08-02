%% Load results

close all

% read data from .csv files
for ii = 0:0.2:1
    for jj = [0, 100, 300, 500, 700, 900]
        eval(['scat', num2str(ii * 10), '_mag', num2str(jj), ...
            ' = csvread(''.\result\V_INITIAL = 5, SCATTER_THRESHOLD = ',...
            num2str(ii * 10), ', MAGNETIC_FIELD = ', num2str(jj), ...
            '.csv'');']);
    end
end

for k = 1:2:11
    eval(['v_initial', num2str(k), ...
        ' = csvread(''.\result\V_INITIAL = ', num2str(k), ...
        ', SCATTER_THRESHOLD = 0, MAGNETIC_FIELD = 500.csv'');']);
end

%% Plot the first experiment
% plot figure of variant SCATTER_THRESHOLD and MAGNETIC_FIELD
figure
t = tiledlayout(6, 6);
k = 0;

for ii = 0:2:10
    for jj = [0, 100, 300, 500, 700 ,900]
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
for l = 3:36
    eval(['addtarget(hlink, t',num2str(l),');']);
end
t1.XLim = [-0.25, 0.25];
t1.YLim = [-0.25, 0.25];
t1.ZLim = [-0.25, 0.25];

export_fig('Figures/Scatter_MagneticField.png')

%%  Plot the second experiment
figure
p = tiledlayout(1, 6);
k = 0;

for ii = 1:2:11
    k = k + 1;
    eval(['p', num2str(k), ' = nexttile;']);
    eval(['scatter3(v_initial', num2str(ii), '(:,1), v_initial', ...
        num2str(ii), '(:,2), v_initial', num2str(ii), '(:,3), ''.'');']);
    axis equal; % make the scale division ​​in the X, Y and Z coordinate axises equal
    grid off;
    axis off;
    view(0,0); % fix the viewing angle
    set(gcf, 'Color', [1, 1, 1]);
end
p.TileSpacing = 'none';
p.Padding = 'none';
mlink = linkprop([p1, p2],{'XLim', 'YLim', 'ZLim'});

% associate the coordinate axes of the sub-graphs so that the sub-graphs can be compared under the same coordinate scale
for l = 3:6
    eval(['addtarget(mlink, p', num2str(l), ');']);
end

p1.XLim = [-0.3, 0.3];
p1.YLim = [-0.3, 0.3];
p1.ZLim = [-0.4, 0.4];

export_fig('Figures/InitialVelocity.png')