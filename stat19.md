# Social and geographical factors linked with bicycle incidents: a case study of West Yorkshire

## Abstract

There has been much recent interest in the factors influencing cycle safety.
Within this broad topic, international differences in accident
and mortality rates, protective equipment and bicycle training have
received particular attention. Within this reseach body there
is a growing interest in environmental factors, but few studies have
focussed on geographical factors at the local level.
This paper addresses this research gap by analysing a geo-referenced
dataset of bicycle accidents, taken from the UK's STATS19 dataset
(2005 - 2012). We investigate incidents involving cyclists
within the case study area of West Yorkshire, an area that
has a historically low cycling rate but very high ambitions
following investment to promote cycling in the area.
Descriptive statistics and statistical tests are used to identify
the characteristic features of bicycle incidents and how they
differ, on average, from other types of crashes.
Spatial statistics are used to characterise the
distribution of injuries to cyclists, allowing inferences about
the relative risks associated with various geographically distributed
features such as roundabouts, junctions, one-way streets, speed limits and cycle paths.
Temporal analysis identifies how these geographical risk factors intersect
with time of day, week and season. Overall we provide evidence to suggest
local-level geographical factors do play an important role in cycle safety
and provide suggestions of how to increase cycle safety and uptake nationwide.

# Introduction

West Yorkshire is not an area associated with cycling.
Although the cities of York and Hull have traditionally high rates of
cycling, Leeds and Bradford have historically low levels of active travel 
and heavily car orientated urban plans.
In recent years there have been efforts to ammend this situation,
and even calls for Leeds (traditionally known as the 'Motorway city')
to become a 'cycling city'. This aspiration received a boost with the
publication of 2011 census data showing that Leeds has seen cycling
grow substantially (by 0.5 percentage points), from 1.4% to 1.9% in 2011.
To put this growth in the national context,
Leeds ranks 34th out of all 324 Enlgish Local Authorities
in terms of cycling and 13th when London is excluded.
In terms of Northern cities, Leeds has seen the fourth
greatest shift to cycling, trailing only Newcastle, Manchester and Sheffield.
Unfortunately, cycling has declined in the other Local Authorities within
West Yorkshire, leading to a highly uneven spatial distribution of
cycling across the county (figure 1).

West Yorkshire is a metropolitan county containing almost 1 million inhabitants
() in an area of xx km2. It thus has a relatively high population density of xx people
per km2, unevenly distributed between the 5 Local Authorities of
Leeds, Bradford, Wakefield, Calderdale and Kirklees that make up the area.
The vast majority of the population is urban, although West Yorksire
also contains tracts of countryside in the form of the Yorkshire Dales to the North
and the
majority of Calderdale and Kirklees to the West (figure 1).

![Overview of the study area](figure/unnamed-chunk-1.png) 


- Tour de France
- Targets for 10% of trips to be by bike following City Connect (WYCA)

## Research questions
The research is based on the diverse literature on risk and cycling and guided by 
knowledge about the information contained within the STATS19 dataset.
There are many interesting research questions about risk and cycling that
STATS19 cannot help answer (e.g. how do drivers' perceptions of cyclists affect the probability
of collision? and what influence does experience have on the cyclist crashes?).
The variables about which STATS19 provides insight are quite.
A selection of some of the most relevant hypotheses to policy makers 
that can be tackled by analysis of STATS19 data are presented below, 
in rough descending order of importance and ascending order of complexity:

- Is seasonal variability of traffic accidents different for cyclists than for other road users?
- How has the spatial and temporal distribution of accidents involving cyclists changed over time?
- Is there evidence that certain geographic and infrastructure features are especially linked to high rates of cyclist accidents? 
- Is there any evidence to support the 'strength in numbers' hypothesis, that it will be
relatively safer to cycle in areas with a large number of commuters?



## Literature review: the spatial distribution of cycle accidents

# The data

The dataset for this study is the National STATS19 data on road traffic incidents.
The data reports all incidents that took place between the 1st January 2005 until the 31st
December 2012, providing 8 years of uninterrupted records.
The structure of the raw dataset is itself quite complicated, divided into three main
files: 

- Accidents0512.csv, a 178 Mb file containing 1.3 million rows of data on the key attributes of each
incident, including time and data, location (Easting and Northing is 
provided in OSGB1936 coordinates to the nearest 1 m,
but rounded to the nearest 10 m in most cases), road type and other contextual variables
such as weather.
- Casualty0512.csv, a 74 Mb file containing 1.8 million rows on the attributes of casualties from
the incidents. These include reference to the vehicle, accident and socio-demographic
information about those injured.
- Vehicles0512.csv, a 142 Mb file containing 2.5 million rows of
data about the registered vehicles involved
in the incidents. Variables include vehicle type and other vehicle attributes demographic
details of the driver.

<!--Major updates to the structure of STATS19 data were made in 1992, when the-->

The variables of particular use for this study are summarised in Table xx below.
Henceforth, variables from these key variables will be referred to in the short form
allocated to them.

In terms of geographic data, the bulk of the analysis was conducted only on
accidents that occured within the case study zone of West Yorkshire (fig. x).

# Method

Whilst the application of this research is targetted firmly towards sustainable transport
planning and evaluation, the methods fit within the field of applied geography and spatial 
analysis. As with most applied problems, 
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

## Basic statistics cycle accidents in South Yorkshire

Over the entire study period, the proportion of accidents involving cyclists was 8.1%,
below the national average of 10.4%.
These figure mask great variability in time and space.

The most startling temporal trend in the data
was the near-continuous increase in the proportion of
incidents involving cyclists in West Yorkshire (Figure x).
Between 2005 and 2012, the proportion of reports involving
cyclists increased, from 6% to just over 10% of all incidents.
This trend mirrors the
national data and may be accounted for by increased uptake of cycling compared
with stagnating or declining distance travelled by other modes.

There was clear seasonal pattern in the data, with a
predominance of bicycle incidents during the
summer months, presumably due to the increased uptake of cycling in
warm and sunny weather (ref).
Dividing the year into 4 quarters, it was found that the summer months
(from April until September) were associated with a relatively high proportion
of incidents involving cyclists (10.1% on average),
compared with the colder half of the year (6.4%).


![Map illustrating the mismatches between 2011 Local Authorities and 2001 Unitary Authorities and Districts](figure/unnamed-chunk-2.png) 


## The timing of bicycle accidents

The temporal distribution of bicycle accidents is highly correlated with that of 
road accidents overall (correlation).
However, bicycle accidents have a much 'peakier' distribution 
that all road traffic accidents, with the accident density during the afternoon
rush hour almost 50% higher for cyclists than non cyclists (fig. x).

![timing of cyclist accidents](figures/cyclist-timings.png)

# Season




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

## comments

```r
# data for lsoas from here https://www.nomisweb.co.uk/census/2011/qs701ew
# From abstract 'City Connect', a dedicated cycle path between Leeds and
# Bradford is at the forefront of this investment, and is associated with
# quantitative targets on both bicycle uptake and safety.
```


