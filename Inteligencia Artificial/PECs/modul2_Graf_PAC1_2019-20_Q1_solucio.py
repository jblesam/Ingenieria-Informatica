##############################################################################
##############################################################################
#
# Adaptació a Python d'un programa en Common-Lisp per il·lustrar
# els problemes de cerca
#
# El programa Common-Lisp original va ser escrit per Vicenç 
# Torra i Reventós com a part del Mòdul 2 dels materials de la UOC
# per a l'assignatura d'Intel·ligència Artificial
#
# Adaptació a Python per Jordi Delgado, mantenint la estructura de
# llista inherent a les llistes en Common-Lisp, de cara a minimitzar
# els canvis en l'explicació textual que acompanya el codi.
#
# Per això mantinc la notació car, cdr, caddr, etc.
#
##############################################################################
##############################################################################

##############################################################################
####                           ###############################################
####   Utilitats auxiliars     ###############################################
####                           ###############################################
##############################################################################
import sys
import random

sys.setrecursionlimit(1000000) 

# No és el mateix que el gensym de Lisp, però és més que suficient pel que necessitem
def gensym ():  
    return 'symb' + str(int(10000000*random.random())).rjust(7,'0')

def car(lst): return ([] if not lst else lst[0])

def cdr(lst): return ([] if not lst else lst[1:])

def caar(lst): return car(car(lst))

def cadr(lst): return car(cdr(lst))

def cdar(lst): return cdr(car(lst))

def cddr(lst): return cdr(cdr(lst))

def caddr(lst): return car(cdr(cdr(lst)))

def cdddr(lst): return cdr(cdr(cdr(lst)))

def caadr(lst): return car(car(cdr(lst)))

def cadadr(lst): return car(cdr(car(cdr(lst))))

def cadddr(lst):  return car(cdr(cdr(cdr(lst))))

def cons(elem, lst): 
    tmp = lst.copy()
    tmp.insert(0,elem)
    return tmp

def member_if (prd, lst):
    ll = lst.copy()
    leng = len(lst)
    while (leng > 0):
        elem = ll[0]
        if prd(elem):
            return ll
        ll.pop(0)
        leng -= 1
    return []

def find_if (prd, lst):
    for elem in lst:
        if prd(elem):
            return elem
    return []

def remove_if (prd, lst):
    results = []
    for elem in lst:
        if not prd(elem):
            results.append(elem)
    return results

def mapcar (f, lst):
    return list(map(f,lst))

##############################################################################
####                                                                      ####
####                  QUICKSORT                                           ####
####                                                                      ####
##############################################################################


def selecciona_estimacio (nodes):
    return mapcar(lambda node: caddr(cdddr(node)), nodes)

def selecciona_menorigual (pivot, per_ordenar, elems):
    if not per_ordenar:
        return []
    ll = selecciona_menorigual(pivot,cdr(per_ordenar),cdr(elems))
    if car(per_ordenar) <= pivot:
        return cons(car(elems),ll)
    return ll

def selecciona_major (pivot, per_ordenar, elems):
    if not per_ordenar:
        return []
    ll = selecciona_major(pivot,cdr(per_ordenar),cdr(elems))
    if car(per_ordenar) > pivot:
        return cons(car(elems),ll)
    return ll

def quicksort (per_ordenar, elems):
    if not elems:
        return []
    pivot  = car(per_ordenar)
    elemp  = car(elems)
    petits = selecciona_menorigual(pivot, cdr(per_ordenar), cdr(elems))
    grans  = selecciona_major(pivot, cdr(per_ordenar), cdr(elems))
    return quicksort(selecciona_estimacio(petits),petits) + cons(elemp, quicksort(selecciona_estimacio(grans),grans))

##############################################################################
##############################################################################

##############################################################################
####                           ###############################################
####    Plantejament general   ###############################################
####                           ###############################################
##############################################################################

##############################################################################
# node ::= [Identificador, Estat, Identificador-Node-Pare, Operador-generador, Altres...]
##############################################################################

def ident (node): return car(node)

def estat (node): return cadr(node)

def id_pare (node): return caddr(node)

def operador (node): return car(cdddr(node))

def info (node): return cdr(cdddr(node))

def construeix_node (ident, estat, id_pare, op, info):
    return [ident, estat, id_pare, op] + info

def expandeix_node (node, operadors, funcio):
    def elimina_estats_buits (llista_nodes):
        return remove_if(lambda node: estat(node) == 'buit', llista_nodes)
    
    st        = estat(node)
    id_node   = ident(node)
    info_node = info(node)
    
    aux       = []
    for op in operadors:
        nou_simbol = gensym()
        ff         = cadr(op)
        ffapp      = ff(st,info_node)
        aux.append(construeix_node(nou_simbol, ffapp, id_node, car(op), funcio([st, info_node], ffapp, car(op))))

    tmp = elimina_estats_buits(aux)
    return tmp

