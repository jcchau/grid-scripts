To compile MATLAB functions for MATLAB 2014b:
1. Run MATLAB 2014b: /usr/local/apps/matlab-2014b/bin/matlab -nodisplay.
	(Use option -nodisplay on text terminals to skip trying to start a
	GUI.)
2. In MATLAB, for function myFunc:
	mcc -mv -R -nodisplay myFunc.m

	Again, "-R -nodisplay" tells the compiled program to skip starting
	a GUI.
	-m tells mcc to generate a "C stand-alone application".
	-v for verbosity.

	On the SCC, this generates a script run_myFunc.sh in addition to
	the compiled program (myFunc).

To run the compiled MATLAB function:
In the regular shell:
	./run_myFunc /usr/local/apps/matlab-2014b/matlab args

	/usr/local/apps/matlab-2014b/matlab is <deployedMCRroot>.
	args is passed to the function.

To run on the cluster:
	qsub [-N <jobname>] -pe omp <n> [-l mem_total=<mem>] \
	./run_myFunc.sh /usr/local/apps/matlab-2014b/matlab args

	May also want to add the following options:
	-cwd	# current working directory
	-j y	# merge error and output stream files
	-m a	# email on abort

	Can omit "-pe omp <n>" if myFunc is single-worker.
