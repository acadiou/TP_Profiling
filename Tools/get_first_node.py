#! /usr/bin/env python
import sys,os,string

# read arguments
if len(sys.argv) < 2: 
  print "Usage :: python get_first_node.py $LIST_OF_NODES"
  sys.exit()
else:
  liste=sys.argv[1]

# liste des noeuds
hosts=[]
if liste.find('[')>0:
  tmp=liste.split('node')[1][1:-1].split(',')
  for nodes in tmp[:]:
    n=nodes.split('-')
    for i in range(int(n[0]),int(n[-1])+1): 
      if i<10:
        hosts.append("00%s"%(i))
      elif i<100:
        hosts.append("0%s"%(i))
      else:
        hosts.append("%s"%(i))
else:
  tmp=liste.split('node')[1]
  hosts.append(tmp)

# premier noeud de calcul
print 'node%s'%hosts[0]

