## Matplotlib

### matplotlib
The figure is consist of many components, which can be seen [here](https://matplotlib.org/stable/gallery/showcase/anatomy.html). The `figure`, `axes` should be enhanced.
![Components of a figure](https://matplotlib.org/stable/_images/sphx_glr_anatomy_001.png)

The commonly used plot style is in [3 hierarchies](https://matplotlib.org/1.5.1/faq/usage_faq.html#parts-of-a-figure) 
1. **Top**.'state-machine environment' provided by `matplotlib.pyplot` is to draw simple functions, which is similar to `MATLAB`.
2. **Middle**. object-oriented interface, in which pyplot is used only for a few functions such as figure creation, and the user explicitly creates and keeps track of the figure and axes objects. At this level, the user uses pyplot to create figures, and through those figures, one or more axes objects can be created. These axes objects are then used for most plotting actions.
3. **Bottom**. For even more control – which is essential for things like embedding matplotlib plots in `GUI` applications – the pyplot level may be dropped completely, leaving a purely object-oriented approach.

In the top, the `pyplot` is operated on the current axes, which should be specified correctly. It can achieve most commonly used functions, while helpless on the detailed modification. Thus `pyplot` is often used to create the figure, and draw axes object swiftly.

The figure includes 3 layers. ![figure](https://python-course.eu/images/numerical-programming/matplotlib_terms_400w.webp)
