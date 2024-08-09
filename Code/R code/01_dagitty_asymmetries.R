library(dagitty)
check_dependencies <- function(g,i,ci,cj,ei,ej,eei,eej) {
if ( dseparated( g ,ci,ej,list() ) != dseparated( g ,cj,ei,list() )) #  I(i, c_j | j)
   print( "I(ci, ej ) vs I(cj, ei ) ") #

if ( dseparated( g ,ci,ej,list(cj) ) != dseparated( g ,cj,ei,list(ci) )) #  I(i, c_j | j)
   print( "I(ci, ej | cj) vs I(cj, ei | ci) ") #


if ( dseparated( g ,ci,ej,list(ei) ) != dseparated( g ,cj,ei,list(ej) )) #  I(i, c_j | j)
   print( "I(ci, ej | ei) vs I(cj, ei | ej) ") #

if ( dseparated( g ,ci,j,list(ei) ) != dseparated( g ,cj,i,list(ej) )) #  I(i, c_j | j)
   print( "I(ci, j | ei) vs I(cj, i | ej) ") #


if ( dseparated( g ,i,j,list(cj) ) != dseparated( g ,j,i,list(ci) )) #  I(i, c_j | j)
   print( "I(i, j | cj) vs I(j, i | ci) ") #

if ( dseparated( g ,i,j,list(ej) ) != dseparated( g ,j,i,list(ei) )) #  I(i, c_j | j)
   print( "I(i, j | ej) vs I(j, i | ei) ") #

if (dseparated( g ,i,cj,list() ) != dseparated( g ,j,ci,list() ))
   print(" I(i, c_j ) vs I(j, c_i )" )


if (dseparated( g ,ei,j,list(i) ) != dseparated( g ,ej,i,list(j) ) )
   print(" I(ei, j | i) vs I(ej, i | j)")

if ( dseparated( g ,ci,ej,list(j) ) != dseparated( g ,cj,ei,list(i) ) )  # I(ci,ej | j )
   print(" I(ci,ej | j ) vs I(cj,ei | i )")


if ( dseparated( g ,ci,cj,list(j) ) != dseparated( g ,cj,ci,list(i) ) ) # I(ci,cj | i )
   print(" I(ci,cj | j ) vs I(ci,cj | i )")

if ( dseparated( g ,ei,ej,list(i) )!= dseparated( g ,ej,ei,list(j) )) #  I(ej, ei | j)
   print(" I(ei, ej | i) vs I(ej, ei | j)")

if ( dseparated( g ,eei,j,list(i) ) !=  dseparated( g ,eej,i,list(j) )) #  I(eej, i | j)
   print("I(eei, j | i) vs I(eej, i | j)")

if ( dseparated( g ,ci,eej,list(j) ) != dseparated( g ,cj,eei,list(i) )) # I(eei,cj | i )
   print("I(ci,eej | j ) vs  I(cj, eei | i )")

}

#Case 1: the z->x effect has lag 1  <br>
# There are only two variables involved

i<-"zt_1"
j<-"xt"
cj="xt_1"
ci="zt_2"
ei="zt"
ej="xt1"
eei="zt1"
eej="xt2"

g_with_lag_2_cause_and_effect <- dagitty("dag{
zt_2 <-> xt_2 ;
zt2 <-> xt2 ;

xt_2-> xt_1; xt_1-> xt; xt->xt1; xt1->xt2;
zt_2-> zt_1; zt_1-> zt; zt-> zt1; zt1-> zt2;

zt_2 -> xt_1 ; zt_1-> xt; zt-> xt1; zt1-> xt2;

xt_2->xt; xt_1->xt1; xt->xt2;
zt_2->zt; zt_1->zt1; zt->zt2;
}")

g_with_lag_2_cause <- dagitty("dag{
zt_2 <-> xt_2 ;
zt2 <-> xt2 ;

xt_2-> xt_1; xt_1-> xt; xt->xt1; xt1->xt2;
zt_2-> zt_1; zt_1-> zt; zt-> zt1; zt1-> zt2;

zt_2 -> xt_1 ; zt_1-> xt; zt-> xt1; zt1-> xt2;



zt_2->zt; zt_1->zt1; zt->zt2;
}")

g_with_lag_2_effect <- dagitty("dag{
zt_2 <-> xt_2 ;
zt2 <-> xt2 ;

xt_2-> xt_1; xt_1-> xt; xt->xt1; xt1->xt2;
zt_2-> zt_1; zt_1-> zt; zt-> zt1; zt1-> zt2;

zt_2 -> xt_1 ; zt_1-> xt; zt-> xt1; zt1-> xt2;



xt_2->xt; xt_1->xt1; xt->xt2;
}")

