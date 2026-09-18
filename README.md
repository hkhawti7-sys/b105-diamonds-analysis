# Diamonds: does a better cut sell for a higher price?

B105 Applied Statistical Modeling - student assignment.

## What this project does

An online jewellery shop believes that customers pay more money for a better
cut. This project tests that idea with real data.

I compare two cut groups, **Ideal** and **Premium**, and I look at the price of
one carat so the comparison is fair. The test is an independent two sample
t-test (the Welch version).

## The data

The `diamonds` dataset from the **ggplot2** package in R.

- 53,940 rows, 10 columns
- One row is one diamond
- No missing values

The script loads the data straight from the package, so you do not need to
download any file:

```r
library(ggplot2)
data <- as.data.frame(diamonds)
```

## How to run it

1. Open `analysis.R` in R Studio.
2. If you do not have ggplot2, run `install.packages("ggplot2")` once.
3. Press **Source**, or run the file line by line.

No other package is needed. Everything else uses base R.

## What the script does

1. Loads the data and looks at it
2. Descriptive statistics, histogram, boxplot and correlation
3. Cleans the data (removes 20 rows with a size of 0 mm)
4. Makes the new variable `price_per_carat`
5. Keeps only the Ideal and Premium groups
6. Takes 500 diamonds from each group with systematic sampling
7. Checks the t-test assumptions (Q-Q plots, Shapiro-Wilk, var.test)
8. Uses a log transformation because the data is skewed
9. Runs the Welch t-test
10. Calculates Cohen's d and runs a Wilcoxon test as a check

## Note on the sampling

I use systematic sampling (every k-th row) and not `sample()`. The reason is
that systematic sampling gives the same 500 diamonds on every computer. So if
you run this script, you will get exactly the same numbers as in my report.

## Main result

| | Value |
|---|---|
| Test | Welch two sample t-test |
| t | -3.108 |
| df | 997.4 |
| p-value | 0.0019 |
| Cohen's d | -0.20 (small) |

Ideal cut diamonds sell for about **8.9% less** per carat than Premium cut
diamonds. This is the opposite of what the shop believed.

The most likely reason is size. The Ideal diamonds in this data are smaller
(mean 0.71 carat) than the Premium diamonds (mean 0.90 carat), and smaller
diamonds cost less per carat.

## Files

| File | What it is |
|---|---|
| `analysis.R` | All the R code |
| `report.md` | The text of the report |
| `README.md` | This file |
