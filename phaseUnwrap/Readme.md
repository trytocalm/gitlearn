# Phase unwrapping with multiple ambiguities and experimental noise.

## Instantaneous phase

The instantaneous phase of a sinusoidal function signal can be used to track the position of a wave cycle at a given time point. Phase, measured in degrees, can be represented as a "wrapped" value (between 0 and 360<sup>o</sup>) or as a unwrapped value, whereby each multiple of 360<sup>o</sup> represents an accumulated full wave cycle - see [https://en.wikipedia.org/wiki/Instantaneous_phase][1]. Converting between wrapped and unwrapped phase is a simple process.

## The problem:

The experimental data here is the phase of a travelling wave collected using a laser interferometer at discrete points along a membrane. The phase, as a function of distance rather than time, can be used calculate the velocity of the travelling wave [2][3][4][5]

The magnitude of the raw data is between 0 and -360<sup>o</sup> and needs to be unwrapped to calculate the overall phase lag. This is analogous to unwrapping phase as a function of time, however there's an additional random 180<sup>o</sup> phase ambiguity due to the collection method and experimental noise.

In isolation both the 360 and 180<sup>o</sup> phase steps are simple to correct: 
- Jumps greater than **|180|** between adjacent points should be corrected by **|360|** in the opposite direction. 
- Jumps greater than **|90|** between adjacent points should be correct by **|180|** in the opposite direction

However, the interaction between these ambiguities, the experimental noise and an expected but unknown rate of phase roll off, means applying the correct correction becomes harder than a simple sum of its parts. While experimental noise can be assumed to be normal for each measurement point, overall uncertainty of total lag (the final value) is cumulative and restricted by the fixed ambiguities and therefore is not normal. The expected phase change with distance is within a measurable range (i.e., it’s not more than ~90 degrees per point), and is assumed to be roughly linear.

## Method

(See **stochasticUnwrap3.mlx** and .pdf for details)

- Stage 1: Unwrapping
	- Unwrap phase (|360|) correcting for estimated phase rolloff
	- "Unwrap" |180| degree ambiguity correcting for estimated phase rolloff
- Stage 2: Likely path estimation
	- Simulate experimental noise
	- Attempt to predict most likely path using mean/mode/smoothest path

## Functions

The function and script here are designed to automate the process of unwrapping clean data (with more control than MATLAB’s unwrap function) and to attempt to automatically estimate the most-likely correct phase trajectory in the presence of noise.

**stochasticUnwrap3.mlx** – Matlab live script demonstrating problem and use of unwrap3. Latter part of script attempts to simulate and then find the most likely trajectory (work in progress).

**Unwrap3.m** – does fairly standard phase unwrapping, but allows adjustment of thresholds and correction magnitudes.

[1] https://en.wikipedia.org/wiki/Instantaneous_phase

[2] http://www.sciencedirect.com/science/article/pii/S0006349513001860

[3] http://www.sciencedirect.com/science/article/pii/S0006349514030653

[4] http://scitation.aip.org/content/aip/proceeding/aipcp/10.1063/1.3658122

[5] https://core.ac.uk/download/pdf/8768490.pdf