g_without_lag_2 <- dagitty("dag{
zt_2 <-> xt_2 ;
zt2 <-> xt2 ;

xt_2-> xt_1; xt_1-> xt; xt->xt1; xt1->xt2;
zt_2-> zt_1; zt_1-> zt; zt-> zt1; zt1-> zt2;

zt_2 -> xt_1 ; zt_1-> xt; zt-> xt1; zt1-> xt2;



}")

print('Lag 2 in both cause and effect')
check_dependencies(g_with_lag_2_cause_and_effect,i,ci,cj,ei,ej,eei,eej)
print('Lag 2 only for cause')
check_dependencies(g_with_lag_2_cause,i,ci,cj,ei,ej,eei,eej)
print('Lag 2 only for effect')
check_dependencies(g_with_lag_2_effect,i,ci,cj,ei,ej,eei,eej)
print('Lag 2 absent')
check_dependencies(g_without_lag_2,i,ci,cj,ei,ej,eei,eej)

#Case 2: the z->x effect has lag 2  <br>
# There are only two variables involved

i<-"zt_1"
j<-"xt1"
cj="xt"
ci="zt_2"
ei="zt"
ej="xt2"
eei="zt1"
eej="xt3"

g_with_lag_2_cause_and_effect <- dagitty("dag{
zt_3 <-> xt_3 ;
zt_2 <-> xt_2 ;
zt2 <-> xt2 ;
zt3 <-> xt3 ;

xt_3-> xt_2; xt_2-> xt_1; xt_1-> xt; xt->xt1; xt1->xt2; xt2->xt3;
zt_3-> zt_3; zt_2-> zt_1; zt_1-> zt; zt-> zt1; zt1-> zt2; zt2-> zt3;

zt_3 -> xt-1; zt_2 -> xt ; zt_1-> xt1; zt-> xt2;zt1-> xt3;

xt_3->xt-1; xt_2->xt; xt_1->xt1; xt->xt2; xt1-> xt3;
zt_3->zt-1; zt_2->zt; zt_1->zt1; zt->zt2; zt1-> zt3;
}")

g_with_lag_2_cause <- dagitty("dag{
zt_3 <-> xt_3 ;
zt_2 <-> xt_2 ;
zt2 <-> xt2 ;
zt3 <-> xt3 ;

xt_3-> xt_2; xt_2-> xt_1; xt_1-> xt; xt->xt1; xt1->xt2; xt2->xt3;
zt_3-> zt_3; zt_2-> zt_1; zt_1-> zt; zt-> zt1; zt1-> zt2; zt2-> zt3;

zt_3 -> xt-1; zt_2 -> xt ; zt_1-> xt1; zt-> xt2;zt1-> xt3;


zt_3->zt-1; zt_2->zt; zt_1->zt1; zt->zt2; zt1-> zt3;
}")

g_with_lag_2_effect <- dagitty("dag{
zt_3 <-> xt_3 ;
zt_2 <-> xt_2 ;
zt2 <-> xt2 ;
zt3 <-> xt3 ;

xt_3-> xt_2; xt_2-> xt_1; xt_1-> xt; xt->xt1; xt1->xt2; xt2->xt3;
zt_3-> zt_3; zt_2-> zt_1; zt_1-> zt; zt-> zt1; zt1-> zt2; zt2-> zt3;

zt_3 -> xt-1; zt_2 -> xt ; zt_1-> xt1; zt-> xt2;zt1-> xt3;


zt_3->zt-1; zt_2->zt; zt_1->zt1; zt->zt2; zt1-> zt3;
}")

g_without_lag_2 <- dagitty("dag{
zt_3 <-> xt_3 ;
zt_2 <-> xt_2 ;
zt2 <-> xt2 ;
zt3 <-> xt3 ;

xt_3-> xt_2; xt_2-> xt_1; xt_1-> xt; xt->xt1; xt1->xt2; xt2->xt3;
zt_3-> zt_3; zt_2-> zt_1; zt_1-> zt; zt-> zt1; zt1-> zt2; zt2-> zt3;

zt_3 -> xt-1; zt_2 -> xt ; zt_1-> xt1; zt-> xt2;zt1-> xt3;

}")

print('Lag 2 in both cause and effect')
check_dependencies(g_with_lag_2_cause_and_effect,i,ci,cj,ei,ej,eei,eej)
print('Lag 2 only for cause')
check_dependencies(g_with_lag_2_cause,i,ci,cj,ei,ej,eei,eej)
print('Lag 2 only for effect')
check_dependencies(g_with_lag_2_effect,i,ci,cj,ei,ej,eei,eej)
print('Lag 2 absent')
check_dependencies(g_without_lag_2,i,ci,cj,ei,ej,eei,eej)

