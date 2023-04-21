## Draw figures in MATLAB

#### create figure
```
  fig = figure(figNo); % create fig or switch to specific fig.
  ax = axes; % create ax or switch to specific ax.
  % use gcf, gca to get current axes
  % use clf, cla to reset current or specific fig and axes
```

Similar to Python, the adjustment of the axis can be approched in different ways. For the `ax` hierarchy, you can specify the current axes
```
  ax1 = axes('Position',[0.1 0.1 .6 .6],'Box','on');
  ax2 = axes('Position',[.35 .35 .6 .6],'Box','on');
  axes(ax1)
```
Then apply the functions, such as the `plot`. The `fig` method is similar.

When create figure, the default alignment includes

![alignment](https://ww2.mathworks.cn/help/matlab/creating_plots/axes_position_boundaries_2d.png)