##############################################################################
# Estructura de dades arbre de cerca ::= [llista_nodes_a_expandir, llista_nodes_ja_expandits]
##############################################################################

def nodes_a_expandir (arbre):
    return car(arbre)

def nodes_expandits (arbre):
    return cadr(arbre)

def selecciona_node (arbre):
    return car(nodes_a_expandir(arbre))

def candidats (arbre):
    return bool(nodes_a_expandir(arbre))

def cami (arbre, node):
    if not id_pare(node):
        return []
    lp = cami(arbre, node_arbre(id_pare(node), arbre))
    return lp + [operador(node)]

def node_arbre (id_node, arbre):
    check_node  = lambda node: ident(node) == id_node
    a_expandir  = member_if(check_node, nodes_a_expandir(arbre))
    if bool(a_expandir):
        return car(a_expandir)
    return find_if(check_node, nodes_expandits(arbre))

def expandeix_arbre (problema, estrategia, arbre, node):
    nous_nodes_a_expandir = expandeix_node(node, operadors(problema), funcio_info_addicional(problema))
    return construeix_arbre(arbre, estrategia, node, nous_nodes_a_expandir)

def construeix_arbre (arbre, estrategia, node_expandit, nous_nodes_a_expandir):
    elm = estrategia(car(arbre), nous_nodes_a_expandir)
    return cons(elm, [cons(node_expandit, cadr(arbre))])

def elimina_seleccio (arbre):
    return cons(cdr(nodes_a_expandir(arbre)), cdr(arbre))
    
def arbre_inicial (estat, info):
    infres = info(estat)
    node   = construeix_node(gensym(), estat, [], [], [])
    tmp    = [node + infres]
    return [tmp]

##############################################################################
# problema ::= [operadors, funcio, estat-inicial, funcio-objectiu, info-inicial...]
##############################################################################

def operadors (problema): return car(problema)

def funcio_info_addicional (problema): return cadr(problema)

def estat_inicial (problema): return caddr(problema)

def funcio_objectiu (problema): return car(cdddr(problema))

def info_inicial (problema): return car(cdr(cdddr(problema)))

##############################################################################
# Implementacio de la cerca
##############################################################################

def solucio (problema, node):
    ff = funcio_objectiu(problema)
    return ff(estat(node))

def cerca (problema, estrategia, arbre):    
    if (not candidats(arbre)):
        return ['no_hi_ha_solucio']
    else:
        node      = selecciona_node(arbre)
        nou_arbre = elimina_seleccio(arbre)

        # print(mapcar(lambda node: [node[1], node[5]],  car(arbre)))
        # print(mapcar(lambda node: [node[1], node[5]],  cadr(arbre)))
        # print()
              
        if solucio(problema, node):
            return cami(arbre,node)
        else:
            tmp = expandeix_arbre(problema, estrategia, nou_arbre, node)
            return cerca(problema, estrategia, tmp)

def fer_cerca (problema, estrategia):    
    return cerca(problema, estrategia, arbre_inicial(estat_inicial(problema), info_inicial(problema)))

##############################################################################
# Estrategies
##############################################################################

def tl_estrategia_amplada (nodes_a_expandir, nous_nodes_a_expandir):
    return nodes_a_expandir + nous_nodes_a_expandir

def tl_estrategia_profunditat (nodes_a_expandir, nous_nodes_a_expandir):
    return nous_nodes_a_expandir + nodes_a_expandir 

def tl_estrategia_uniforme (nodes_a_expandir, nous_nodes_a_expandir):  ## Igual que A*
    unio = nous_nodes_a_expandir + nodes_a_expandir
    return quicksort(selecciona_estimacio(unio),unio)

def tl_estrategia_avida (nodes_a_expandir, nous_nodes_a_expandir):     ## Igual que A*
    unio = nous_nodes_a_expandir + nodes_a_expandir
    return quicksort(selecciona_estimacio(unio),unio)

def tl_estrategia_Astar (nodes_a_expandir, nous_nodes_a_expandir):
    unio = nous_nodes_a_expandir + nodes_a_expandir
    return quicksort(selecciona_estimacio(unio),unio)

##############################################################################
# Cerques
##############################################################################

def cerca_amplada (problema):
    return fer_cerca(problema, tl_estrategia_amplada)

def cerca_profunditat (problema):
    return fer_cerca(problema, tl_estrategia_profunditat)

def cerca_profunditat_limitada (problema, lim):
    global limit
    limit = lim
    return fer_cerca(problema, tl_estrategia_profunditat)

def cerca_iterativa_profunditat (problema):
    def cerca_iterativa_profunditat_desde_k (problema, lim):
        resultat = cerca_profunditat_limitada(problema, lim)
        if resultat == ['no_hi_ha_solucio']:
            return cerca_iterativa_profunditat_desde_k(problema, lim+1)
        return resultat
    
    return cerca_iterativa_profunditat_desde_k(problema,0)
    