# Case 3: we add a third variable <br>
# The z->x effect has lag 1  <br>
# variable y impacts cause with lag 1 <br>

i<-"zt_1"
j<-"xt"
cj="xt_1"
ci="zt_2"
ei="zt"
ej="xt1"
eei="zt1"
eej="xt2"

g_with_lag_2_cause_and_effect <- dagitty("dag{
zt_2 <-> xt_2 ;
zt2 <-> xt2 ;
yt_2 <-> zt_2 ;
yt2 <-> zt2 ;


xt_2-> xt_1; xt_1-> xt; xt->xt1; xt1->xt2;
zt_2-> zt_1; zt_1-> zt; zt-> zt1; zt1-> zt2;
yt_2-> yt_1; yt_1-> yt; yt-> yt1; yt1-> yt2;


zt_2 -> xt_1 ; zt_1-> xt; zt-> xt1; zt1-> xt2;
yt_2 -> zt_1 ; yt_1-> zt; yt-> zt1; yt1-> zt2;


xt_2->xt; xt_1->xt1; xt->xt2;
zt_2->zt; zt_1->zt1; zt->zt2;
}")

g_with_lag_2_cause <- dagitty("dag{
zt_2 <-> xt_2 ;
zt2 <-> xt2 ;
yt_2 <-> zt_2 ;
yt2 <-> zt2 ;

xt_2-> xt_1; xt_1-> xt; xt->xt1; xt1->xt2;
zt_2-> zt_1; zt_1-> zt; zt-> zt1; zt1-> zt2;
yt_2-> yt_1; yt_1-> yt; yt-> yt1; yt1-> yt2;


zt_2 -> xt_1 ; zt_1-> xt; zt-> xt1; zt1-> xt2;
yt_2 -> zt_1 ; yt_1-> zt; yt-> zt1; yt1-> zt2;


zt_2->zt; zt_1->zt1; zt->zt2;
}")

g_with_lag_2_effect <- dagitty("dag{
zt_2 <-> xt_2 ;
zt2 <-> xt2 ;
yt_2 <-> zt_2 ;
yt2 <-> zt2 ;

xt_2-> xt_1; xt_1-> xt; xt->xt1; xt1->xt2;
zt_2-> zt_1; zt_1-> zt; zt-> zt1; zt1-> zt2;
yt_2-> yt_1; yt_1-> yt; yt-> yt1; yt1-> yt2;


zt_2 -> xt_1 ; zt_1-> xt; zt-> xt1; zt1-> xt2;
yt_2 -> zt_1 ; yt_1-> zt; yt-> zt1; yt1-> zt2;


xt_2->xt; xt_1->xt1; xt->xt2;
}")

g_without_lag_2 <- dagitty("dag{
zt_2 <-> xt_2 ;
zt2 <-> xt2 ;
yt_2 <-> zt_2 ;
yt2 <-> zt2 ;

xt_2-> xt_1; xt_1-> xt; xt->xt1; xt1->xt2;
zt_2-> zt_1; zt_1-> zt; zt-> zt1; zt1-> zt2;
yt_2-> yt_1; yt_1-> yt; yt-> yt1; yt1-> yt2;


zt_2 -> xt_1 ; zt_1-> xt; zt-> xt1; zt1-> xt2;
yt_2 -> zt_1 ; yt_1-> zt; yt-> zt1; yt1-> zt2;


}")

print('Lag 2 in both cause and effect')
check_dependencies(g_with_lag_2_cause_and_effect,i,ci,cj,ei,ej,eei,eej)
print('Lag 2 only for cause')
check_dependencies(g_with_lag_2_cause,i,ci,cj,ei,ej,eei,eej)
print('Lag 2 only for effect')
check_dependencies(g_with_lag_2_effect,i,ci,cj,ei,ej,eei,eej)
print('Lag 2 absent')
check_dependencies(g_without_lag_2,i,ci,cj,ei,ej,eei,eej)
 
# [6:01 PM] BONTEMPI Gianluca
# nel grafo vado da t-2 a t+2: potresti aggiungere qualche istante prima e dopo per essere sicuro

# Puoi aggiungere un lag 2 a x(t) o a z(t) e vedere che 2 asimmetrie su 3 restano: se sono tutti e due con lag 2, le asimmetrie scompaiono

# Potrebbe essere la base per fare 4 esempi: 1 facile (4 asimmetrie), 2 medi (3 asimmetrie) e 1 complicato (asimmetrie scompaiono)
