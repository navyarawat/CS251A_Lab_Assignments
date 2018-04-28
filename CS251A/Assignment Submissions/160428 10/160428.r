rand_exp <- function(n,lambda) {
    x <- runif(n)       #r(andom)unif(orm)
    for (i in 1:n) {
        x[i] <- -1*log(1-x[i], base = exp(1))/lambda
        if (x[i] < 0) {
            x[i]
        }
    }
    x   #return the vector x
}

createCDF <- function(vec,heading) {
    graph <- ecdf(vec)
    plot(graph, main = heading)
}

createPDF <- function(vec,heading) {
    graph <- density(vec)
    plot(graph, main = heading)
}

x_axis <- 1:50000
X <- rand_exp(50000,0.2)
X_sorted <- sort(X)

pdf(file = '160428.pdf')
plot(x = x_axis, y = X_sorted,
   xlab = "Index",
   ylab = "Value",
   xlim = c(1,50500),
   ylim = c(0,55),
   main = "Scatter Plot"
)

partitions <- list(head(X,100))
for (i in 2:500) {
    start <- (i-1)*100 + 1
    end <- i*100
    partitions[[i]] <- X[start:end]
}

#using if block so that the code collapses in a text editor
if (TRUE) {
    #createCDF(X,'CDF main')
    #createPDF(X,'PDF main')
    createCDF(partitions[[1]],'CDF of Y1')
    createPDF(partitions[[1]],'PDF of Y1')
    createCDF(partitions[[2]],'CDF of Y2')
    createPDF(partitions[[2]],'PDF of Y2')
    createCDF(partitions[[3]],'CDF of Y3')
    createPDF(partitions[[3]],'PDF of Y3')
    createCDF(partitions[[4]],'CDF of Y4')
    createPDF(partitions[[4]],'PDF of Y4')
    createCDF(partitions[[5]],'CDF of Y5')
    createPDF(partitions[[5]],'PDF of Y5')
}

meanvals <- list(mean(partitions[[1]]))
medianvals <- list(median(partitions[[1]]))
cat(paste("  Mean",1,":",meanvals[[1]],'\n'))
cat(paste("Median",1,":",medianvals[[1]],'\n'))
cat('\n')
for (i in 2:500) {
    meanvals[[i]] <- mean(partitions[[i]])
    medianvals[[i]] <- median(partitions[[i]])
    if (i < 6) {
        cat(paste("  Mean",i,":",meanvals[[i]],'\n'))
        cat(paste("Median",i,":",medianvals[[i]],'\n'))
        if (i < 5)
            cat('\n')
    }
}

Z <- unlist(meanvals, use.names=FALSE)

tab <- table(round(Z))
plot(tab, "h", xlab="Value", ylab="Frequency", main = "Frequency graph of Mean Values")
createCDF(Z,'CDF of Mean Values')
createPDF(Z,'PDF of Mean Values')

mean <- mean(Z)
sd <- sd(Z)
cat(paste("\nMean of Z = ",mean,'\n'))
cat(paste("  SD of Z = ",sd,'\n'))

mean_orig <- mean(X)
sd_orig <- sd(X)
cat(paste("\nMean of X = ",mean_orig,'\n'))
cat(paste("  SD of X = ",sd_orig,'\n'))

cat(paste("\nDifference of Means (Z-X) = ",mean-mean_orig,"\n"))
