from functools import reduce
from random import randrange
from itertools import repeat

def deuclidea(x, y):
   return sum(map(lambda a, b: (float(a) - float(b)) ** 2, x, y)) ** 0.5
 
def nextCentr(l):
   if (l == []):
      return None
   else:
      if len(l)==1:
         return l[0][2]
      else:
         tot2 = list(zip(*[x[2] for x in l]))
         num = len(tot2[0])
         return list(map(lambda l: reduce(lambda a, b:
                                       float(a) + float(b), l)
                      / num, list(tot2)))
   
def kmeans(conj, k, maxit):
   centr = [conj[randrange(len(conj))] for i in range(k)]
   anteriores = None
   for it in range(maxit):
      cercanos = [min(zip(*[list(map(deuclidea,
                                     repeat(ej, k),
                                     centr)), range(k)]))[1]
                  for ej in conj]
      centr2 = [nextCentr(list(filter(
         lambda x: x[0] == x[1],
         zip(*[list(repeat(c, len(conj))),
               cercanos, conj]))))
                for c in range(k)]
      if None in centr2: break
      if cercanos == anteriores: break
      anteriores = cercanos

   return list(filter(lambda x: x!=None, centr2))


