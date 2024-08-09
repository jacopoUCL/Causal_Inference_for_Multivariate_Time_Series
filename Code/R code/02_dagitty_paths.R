library(dagitty)
g <- dagitty("dag{
zt_2 <-> xt_2 ;
zt2 <-> xt2 ;
 zt_2 -> xt_1 ;

 zt_2 -> zt_1 ;

xt->xt1;
xt1->xt2;
zt_1-> xt;
xt_1-> xt;
zt-> xt1;

zt_1-> zt;

zt_2-> xt_1;

xt_2-> xt_1;
zt_2-> zt_1;

             zt-> zt1;
             zt1-> xt2
             zt1-> zt2
           xt->xt2; xt_1->xt1; xt_2->xt
           zt->zt2; zt_1->zt1; zt_2->zt
             }")

# xt->xt2; xt_1->xt1; xt_2->xt
# zt->zt2; zt_1->zt1; zt_2->zt## lag 2 in zt
plot(graphLayout(g))
#print(dconnected(g,"xt","xt_1","xt1","zt","zt_1","zt1"))

#print( impliedConditionalIndependencies( g ,type="missing.edge") )

# i z(t-1). -> j x(t)

i<-"zt_1"
j<-"xt"

cj="xt_1"
ci="zt_2"
ei="zt"
ej="xt1"
eei="zt1"
eej="xt2"

computestats<-function(ni1,ni2,nj1,nj2, nci=list(),ncj=list()){

   if ( dseparated( g ,ni1,ni2,nci ) != dseparated( g ,nj1,nj2,ncj ))
      cat( "I(",ni1, ni2,"|", unlist(nci),") vs I(", nj1, nj2, " |", unlist(ncj),") asymmetric\n") #



   Pi=paths( g ,ni1,ni2,nci, limit = 1000)
   Pj=paths( g ,nj1,nj2,ncj,limit = 1000 )

   mini=min(unlist(lapply(Pi$paths[which(Pi$open)],stringr::str_count,"-")))
   minj=min(unlist(lapply(Pj$paths[which(Pj$open)],stringr::str_count,"-")))

   meani=mean(unlist(lapply(Pi$paths[which(Pi$open)],stringr::str_count,"-")))
   meanj=mean(unlist(lapply(Pj$paths[which(Pj$open)],stringr::str_count,"-")))

   nopeni=length(which(Pi$open==TRUE))
   nopenj=length(which(Pj$open==TRUE))
   cat( "I(",ni1, ni2,"|", unlist(nci),") vs I(", nj1, nj2, " |", unlist(ncj),")=",
        nopeni ,nopenj,":", meani,meanj,":", nopeni/meani, nopenj/meanj,"\n") #




   summary(unlist(lapply(Pi$paths[which(Pi$open)],stringr::str_count,">")))
   summary(unlist(lapply(Pj$paths[which(Pi$open)],stringr::str_count,">")))
 cat("\n -- \n")
}

computestats(ci,ej,cj,ei)

computestats(ci,ej,cj,ei,list(cj),list(ci))
computestats(ci,ej,cj,ei,list(ei),list(ej))

computestats(ei,cj,ej,ci,list(i),list(j))
computestats(ei,cj,ej,ci,list(j),list(i))
computestats(i,j,j,i,list(cj), list(ci))

computestats(ci,j,cj,i,list(ei),list(ej))

computestats(i,j,j,i,list(ej), list(ei))

computestats(i,cj,j,ci,list(), list())

computestats(ei,j,ej,i,list(), list())


computestats(ci,cj,cj,ci,list(j), list(i))
computestats(ei,ej,ej,ei,list(i), list(j))

computestats(eei,j,eej,i,list(i), list(j))
browser()

if ( dseparated( g ,ci,eej,list(j) ) != dseparated( g ,cj,eei,list(i) )) # I(eei,cj | i )
   print("I(ci,eej | j ) vs  I(cj, eei | i )")
