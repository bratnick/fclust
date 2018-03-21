FKM.gkb <-
function (X, k, m, vp, gam, mcn, RS, stand, startU, conv, maxit, seed)
{
if (missing(X))
stop("The data set must be given")
if (is.null(X))
stop("The data set X is empty")
n=nrow(X)
p=ncol(X)
if (is.null(rownames(X)))
rn=paste("Obj",1:n,sep=" ")
else
rn=rownames(X)
if (is.null(colnames(X)))
cn=paste("Var",1:p,sep=" ")
else
cn=colnames(X)
X=as.matrix(X)
if (any(is.na(X)))
stop("The data set X must not contain NA values")
if (!is.numeric(X)) 
stop("The data set X is not a numeric data.frame or matrix")
if ((missing(startU)) || (is.null(startU)))
{
check=1
if (missing(k))
{
k=2
cat("The default value k=2 has been set ",fill=TRUE)
}
if (!is.numeric(k)) 
{
k=2
cat("The number of clusters k is not numeric: the default value k=2 will be used ",fill=TRUE)
}
if ((k>ceiling(n/2)) || (k<2))
{
k=2
cat("The number of clusters k must be an integer in {2, 3, ..., ceiling(n/2)}: the default value k=2 will be used ",fill=TRUE)
}
if (k%%ceiling(k)>0)  
{
k=ceiling(k)
cat("The number of clusters k must be an integer in {2, 3, ..., ceiling(nrow(X)/2)}: the value ceiling(k) will be used ",fill=TRUE)
}
}
else
{
startU=as.matrix(startU)
ns=nrow(startU)
k=ncol(startU)
check=0
if (any(is.na(startU)))
{
k=2
cat("The rational start must not contain NA values: the default value k=2 and a random start will be used ",fill=TRUE)
check=1
}
if (!is.numeric(startU)) 
{
k=2
cat("The rational start is not a numeric data.frame or matrix: the default value k=2 and a random start will be used ",fill=TRUE)
check=1
}
if ((k>ceiling(n/2)) || (k<2))
{
k=2
cat("The number of clusters k must be an integer in {2, 3, ..., ceiling(n/2)}: the default value k=2 and a random start will be used ",fill=TRUE)
check=1
}
if ((ns!=n) && (check=0))
{
cat("The number of rows of startU is different from that of X: k=ncol(startU) and a random start will be used ",fill=TRUE)
check=1
}
if (any(apply(startU,1,sum)!=1))
{
startU=startU/apply(startU,1,sum)
cat("The sums of the rows of startU must be equal to 1: the rows of startU will be normalized to unit row-wise sum ",fill=TRUE)
}
}
if (missing(m))
{
m=2
}
if (!is.numeric(m)) 
{
m=2
cat("The parameter of fuzziness m is not numeric: the default value m=2 will be used ",fill=TRUE)
}
if (m<=1) 
{
m=2
cat("The parameter of fuzziness m must be >1: the default value m=2 will be used ",fill=TRUE)
}
if (missing(vp))
vp=rep(1,k)
if (!is.numeric(vp)) 
{
cat("The volume parameter vp is not numeric: the default value vp=rep(1,k) will be used ",fill=TRUE)
vp=rep(1,k)
}
if (!is.vector(vp)) 
{
cat("The volume parameter vp is not a vector: the default value vp=rep(1,k) will be used ",fill=TRUE)
vp=rep(1,k)
}
if (min(vp)<=0) 
{
cat("The volume parameter vp must be >0: the default value vp=rep(1,k) will be used ",fill=TRUE)
vp=rep(1,k)
}
if (length(vp)!=k) 
{
cat("The number of elements of vp is different from k: the default value vp=rep(1,k) will be used ",fill=TRUE)
vp=rep(1,k)
}

if (missing(gam))
gam=0
if (!is.numeric(gam)) 
{
cat("The parameter gamma is not numeric: the default value gamma=0 will be used ",fill=TRUE)
gam=0
}
if ((gam<0) || (gam>1))
{
cat("The parameter gamma must be in the interval [0,1]: the default value gamma=0 will be used ",fill=TRUE)
gam=0
} 

if (missing(mcn))
mcn=1e+15
if (!is.numeric(mcn)) 
{
cat("The parameter mcn is not numeric: the default value mcn=1e+15 will be used ",fill=TRUE)
mcn=1e+15
}
if (mcn<=0)
{
cat("The parameter mcn must be a (large) value >0: the default value mcn=1e+15 will be used ",fill=TRUE)
mcn=1e+15
} 

if (missing(RS))
{
RS=1
}
if (!is.numeric(RS)) 
{
cat("The number of starts RS is not numeric: the default value RS=1 will be used ",fill=TRUE)
RS=1
}
if (RS<1)
{
cat("The number of starts RS must be an integer >=1: the default value RS=1 will be used ",fill=TRUE)
RS=1
} 
if (RS%%ceiling(RS)>0)
{
cat("The number of starts RS  must be an integer >=1: the value ceiling(RS) will be used ",fill=TRUE)
RS=ceiling(RS)
} 
if (missing(conv))
conv=1e-9
if (!is.numeric(conv)) 
{
cat("The convergence criterion conv is not numeric: the default value conv=1e-9 will be used ",fill=TRUE)
conv=1e-9
}
if (conv<=0) 
{
cat("The convergence criterion conv must be a (small) value >0: the default value conv=1e-9 will be used ",fill=TRUE)
conv=1e-9
} 
if (missing(maxit))
maxit=1e+2
if (!is.numeric(maxit)) 
{
cat("The maximum number of iterations maxit is not numeric: the default value maxit=1e+2 will be used ",fill=TRUE)
maxit=1e+2
}
if (maxit<=0)
{
cat("The maximum number of iterations maxit must be an integer >0: the default value maxit=1e+2 will be used ",fill=TRUE)
maxit=1e+2
} 
if (maxit%%ceiling(maxit)>0)
{
cat("The maximum number of iterations maxit must be an integer >0: the value ceiling(maxit) will be used ",fill=TRUE)
maxit=ceiling(maxit)
} 
if (missing(seed))
set.seed(NULL)
else
{
if (!is.numeric(seed)) 
{
cat("The seed value is not numeric: set.seed(NULL) will be used ",fill=TRUE)
set.seed(NULL)
}else
{
if (seed%%ceiling(seed)>0)
{
cat("The seed value must be an integer: set.seed(ceiling(seed)) will be used ",fill=TRUE)
set.seed(ceiling(seed))
}else
set.seed(seed)
}
}
Xraw=X
rownames(Xraw)=rownames(X)
colnames(Xraw)=colnames(X)
if (missing(stand))
stand=0
if (!is.numeric(stand)) 
stand=0
if (stand==1)
X=scale(X,center=TRUE,scale=TRUE)[,]
value=vector(length(RS),mode="numeric")
cput=vector(length(RS), mode="numeric")
it=vector(length(RS), mode="numeric")
func.opt=10^10*sum(X^2)
F0=diag(det(var(X))^(1/p),nrow=p)
for (rs in 1:RS) 
{
if ((rs==1) & (check!=1)) 
U=startU
else
{
U=matrix(runif(n*k,0,1), nrow=n, ncol=k)
U=U/apply(U,1,sum)
}
D=matrix(0,nrow=n,ncol=k)
H=matrix(0,nrow=k,ncol=p)
F=array(0,c(p,p,k))
U.old=U+1
iter=0
cputime=system.time(
{
while ((sum(abs(U.old-U))>conv) && (iter<maxit))
{
iter=iter+1
#D.old=D
U.old=U
#H.old=H
#F.old=F
for (c in 1:k) 
H[c,]=(t(U[,c]^m)%*%X)/sum(U[,c]^m)
dd=rep(1,k)
for (c in 1:k)
{
F[,,c]=matrix(0,nrow=p,ncol=p)
for (i in 1:n)
{
F[,,c]=(U[i,c]^m)*(X[i,]-H[c,])%*%t(X[i,]-H[c,] )+F[,,c] 
}
F[,,c]=F[,,c]/sum(U[,c]^m) 
F[,,c]=(1-gam)*F[,,c]+gam*F0
if (kappa(F[,,c])>10^15)
{
er=eigen(F[,,c])
em=max(er$values)
er$values[er$values<em/mcn]=em/mcn
F[,,c]=er$vectors%*%diag(er$values,nrow=length(er$values))%*%solve(er$vectors)
}
dd[c]=det(F[,,c])
F[,,c]=F[,,c]/((dd[c])^(1/p)*vp[c])
}
for (i in 1:n) 
{
for (c in 1:k) 
{
D[i,c]=(t(X[i,]-H[c,])%*%solve(F[,,c],tol=FALSE)%*%(X[i,]-H[c,]))
}
}
#if (all(is.finite(D))==TRUE) 
#{
for (i in 1:n)
{
if (min(D[i,])==0)
{
U[i,]=rep(0,k)
U[i,which.min(D[i,])]=1
}
else
{ 
for (c in 1:k)
{
U[i,c]=((1/D[i,c])^(1/(m-1)))/sum(((1/D[i,])^(1/(m-1))))
}
}
}
#if (all(is.finite(U))==FALSE)
#U=U.old 
#}
#else
#{
#  U=U.old
#  D=D.old
#  F=F.old
#  H=H.old
# }
}
})
func=sum((U^m)*D);
cput[rs]=cputime[1]
value[rs]=func
it[rs]=iter
if (is.finite(func))
{
if (func<func.opt) 
{
U.opt=U
H.opt=H 
F.opt=F
func.opt=func
}
}
} 
rownames(H.opt)=paste("Clus",1:k,sep=" ")
colnames(H.opt)=cn
rownames(U.opt)=rn
colnames(U.opt)=rownames(H.opt)
dimnames(F.opt)[[1]]=cn
dimnames(F.opt)[[2]]=dimnames(F.opt)[[1]]
dimnames(F.opt)[[3]]=rownames(H.opt)
names(value)=paste("Start",1:RS,sep=" ")
names(cput)=names(value)
names(it)=names(value)
names(k)=c("Number of clusters")
names(m)=c("Parameter of fuzziness")
names(vp)=rownames(H.opt)
if (stand!=1)
stand=0
names(stand)=c("Standardization (1=Yes, 0=No)")
clus=cl.memb(U.opt)
out=list()
out$U=U.opt
out$H=H.opt
out$F=F.opt
out$clus=clus
out$medoid=NULL
out$value=value
out$cput=cput
out$iter=it
out$k=k
out$m=m
out$ent=NULL
out$b=NULL
out$vp=vp
out$delta=NULL
out$stand=stand
out$Xca=X
out$X=Xraw
out$call=match.call()
class(out)=c("fclust")
return(out)
}