# B105 Applied Statistical Modeling
# Assignment: statistical analysis of the diamonds dataset
# Author: Hamza Khawti
# Business question:
# Does a diamond with an Ideal cut sell for more money per carat than
# a diamond with a Premium cut?
# How to run: open in R Studio and press Source.


# ---- 1. LOAD THE PACKAGE AND THE DATA ----

# install.packages("ggplot2")   

library(ggplot2)

data <- as.data.frame(diamonds)

head(data)
str(data)
nrow(data)     # 53940
ncol(data)     # 10


# ---- 2. DESCRIPTIVE STATISTICS ----

summary(data$price)
sd(data$price)

summary(data$carat)
sd(data$carat)

table(data$cut)

hist(data$price,
     main = "Histogram of diamond price",
     xlab = "Price in US dollars",
     col = "lightblue")

boxplot(price ~ cut,
        data = data,
        main = "Price by cut",
        xlab = "Cut",
        ylab = "Price in US dollars")

cor(data$carat, data$price)

plot(data$carat, data$price,
     main = "Carat against price",
     xlab = "Carat",
     ylab = "Price in US dollars")


# ---- 3. DATA CLEANING ----

sum(is.na(data))

# some rows have a size of 0 mm, so we remove them
nrow(data)
data <- data[data$x > 0 & data$y > 0 & data$z > 0, ]
nrow(data)

# new column: the price of one carat.
# bigger diamonds always cost more money, so we need a fair way to
# compare the two cut groups.
data$price_per_carat <- data$price / data$carat

summary(data$price_per_carat)


# ---- 4. KEEPING ONLY THE TWO GROUPS ----

two_groups <- data[data$cut == "Ideal" | data$cut == "Premium", ]
two_groups$cut <- factor(two_groups$cut, levels = c("Ideal", "Premium"))
table(two_groups$cut)


# ---- 5. SAMPLING (SYSTEMATIC SAMPLING) ----

# We take 500 diamonds from each group.
#
# We use systematic sampling 
ideal <- two_groups[two_groups$cut == "Ideal", ]
premium <- two_groups[two_groups$cut == "Premium", ]

nrow(ideal)      # 21548
nrow(premium)    # 13780

k_ideal <- floor(nrow(ideal) / 500)        # 43
k_premium <- floor(nrow(premium) / 500)    # 27

k_ideal
k_premium

rows_ideal <- seq(from = 1, by = k_ideal, length.out = 500)
rows_premium <- seq(from = 1, by = k_premium, length.out = 500)

ideal_sample <- ideal[rows_ideal, ]
premium_sample <- premium[rows_premium, ]

my_sample <- rbind(ideal_sample, premium_sample)

table(my_sample$cut)

# check that the sample looks like the full data
mean(two_groups$price_per_carat)
mean(my_sample$price_per_carat)

# statistics for each group
mean(ideal_sample$price_per_carat)
median(ideal_sample$price_per_carat)
sd(ideal_sample$price_per_carat)

mean(premium_sample$price_per_carat)
median(premium_sample$price_per_carat)
sd(premium_sample$price_per_carat)


# ---- 6. CHECK THE ASSUMPTIONS ----

# Assumption 1: each group is normal

hist(ideal_sample$price_per_carat,
     main = "Ideal cut", xlab = "Price per carat")
hist(premium_sample$price_per_carat,
     main = "Premium cut", xlab = "Price per carat")

qqnorm(ideal_sample$price_per_carat, main = "Q-Q plot, Ideal cut")
qqline(ideal_sample$price_per_carat)

qqnorm(premium_sample$price_per_carat, main = "Q-Q plot, Premium cut")
qqline(premium_sample$price_per_carat)

shapiro.test(ideal_sample$price_per_carat)
shapiro.test(premium_sample$price_per_carat)


my_sample$log_ppc <- log(my_sample$price_per_carat)

log_ideal <- my_sample$log_ppc[my_sample$cut == "Ideal"]
log_premium <- my_sample$log_ppc[my_sample$cut == "Premium"]

hist(log_ideal, main = "Ideal cut after log", xlab = "Log of price per carat")
hist(log_premium, main = "Premium cut after log", xlab = "Log of price per carat")

qqnorm(log_ideal, main = "Q-Q plot, Ideal cut after log")
qqline(log_ideal)

qqnorm(log_premium, main = "Q-Q plot, Premium cut after log")
qqline(log_premium)

shapiro.test(log_ideal)
shapiro.test(log_premium)

# Assumption 2: equal variance

var.test(log_ppc ~ cut, data = my_sample)

boxplot(log_ppc ~ cut,
        data = my_sample,
        main = "Log of price per carat by cut",
        xlab = "Cut",
        ylab = "Log of price per carat")

# Assumption 3: independence.
# Each row is a different diamond and no diamond is in both groups,

# ---- 7. APPLY THE T-TEST ----

# H0: the mean log price per carat is the same for both cuts
# H1: the mean log price per carat is different for the two cuts
# alpha = 0.05

result <- t.test(log_ppc ~ cut, data = my_sample, var.equal = FALSE)
result


# ---- 8. EFFECT SIZE (COHEN'S D) ----

# the p-value only says if there is a difference.
# Cohen's d says how big the difference is.

mean1 <- mean(log_ideal)
mean2 <- mean(log_premium)
sd1 <- sd(log_ideal)
sd2 <- sd(log_premium)
n1 <- length(log_ideal)
n2 <- length(log_premium)

pooled_sd <- sqrt(((n1 - 1) * sd1^2 + (n2 - 1) * sd2^2) / (n1 + n2 - 2))

cohens_d <- (mean1 - mean2) / pooled_sd
cohens_d


exp(mean1 - mean2)



wilcox.test(price_per_carat ~ cut, data = my_sample)


# ---- 10. WHY IS THE RESULT LIKE THIS? ----

# The two groups do not have the same average size.
# This is important for the discussion.

mean(ideal_sample$carat)
mean(premium_sample$carat)

mean(ideal_sample$price)
mean(premium_sample$price)

# bigger diamonds cost more per carat, so size explains part of
# the difference we found
cor(my_sample$carat, my_sample$price_per_carat)


