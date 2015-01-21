# Load the monthly Starbucks return data
# 
# In this first lab, you will analyze the monthly stock returns of Starbucks (ticker: SBUX).
# Let us get started by downloading the monthly return data from http://assets.datacamp.com/course/compfin/sbuxPrices.csv, and by using the read.csv (check the documentation or type ?read.table in the console to get the help file).
# In the read.csv function, you should indicate that the data in the CSV file has a header (header argument) and that strings should not be interpreted as factors (stringsAsFactors argument).

# Assign the URL to the CSV file
data_url = "http://assets.datacamp.com/course/compfin/sbuxPrices.csv"
# Load the data frame using read.csv
sbux_df = read.csv(data_url, header = TRUE, stringsAsFactors = F)
# sbux_df should be a data frame object. Data frames are rectangular data objects that typically contain
# observations in rows and variables in columns


# Get a feel for the data
# 
# Before you analyze return data, it is a good idea to have (at least) a quick look at the data. R has a number of functions that help you do that:
#         The str function compactly displays the structure of an R object. It is arguably one of the most useful R functions.
# The head and tail functions shows you the first and the last part of an R object, respectively.
# The class function shows you the class of an R object.

str(sbux_df)
head(sbux_df,1)
tail(sbux_df,1)
class(sbux_df$Date)



# Extract the price data
# 
# You can use square brackets to extract data from the sbux_df data frame like this sbux_df[rows, columns]. To specify which rows or columns to extract, you have several options:
# sbux_df[1:5, "Adj.Close"]
# sbux_df[1:5, 2]
# sbux_df$Adj.Close[1:5].
# These expressions will all extract the first five closing prices. If you do not provide anything for the rows (or columns), all rows (or columns) will be selected (e.g. sbux_df[,"Adj.Close"]). Check this yourself by typing the different options in the console!
#         Note that in the above operations, the dimension information was lost. To preserve the dimension information, add the drop=FALSE argument.

# The sbux_df data frame is already loaded in your work space
sbux_df[1:5, "Adj.Close"]
sbux_df[1:5, 2]
sbux_df$Adj.Close[1:5, drop = F]
closing_prices = sbux_df[ , "Adj.Close", drop = F]



# Find indices associated with the dates 3/1/1994 and 3/1/1995
# 
# It will often be useful to select stock data between certain dates. Advanced users are advised to look at the xts package. However, base R also provides sufficient functionality to do this.
# The which function returns the indices for which a condition is TRUE. For example: which(sbux_df$Date == "3/1/1994") returns the position of the date 3/1/1994, which indicates in this case the row number in the sbux_df data frame.

# The sbux_df data frame is already loaded in your work space

# Find indices associated with the dates 3/1/1994 and 3/1/1995
index_1 = which(sbux_df$Date == "3/1/1994")
index_2 = which(sbux_df$Date == "3/1/1995")

# Extract prices between 3/1/1994 and 3/1/1995
some_prices = sbux_df[index_1:index_2, "Adj.Close"]        


# Subset directly on dates
# 
# The way you selected the data from a specific trading day in the previous exercise was not very convenient, right?
# When you create a data frame that has the dates of the stock price as row names, you can select the price on a specific day much more easily. The sample code on the right creates a new data frame sbux_prices_df that has the trading days as row names. You can select the price on 3/1/1994 now simply with sbux_prices_df["3/1/1994", 1].

# Create a new data frame that contains the price data with the dates as the row names
sbux_prices_df = sbux_df[, "Adj.Close", drop=FALSE]
rownames(sbux_prices_df) = sbux_df$Date
head(sbux_prices_df)

# With Dates as rownames, you can subset directly on the dates.
# Find indices associated with the dates 3/1/1994 and 3/1/1995.
price_1 = sbux_prices_df["3/1/1994", 1]
price_2 = sbux_prices_df["3/1/1995", 1]
        

# Plot the price data
# 
# R has powerful graphical capabilities. On the right, the Starbucks closing prices are plotted as a function of time. This plot was generated with plot(sbux_df$Adj.Close), the basic plotting function (more info in the documentation of plot).
# However, we should be able to generate a nicer plot, right? For one thing, a line plot makes much more sense for price time series data.

# Now add all relevant arguments to the plot function below to get a nicer plot
plot(sbux_df$Adj.Close, 
     type = "l", 
     col = "blue", 
     lwd = 2, 
     ylab = "Adjusted close",
     main = "Monthly closing price of SBUX")
legend(x='topleft',legend='SBUX', lty=1, lwd=2, col='blue')


# Calculate simple returns
# 
# If you denote by Pt the stock price at the end of month t, the simple return is given by: Rt=Pt−Pt−1Pt−1, the percentage price difference.
# Your task in this exercise is to compute the simple returns for every time point n. The fact that R is vectorized makes that relatively easy. In case you would like to calculate the price difference over time, you can use sbux_prices_df[2:n,1] - sbux_prices_df[1:(n-1),1]. Think about why this indeed calculates the price difference for all time periods. The first vector contains all prices, except the price on the first day. The second vector contains all prices except the price on the last day. Given the fact that R takes the element-wise difference of these vectors, you get Pt−Pt−1 for every t.

