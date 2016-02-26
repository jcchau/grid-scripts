#!/bin/bash
# grid-single-node-matlab.sh: Generic script for use with qsub to start a
# parallel MATLAB job on a single node.
# Written by Jimmy C. Chau <jchau@bu.edu>

# Usage (for BU SCC):
#	qsub -N <jobname> [-pe <parallel_env> <n>] \
#		<path>/grid-single-node-matlab.sh <matlabcmd>
#
# <parallel_env> is omp for parallel MATLAB scripts on SCC.
# <n> is limited to the number of processors available on the compute node.
# If [-pe <parallel_env> <n>] is omitted then the job will only use one
# processor.
#
# Note: execute from the directory in which the MATLAB script should run.
# <matlabcmd> should be the MATLAB command to run after matlabpool.
# If <matlabcmd> is the name of a script, the .m extension should be omitted.
#
# To select a version of MATLAB, use (for example):
#	module load matlab/2015b
# (Currently, the compute node seems to inherit the  MATLAB version anyway,
# but you can use the -V flag for qsub to forward all environment variables.) 
#
# To see what versions of MATLAB are available, run:
#	module avail matlab

# Job submission directives for qsub
#$ -cwd
#$ -j y
#$ -m a

if [ -n "$NSLOTS" ]; then

	if [[ "$NSLOTS" -eq "1" ]]; then

		# Starts MATLAB for a single worker.
		# Skip running matlabpool (not necessary).
		matlab -nodisplay -nosplash -singleCompThread \
			-r "$1, exit"

	elif [[ "$NSLOTS" -gt "1" ]]; then

		# Starts MATLAB, fires up the parallel workers, and executes
		# the specified MATLAB command(s) before exiting.  
		# Note: JVM is needed for the Parallel Computing Toolbox.
		matlab -nodisplay -nosplash -r \
			"parpool('local', $NSLOTS); $1, exit"

	else
		echo "Error: NSLOTS is invalid. Please only run using qsub." \
			>&2
		exit 1
	fi

else
	echo "Error: NSLOTS not set (or empty). Please only run using qsub." \
		>&2
	exit 1
fi
