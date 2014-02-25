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
- ...

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

can be used to investigate such problems and test the hypotheses set out in the 
introduction 

