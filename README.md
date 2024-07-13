
# pubmedr

`pubmedr` is an R package designed to fetch and process data from the
PubMed database. The package provides functions to build search URLs,
retrieve search results, and process paper entries to extract relevant
information.

## Installation

To install the package, you can use the `devtools` package to install it
from a local directory or GitHub repository.

``` r
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# install "pubmedr" from a local directory, where you `git clone` pubmedr
devtools::install("path/to/pubmedr")

# or install directly from GitHub
devtools::install_github("danymukesha/pubmedr")
```

## Usage

Below are detailed steps on how to use the `pubmedr` package.

### Load the Package

``` r
library(pubmedr)
```

### Define a Search Instance

You need to define a search instance that contains the query parameters
for fetching data from PubMed.

``` r
search <- list(
  query = "(Alzheimer OR dementia OR cognitive impairment) AND (urine) AND (early detection OR disease monitoring OR diagnosis)",
  since = as.Date("2020-01-01"),
  until = as.Date("2021-01-01"),
  publication_types = c("journal"),
  reached_its_limit = function(label) { FALSE },
  add_paper = function(paper) { print(paper) }
)
```

### Run the Search

Use the `run` function to fetch papers from PubMed based on the defined
search parameters.

``` r
run(search)
```

    ## # A tibble: 49 × 11
    ##    title    abstract authors publication_title publication_issn publication_type
    ##    <chr>    <chr>    <chr>   <chr>             <chr>            <chr>           
    ##  1 Alterat… "An eas… Yumi W… Frontiers in neu… 1664-2295        Journal         
    ##  2 Relatio… "This s… Yong-P… BioMed research … 2314-6141        Journal         
    ##  3 Case Re… "Backgr… Abdulr… F1000Research     2046-1402        Journal         
    ##  4 Non-inv… "This r… Andrea… Clinical chemist… 1437-4331        Journal         
    ##  5 Cytomeg… "Cytome… Osric … European journal… 1872-7654        Journal         
    ##  6 Polyvas… "Cardio… Yueson… Stroke and vascu… 2059-8696        Journal         
    ##  7 Impairm… "Cognit… Yongju… Stroke and vascu… 2059-8696        Journal         
    ##  8 Inverse… "A non-… Natali… Advanced healthc… 2192-2659        Journal         
    ##  9 Urinary… "To exa… Jia-He… Neurological sci… 1590-3478        Journal         
    ## 10 Spot ur… "Iodine… Tillma… European journal… 1436-6215        Journal         
    ## # ℹ 39 more rows
    ## # ℹ 5 more variables: publication_date <dbl>, doi <chr>,
    ## #   number_of_pages <list>, pages <list>, database <chr>