# The sbux_df data frame is already loaded in your work space
sbux_prices_df = sbux_df[, "Adj.Close", drop=FALSE]

# Denote n the number of time periods
n = nrow(sbux_prices_df)
sbux_ret = (sbux_prices_df[2:n,1]-sbux_prices_df[1:n-1,1])/sbux_prices_df[1:n-1,1]
# Notice that sbux_ret is not a data frame object
class(sbux_ret)


# Add dates to simple return vector
# 
# The vector sbux_ret now contains the simple returns of Starbucks (well done!). It would be convenient to have the dates as names for the elements of that vector. Remember that the trading dates were in the first column of the sbux_df data frame. To set the names of a vector, you can use names(vector) = some_names.
# Remember that we are dealing with closing prices. The first return in sbux_df is thus realized on the second day, or sbux_prices_df[2,1].

# The sbux_df data frame is already loaded in your work space
sbux_prices_df = sbux_df[, "Adj.Close", drop=FALSE]

# Denote n the number of time periods:
n = nrow(sbux_prices_df)
sbux_ret = ((sbux_prices_df[2:n, 1] - sbux_prices_df[1:(n-1), 1])/sbux_prices_df[1:(n-1), 1])

# Notice that sbux_ret is not a data frame object
class(sbux_ret)

# Now add dates as names to the vector and print the first elements of sbux_ret to the console to check
names(sbux_ret) = sbux_df[2:n, 1]
head(sbux_ret)


# Compute continuously compounded 1-month returns
# 
# As you might remember from class, the relation between single-period and multi-period returns is multiplicative for single returns. That is not very convenient. The yearly return is for example the geometric average of the monthly returns.
# Therefore, in practice you will often use continuously compounded returns. These returns have an additive relationship between single and multi-period returns and are defined as rt=ln(1+Rt), with Rt the simple return and rt the continuously compounded return at moment t.
# Continuously compounded returns can be computed easily in R by realizing that rt=ln(Pt/Pt−1) and ln(Pt/Pt−1)=ln(Pt)−ln(Pt−1). In R, the log price can be easily computed through log(price). Notice how the log function in R actually computes the natural logarithm.

# The sbux_df data frame is already loaded in your work space
sbux_prices_df = sbux_df[, "Adj.Close", drop=FALSE]

# Denote n the number of time periods:
n = nrow(sbux_prices_df)
sbux_ret = ((sbux_prices_df[2:n, 1] - sbux_prices_df[1:(n-1), 1])/sbux_prices_df[1:(n-1), 1])

# Compute continuously compounded 1-month returns
sbux_ccret = log(sbux_prices_df[2:n, 1]) - log(sbux_prices_df[1:(n-1), 1]) 
# Assign names to the continuously compounded 1-month returns
names(sbux_ccret) = sbux_df[2:n,1] 
# Show sbux_ccret
head(sbux_ccret)


# Compare simple and continuously compounded returns
# 
# You would like to compare the simple and the continuously compounded returns. 
# In the next exercise, you will do that by generating two graphs. 
# In this exercise, you will just have a quick look at the data. 
# It would be nice to have the simple and continuously compounded return next 
# to each other in a matrix, with n rows and two columns. 
# You can use the cbind function to paste the two vectors that contain both types of returns next to each other in a matrix.

# The sbux_df data frame is already loaded in your work space
sbux_prices_df = sbux_df[, "Adj.Close", drop=FALSE]

# Denote n the number of time periods:
n = nrow(sbux_prices_df)
sbux_ret = ((sbux_prices_df[2:n, 1] - sbux_prices_df[1:(n-1), 1])/sbux_prices_df[1:(n-1), 1])

# Compute continuously compounded 1-month returns
sbux_ccret = log(sbux_prices_df[2:n,1]) - log(sbux_prices_df[1:(n-1),1])
names(sbux_ccret) = sbux_df[2:n,1]
head(sbux_ccret)

# Compare the simple and cc returns
head(cbind(sbux_ret, sbux_ccret))


# Graphically compare the simple and continuously compounded returns

# The simple returns (sbux_ret) and the continuously compounded returns (sbux_ccret) have been preloaded in your workspace

# Plot the returns on the same graph
plot(sbux_ret, type="l", col="blue", lwd=2, ylab="Return",
     main="Monthly Returns on SBUX")

# Add horizontal line at zero
abline(h=0)

# Add a legend
legend(x="bottomright", legend=c("Simple", "CC"), 
       lty=1, lwd=2, col=c("blue","red"))

# Add the continuously compounded returns

lines(sbux_ccret, type = "l", col="red", lwd ="2")

# Calculate growth of $1 invested in SBUX

# The simple returns (sbux_ret) and the continuously compounded returns (sbux_ccret) have been preloaded in your workspace

# Compute gross returns
sbux_gret = sbux_ret + 1
        
# Compute future values
sbux_fv = cumprod(sbux_gret)
        
# Plot the evolution of the $1 invested in SBUX as a function of time
plot(sbux_fv, type="l", col="blue", lwd=2, ylab="Dollars", 
     main="FV of $1 invested in SBUX")

