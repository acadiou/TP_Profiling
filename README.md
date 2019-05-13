# Exercices pour le profiling

Ce dépôt propose quelques petits codes pour s'exercer à l'usage des outils de profiling. 

À utiliser dans l'ordre qui vous convient. 

## Tools 

Contient des utiliaires pour le profiling

- [gprof2dot.py](Tools/gprof2dot.py) utilitaire python3 pour transformer les sorties de gprof en fichier dot
- [local.sh](Tools/local.sh) script bash pour sortir le temps et la mémoire utilisés par un exécutable pendant qu'il tourne

## Exercice 1

Avec les codes de [exple_matmul_C](exple_matmul_C) ou [exple_matsum_Fortran](exple_matsul_Fortran)

- Compiler les codes
- Mesurer le temps d'exécution avec 
    - time
    - /usr/bin/time 
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

Dans les codes de [exple_matmul_C](exple_matmul_C) ou [exple_matsum_Fortran](exple_matsul_Fortran)


- Implémenter une mesure de temps des différentes fonctions 
- Compiler avec le cas échéant, les options adaptées aux outils de profiling qui le requièrent
- Obtenir un profil plat en utilisant 
    - gprof
    - valgrind 
    - perf
- Générer un graphe d'appel

## Exercice 3 

Faire le exercices du [Lawrence Livermore National Laboratory](https://hpc.llnl.gov/training/tutorials) dont les tutoriaux sont généralement bien fait pour de nombreux aspects du calcul HPC. 

Les exercices proposés pour le profiling sont ici :

[programmes du llnl](https://computing.llnl.gov/tutorials/performance_tools/exercise.html)

Uitiliser les outils de profiling de votre choix

## Exercice 4 

- Suivre les instructions du .pdf pour profiler NPB3.4-MZ/NPB3.4-MZ-MPI/BT-MZ/ avec 
    - scorep
    - scalasca

## Exercice 5

Dans le code [exple_io_bound_C](exple_io_bound_C)

- Compiler 
- Exécuter le run.sh
- Suivre l'activité des E/S avec 
    - top
    - perf


