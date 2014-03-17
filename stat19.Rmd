# An analysis of STATS19 data

# Research questions
These questions are inspired by the diverse literature on risk and cycling and guided by 
knowledge about the STATS19 dataset in terms of the types of research question it can 
and cannot answer. There are many interesting research questions about risk and cycling that
STATS19 cannot help answer (e.g. how do drivers' perceptions of cyclists affect the probability
of collision? and what influence does experience have on the cyclist crashes?) because 
the variables about which it provides information are quite focussed. However, 
there are many research questions that *can* be investigated by STATS19 data that
are important and remain under-researched using quantitative methods. 
A selection of some of the most relevant hypotheses to policy makers 
that can be tackled by analysis of STATS19 data are presented below, 
in rough descending order of importance and ascending order of complexity:

- Is seasonal variability of traffic accidents different for cyclists than for other road users?
- How has the spatial and temporal distribution of accidents involving cyclists changed over time?
- Is there evidence that certain geographic and infrastructure features are especially linked to high rates of cyclist accidents? 

# Literature review: previous work on the spatial distribution of cycle accidents

# The data

Major updates to the structure of STATS19 data were made in 1992, when the 

# Method

Whilst the application of this research is targetted firmly towards sustainable transport
planning and evaluation, the methods fit within the field of applied geography and spatial 
analysis, making the paper inter-disciplinary. As with most applied problems, 
the method here is firmly routed in the input data, which is spatio-temporal data
with a range of associated nominal and ordinal characteristics linked to the circumstances
of the incident and the entities involved. Thus the main tools for analysis, beyond 
standard tools for statistical analysis of the non spatial data (in the case of 
comparing accidents involving cyclists with those not involving cyclists...), are 
thus taken from the field of *spatial point pattern analysis*. 

This field has applications in many fields, notably ecology and spatial epidemiology, 
which involves "comparing the spatial distribution of the cases [of disease] to the 
locations of a set of controls taken at random from the population" (Bivand et al. 2013, p. 173)."
The analogy to cycling is clear: is the spatial distribution of cycling accidents 
(equivalent to cases)
related to certain features on the road network (e.g. roundabouts, junctions),
or is the distribution randomly allocated to the road network?

A range of statistical techniques falling under the umbrella term *geostatistics*
\citep{diggle2007model}
can be used to investigate such problems and test hypotheses, such as those set out in the 
introduction. The geostatistical methods used in this paper are all implemented in the free
and open source statistical programming environment R, to allow the findings to be verified 
and reproducible by others. The provision of code used for the analysis should also 
allow others to build on the methods presented here for better understanding the 
spatial distribution of road traffic accidents and related phenomena. As mentioned in 
the introduction ... the STATS19 dataset has been made available to the public by the 
UK government in the hope that it will help raise awareness of accident hotspots for the greater good. 
In the same spirit, it is hoped that 
the provision of reproducible code in this project will also act in the public interest, by making
importing, analysing and interpreting the datasets more accessible.

The spatial statistical techniques used to analyse the data (further described and implemented in 
Section ...) are as follows:

- The *G Function* is a description of the average distances between points and their nearest 
neighbours. It is a cumulative function of distance, displaying the proportion of points that
have a nearest neighbour within *r* (short for radius) units of distance from itself. 
It is a relatively simple and commonly used
technique for point pattern analysis and is defined mathematically follows (Bivand et al. 2013):
$$ G(r) = \frac{ \# \{d_i : d_i \leq r, \forall i \} }{n} $$
*G(r)* is the value for any particular distance, *#* means 'count', 
$d_i$ refers to the minimum distanc to the nearest neighbour for each point, $i$ and 
$\forall$ means 'for all points'. By dividing by the total number of points, the 
G function always starts at 0 (unless there are overlapping points) and ends at 1 as $r$
increases from the minimum to the maximum distances between points. As we shall see in 
the results section, the resulting graphic can provide much insight into the spatial clustering 
of points.

# Results

## Basic statistics cycle accidents in the UK

Over the entire study period, the proportion of accidents involving bicycles rose from xx % in 

## The timing of bicycle accidents

The temporal distribution of bicycle accidents is highly correlated with that of 
road accidents overall (correlation)

# Season

In terms of time of day, bicycle accidents have a 'peakier' distribution 
that all road traffic accidents, with the accident density during the afternoon
rush hour almost 50% higher for cyclists than non cyclists (fig. x).

![timing of cyclist accidents](figures/cyclist-timings.png)


## Spatial statistics

![gfun1](figures/gfun1.png)

## Point-line analysis

## Aspatial characteristics of cycle accidents (vs other roads accs)

## Spatial relationships

# Discussion and conclusions


# References

Buehler, R. (2012). Determinants of bicycle commuting in the Washington, DC region: The role of bicycle parking, cyclist showers, and free car parking at work. Transportation Research Part D: Transport and Environment, 17(7), 525–531.

Parkin, J., Wardman, M., & Page, M. (2008). Estimation of the determinants of bicycle mode share for the journey to work using census data. Transportation, 35(1), 93–109. doi:10.1007/s11116-007-9137-5

Vandenbulcke, G., Thomas, I., de Geus, B., Degraeuwe, B., Torfs, R., Meeusen, R., & Int Panis, L. (2009). Mapping bicycle use and the risk of accidents for commuters who cycle to work in Belgium. Transport Policy, 16(2), 77–87. doi:10.1016/j.tranpol.2009.03.004
