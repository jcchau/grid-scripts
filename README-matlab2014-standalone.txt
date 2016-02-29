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

--------------------------------------------------------------------
From Keith Ma (Research Computing Services):
2015-11-10 19:58:11 - Ma, Keith Frederick (Client Communication)
Hi Jimmy,
 
The path is: /usr/local/apps/matlab-2014b
 
However, there are a few new (and not yet documented) shortcuts using the module system that you may prefer.
 
First, all the installed versions of MATLAB can be loaded using the module system (run 'module avail matlab' to see what is available). Loading the module will activate the desired version of MATLAB, and also define an environment variable you (SCC_MATLAB_DIR) can use when running your standalone. To do it this way, you would run:
 
module load matlab/2014b
run_standalone.sh $SCC_MATLAB_DIR
 
Second, you can omit the helper script entirely by loading the MCR libraries via the module system. The module takes care of all of the environment setup. Once itis loaded, you can just run the standalone directly. For 2014b, the correct MCR is version 8.4, so you would run:
 
module load mcr/8.4
standalone
 
If you are running in batch, be sure to forward your environment to the compute node using the -V flag.
 
Best,
Keith Ma
Research Computing Services

