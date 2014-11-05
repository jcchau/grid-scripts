#!/bin/bash
# grid-single-node-matlab.sh: Generic script for use with qsub to start a
# parallel MATLAB job on a single node.
# Written by Jimmy C. Chau <jchau@bu.edu> 2014 Oct 15-Nov 05

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
# Warning: grid-single-node-matlab.sh creates and uses a MATLAB variable
# named 'cluster_gs'.  <matlabcmd> should avoid using this variable. 

# The command used to start (a specific version or installation of) MATLAB.
# >=matlab-2014a is required for the parpool command used in this script.
MATLABCMD="/usr/local/apps/matlab-2014b/bin/matlab"

# Job submission directives for qsub
#$ -cwd
#$ -j y
#$ -m a

if [ -n "$NSLOTS" ]; then

	if [[ "$NSLOTS" -eq "1" ]]; then

		# Starts MATLAB for a single worker.
		# Skip running matlabpool (not necessary).
		$MATLABCMD -nodisplay -nosplash -r "$1, exit"

	elif [[ "$NSLOTS" -gt "1" ]]; then

		# Starts MATLAB, fires up the parallel workers, and executes
		# the specified MATLAB command(s) before exiting.  
		# Note: JVM is needed for the Parallel Computing Toolbox.
		$MATLABCMD -nodisplay -nosplash -r \
			"cluster_gs = parcluster('local'); cluster_gs.NumWorkers=$NSLOTS; parpool(cluster_gs, cluster_gs.NumWorkers); $1, exit"

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
