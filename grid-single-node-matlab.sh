#!/bin/bash
# grid-single-node-matlab.sh: Generic script for use with qsub to start a
# parallel MATLAB job on a single node.
# Written by Jimmy C. Chau <jchau@bu.edu> 2014 Oct 15

# Usage (for BU SCC):
#	qsub -N <jobname> -pe <parallel_env> <n> \
#		<path>/grid-single-node-matlab.sh <matlabcmd>
#
# <parallel_env> is omp for parallel MATLAB scripts on SCC.
# <n> is limited to <= 12.
#
# Note: execute from the directory in which the MATLAB script should run.
# matlabcmd should be the MATLAB command to run after matlabpool.
# If matlabcmd is the name of a script, the .m extension should be omitted.

# Job submission directives for qsub
#$ -cwd
#$ -m a

if [ -n "$NSLOTS" ]; then

	# Starts MATLAB, fires up the parallel workers, and executes the
	# specified MATLAB command(s) before closing the parallel workers
	# and exiting.  
	# Note: need JVM for matlabpool
	matlab -nodisplay -nosplash -r \
		"matlabpool open local $NSLOTS, $1, matlabpool close, exit"

else
	echo "Error: NSLOTS not set (or empty). Please only run using qsub." \
		>&2
	exit 1
fi