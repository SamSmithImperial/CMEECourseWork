a <- 4
a

a*4

a_squared <- a*a
a_squared

sqrt(a_squared)

v <- c(0,1,2,3,4)
v

is.vector(v)
mean(v)

var(v)

median(v)

sum(v)

prod(v+1)

length(v)

wing.width.cm <- 1.2
wing.length.cm <- c(4.7, 5.2, 4.8)

x <- (1 + (2*3))

li = list(c(1,2,3))
class(li)

v <- TRUE
v

class(v)

v <- 3.2
class(v)

v <- 2L
class(v)

v <- "A string"
class(v)

b <- NA 
class(b)

is.na(b)

b <- 0/0
b

is.nan(b)

b <- 5/0
b

is.nan(b)

is.infinite(b)

is.finite(b)

is.finite(0/0)

as.integer(3.1)
as.numeric(4)
as.roman(155)
as.character(155)
as.logical(5)

as.logical(0)

1E4
1e4
5e-2
1e4^2
1/93/1e8

a <- 5
is.vector(a)

v1 <- c(0.02,0.5,1)
v2 <- c("a", "bc", "def", "ghij")
v3 <- c(TRUE, TRUE, FALSE)

v1;v2;v3

v1 <- c(0.02, TRUE, 1)
v1

v1 <- c(0.02, "Mary", 1)
v1

v2 <- character(3)
v2

v3 <- numeric(3)
v3

mat1 <- matrix(1:25,5,5)
mat1
print(mat1)

mat1 <- matrix(1:25, 5, 5, byrow=TRUE)
mat1

dim(mat1)
arr1 <- array(1:50, c(5, 5, 2))
arr1[,,1]
print(arr1)
arr1[,,2]

mat1[1,1] <- "one"
mat1

MyList <- list(1L, "p", FALSE, .001)
MyList

MyList <- list(species=c("Quercus robur","Fraxinus excelsior"), age=c(123,84))
MyList

MyList[[1]]

MyList[[1]][1]

MyList$species

MyList[["species"]]
MyList$species[1]

pop1 <- list(species='Cancer magister',
             latitude=48.3,
             longitude=-123.1,
             startyr=1980,
             endyr=1985,
             pop=c(303,402,101,607,802,35))

pop1

pop1<-list(lat=19,long=57,
           pop=c(100,101,99))
pop2<-list(lat=56,long=-120,
           pop=c(1,4,7,7,2,1,2))
pop3<-list(lat=32,long=-10,
           pop=c(12,11,2,1,14))
pops<-list(sp1=pop1,sp2=pop2,sp3=pop3)
pops

pops$sp1
pops$sp1["pop"]
pops[[2]]$lat

pops[[3]]$pop[3]<- 102
pops

Col1 <- 1:10
Col1

Col2 <- LETTERS[1:10]
Col2

Col3 <- runif(10)
Col3

MyDF <- data.frame(Col1,Col2,Col3)

print(MyDF)

names(MyDF) <- c("MyFirstColumn", "My Second Column", "My.Third.Column")
MyDF

MyDF$MyFirstColumn

MyMat = matrix(1:8, 4, 4)
MyMat

MyDF = as.data.frame(MyMat)
MyDF

years <- 1990:2009
years
years <- 2009:1990
seq(1,10,0.5)

MyVar <- c('a', 'b', 'c', 'd','e')
MyVar[1]

MyVar[4]

MyVar[c(3,2,1)]
MyVar[c(1,1,5,5)]

v <- c(0, 1, 2, 3, 4)
v[3]

v[1:3]

v[-3]

v[c(1, 4)]

mat1 <- matrix(1:25, 5, 5, byrow = TRUE)
mat1

mat1[1,2]
mat1[1,2:4]
mat1[1:2,2:4]

mat1[1,]
mat1[,1]

v <- c(0, 1, 2, 3, 4)
v2 <- v*2
v2

t(v)

v %*% t(v)

v3 <- 1:7
v3

v4 <- c(v2, v3)
v4

species.name <- "Quercus robur"
species.name

paste("Quercus", "robur")

paste("Quercus", "robur", sep = "")

paste("Quercus","robur", sep = ", ")

paste('Year is:', 1990:2000)

set.seed(1234567)
rnorm(10)

MyData <- read.csv("data/trees.csv")
ls(pattern = "My*")

class(MyData)

head(MyData)

str(MyData)

MyData <- read.csv("data/trees.csv", header = F) # Import ignoring headers

head(MyData)

write.csv(MyData, "results/MyData.csv")






