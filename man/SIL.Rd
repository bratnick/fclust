\name{SIL}
\alias{SIL}
\title{Silhouette index}
\description{
 Produces the silhouette index. The optimal number of cluster \emph{k} is achieved when the index value is maximized.
}
\usage{
 SIL (Xca, U, distance)
}
\arguments{
 \item{Xca}{Matrix or data.frame}
 \item{U}{Membership degree matrix}
 \item{distance}{If \code{distance=TRUE}, \code{Xca} is assumed to be a distance matrix (default: FALSE)}
}
\value{
 \item{sil.obj}{Vector containing the silhouette indices for all the objects}
 \item{sil}{Value of the silhouette index (mean of \code{sil.obj})}
}
\details{
 \code{Xca} should contain the same dataset used in the clustering algorithm, i.e., if the clustering algorithm is run using standardized data, then \code{SIL} should be computed using the same standardized data.
 \cr Set \code{distance=TRUE} if \code{Xca} is a distance matrix.
}
\references{
 Kaufman L., Rousseeuw P.J., 1990. Finding Groups in Data: An Introduction to Cluster Analysis. Wiley, New York.
}
\author{Paolo Giordani, Maria Brigida Ferraro, Alessio Serafini}
\seealso{\code{\link{PC}}, \code{\link{PE}}, \code{\link{MPC}}, \code{\link{SIL.F}}, \code{\link{XB}}, \code{\link{Fclust}}, \code{\link{Mc}}}
\examples{
## McDonald's data
data(Mc)
names(Mc)
## data normalization by dividing the nutrition facts by the Serving Size (column 1)
for (j in 2:(ncol(Mc)-1))
Mc[,j]=Mc[,j]/Mc[,1]
## removing the column Serving Size
Mc=Mc[,-1]
## fuzzy k-means
## (excluded the factor column Type (last column))
clust=FKM(Mc[,1:(ncol(Mc)-1)],k=6,m=1.5,stand=1)
## silhouette index
sil=SIL(clust$Xca,clust$U)
}
\keyword{multivariate}
