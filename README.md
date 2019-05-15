# Exercices pour le profiling

Ce dépôt propose quelques petits codes pour s'exercer à l'usage des outils de profiling. 

À utiliser dans l'ordre qui vous convient. 

## Tools 

Contient des utiliaires pour le profiling

- [gprof2dot.py](Tools/gprof2dot.py) utilitaire python3 pour transformer les sorties de gprof en fichier dot
- [local.sh](Tools/local.sh) exemple de script utilisant la commande ps pour sortir le temps et la mémoire utilisés par un exécutable pendant qu'il tourne

## Exercice 1

Avec les codes de [exple_matmul_C](exple_matmul_C) ou [exple_matsum_Fortran](exple_matsum_Fortran)

- Compiler les codes
- Mesurer le temps d'exécution avec 
    - time
    - /usr/bin/time -v
    - perf
- Observer l'exécution avec 
    - top 
    - htop
- Suivre l'occupation mémoire 
    - free 
    - htop 
    - vmstat
- Enregistrer l'occupation mémoire avec 
    - ps

## Exercice 2

Dans les codes de [exple_matmul_C](exple_matmul_C) ou [exple_matsum_Fortran](exple_matsum_Fortran)

- Implémenter une mesure de temps des différentes fonctions 
- Compiler avec le cas échéant, les options adaptées aux outils de profiling qui le requièrent
- Obtenir un profil plat en utilisant 
    - gprof
    - valgrind 
    - perf
- Générer un graphe d'appel

## Exercice 3

Observer les temps occupés par les processus des codes en série et parallèles, avec openmp et mpi, disponibles dans les répertoires [exple_array_Fortran](exple_array_Fortran), [exple_array_omp_Fortran](exple_array_omp_Fortran) et [exple_array_mpi_Fortran](exple_array_mpi_Fortran)

## Exercice 4

Dans le code [exple_io_bound_C](exple_io_bound_C)

- Compiler 
- Exécuter le run.sh
- Suivre l'activité des E/S avec 
    - top
    - perf

## Exercice 5

Utiliser le code dans [exple_io_cpu_Fortran](exple_io_cpu_Fortran) pour observer le temps CPU, la mémoire et le temps passé dans les E/S à l'exécution

- Compiler 
- Monitorer le code en interatif et dans slurm

## Exercice 6

Profiling d'applications parallèles : suivre les instructions du .pdf pour profiler [NPB3.4-MZ](NPB3.4-MZ/NPB3.4-MZ-MPI/BT-MZ/) avec 
    - scorep
    - scalasca

## Exercice 7 

Profiler le code hybride MPI/OpenMP de [tutoriaux de l'IDRIS](http://www.idris.fr/formations/hybride/#travaux_pratiques)

## Exercice 8

Faire le exercices du [Lawrence Livermore National Laboratory](https://hpc.llnl.gov/training/tutorials) dont les tutoriaux sont généralement bien fait pour de nombreux aspects du calcul HPC. 

Les exercices proposés pour le profiling sont ici :

[programmes du llnl](https://computing.llnl.gov/tutorials/performance_tools/exercise.html)

Utiliser les outils de profiling de votre choix


## Références

- [Tutoriel sur perf](https://twiki.cern.ch/twiki/bin/view/LHCb/CodeAnalysisTools#CPU_assisted_performance_analysi)
- [Une mine d'or sur l'analyse de performances...](http://www.brendangregg.com/)
    - [...sous Linux...](http://www.brendangregg.com/linuxperf.html)
        - [...et avec perf en particulier](http://www.brendangregg.com/perf.html)
