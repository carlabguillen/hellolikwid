#!/usr/bin/env gnuplot
# Example gnuplot script for plotting the Roofline model
#
# Author: Thomas Gruber <thomas.roehl@googlemail.com>
# Licence: GPLv3


###############################################################################
# Configure output file
###############################################################################

# Output file (PNG format)
set output 'roofline.png'

###############################################################################
# Set configuration for application
###############################################################################

# Operational intensity
op_ins = 1.32

# Performance value
app_perf = 26346

# The y-axis label
# If you want the model in GFLOP/s, make sure to adjust the y-offsets for the
# labels (application_offset and max_perf_label_offset)
perf_label = 'DP Performance [MFLOP/s]'


# Application name
application = "Testapplication"
application_offset = 2000


###############################################################################
# Set configuration for hardware system
###############################################################################

# Maximum performance
maxperf = 740729 # MFLOP/s, likwid-bench -t peakflops_avx_fma

# Performance label
max_perf_label = "AVX FMA"
max_perf_label_offset = 15000

# Maximum bandwidth
maxband = 100787 # MByte/s, likwid-bench -t load_avx

# System description
sysdef = "Intel Xeon E5-2630 v4"

###############################################################################
# Combine the information to the Roofline model
###############################################################################

# Configure basic plot options
set terminal png enhanced
set ytics font ",14"
set xtics 1 font ",14"
set xrange[0:]

# Set axis labels and title
set xlabel 'Operational Intensity' font ",  16"
set ylabel perf_label font ",  16"
set title sprintf("Roofline model for %s", sysdef) font ",  20"

# Add application dot
set object circle at first op_ins,app_perf radius char 0.5 fillcolor rgb 'red' fillstyle solid
set label 1 at op_ins+0.2,app_perf+application_offset sprintf("%s (%.2f, %.2f)", application, op_ins, app_perf)

# Configure roofline style and label
set style line 1 linetype 1 linecolor rgb 'black' lw 2
set label 2 at (maxperf/maxband)+0.3,maxperf+max_perf_label_offset sprintf("%s (%.2f)", max_perf_label, maxperf) font ",10"

# Plot the Roofline model
roof(x) = maxperf > (x * maxband) ? (x * maxband) : maxperf
plot roof(x) ls 1 notitle