def cerca_uniforme (problema):
    return fer_cerca(problema, tl_estrategia_uniforme)

def cerca_avida (problema):
    return fer_cerca(problema, tl_estrategia_avida)

def cerca_Astar (problema):
    return fer_cerca(problema, tl_estrategia_Astar)



##############################################################################
##############################################################################
##############################################################################
#
# Graf PAC1 2019-20 Q1
#
##############################################################################
##############################################################################
##############################################################################

def StoA (estat, info): return ('A' if estat == 'S' else 'buit')

def StoE (estat, info): return ('E' if estat == 'S' else 'buit')

def StoF (estat, info): return ('F' if estat == 'S' else 'buit')

def AtoB (estat, info): return ('B' if estat == 'A' else 'buit')

def AtoD (estat, info): return ('D' if estat == 'A' else 'buit')

def BtoC (estat, info): return ('C' if estat == 'B' else 'buit')

def CtoG (estat, info): return ('G' if estat == 'C' else 'buit')

def DtoA (estat, info): return ('A' if estat == 'D' else 'buit')

def DtoC (estat, info): return ('C' if estat == 'D' else 'buit')

def EtoD (estat, info): return ('D' if estat == 'E' else 'buit')

def FtoE (estat, info): return ('E' if estat == 'F' else 'buit')
    
def tl_operadors_graf():
    return [ ['StoA', StoA],
             ['StoE', StoE],
             ['StoF', StoF],
             ['AtoB', AtoB],
             ['AtoD', AtoD],
             ['BtoC', BtoC],
             ['CtoG', CtoG],
             ['DtoA', DtoA],
             ['DtoC', DtoC],
             ['EtoD', EtoD],
             ['FtoE', FtoE] ]

def cost (estat1, estat2):
    if   estat1 == 'S' and estat2 == 'A': return 2
    elif estat1 == 'S' and estat2 == 'E': return 3
    elif estat1 == 'S' and estat2 == 'F': return 2
    elif estat1 == 'A' and estat2 == 'B': return 2
    elif estat1 == 'A' and estat2 == 'D': return 3
    elif estat1 == 'B' and estat2 == 'C': return 2
    elif estat1 == 'C' and estat2 == 'G': return 2
    elif estat1 == 'D' and estat2 == 'A': return 3
    elif estat1 == 'D' and estat2 == 'C': return 1
    elif estat1 == 'E' and estat2 == 'D': return 1
    elif estat1 == 'F' and estat2 == 'E': return 1
    else: return 100

def heuristic (estat):
    if   estat == 'A': return 4
    elif estat == 'B': return 3
    elif estat == 'C': return 1
    elif estat == 'D': return 2 # 4 canvi!
    elif estat == 'E': return 2 # 5 canvi!
    elif estat == 'F': return 5
    elif estat == 'G': return 0
    elif estat == 'S': return 6
    else: return 100

def problema_Graf_cerca_Uniforme():
    tl_ops = tl_operadors_graf()

    def aux_func(info_node_pare, estat, operador):
        estat_pare = car(info_node_pare)
        g          = caadr(info_node_pare)
        g_mes_pare = g + cost(estat_pare, estat)
        return [g_mes_pare, g_mes_pare]
    
    estat_inicial     = 'S'
    check_estat_final = lambda estat: estat == 'G'

    return [tl_ops, aux_func, estat_inicial, check_estat_final, lambda estat: [0, 0]]

def problema_Graf_cerca_Avida():
    tl_ops = tl_operadors_graf()

    def aux_func(info_node_pare, estat, operador):
        return [0, heuristic(estat)]
    
    estat_inicial     = 'S'
    check_estat_final = lambda estat: estat == 'G'

    return [tl_ops, aux_func, estat_inicial, check_estat_final, lambda estat: [0, heuristic(estat)]]

def problema_Graf_cerca_Astar():
    tl_ops = tl_operadors_graf()

    def aux_func(info_node_pare, estat, operador):
        estat_pare = car(info_node_pare)
        g          = caadr(info_node_pare)
        g_mes_pare = g + cost(estat_pare, estat)
        g_mes_h    = g_mes_pare + heuristic(estat)
        return [g_mes_pare, g_mes_h]
    
    estat_inicial     = 'S'
    check_estat_final = lambda estat: estat == 'G'

    return [tl_ops, aux_func, estat_inicial, check_estat_final, lambda estat: [0, heuristic(estat)]]


print(cerca_uniforme(problema_Graf_cerca_Uniforme())) #==>

print(cerca_avida(problema_Graf_cerca_Avida()))  #==> 

print(cerca_Astar(problema_Graf_cerca_Astar())) #==> 

##############################################################################
##############################################################################

