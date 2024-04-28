
# Repository for R package introR

Includes several functions related to the third edition of book
“Analyzing Financial and Economic Data with R”, available in the
following formats:

- [Amazon](https://www.amazon.com/dp/TODO) - full length book
- [Online version](https://www.msperlin.com/introR/) - first seven
  chapters

## Installation

    # only in github
    devtools::install_github('msperlin/introR')

## Example of usage

### Listing available datasets

``` r
introR::data_list()
#> 
#> ── Available data files at '/tmp/Rtmpw3ChM1/temp_libpath11850e41d33f8c/introR/ex
#> ℹ CH04_another-funky-csv-file.csv
#> ℹ CH04_example-fst.fst
#> ℹ CH04_example-Rdata.RData
#> ℹ CH04_example-rds.rds
#> ℹ CH04_example-sqlite.SQLite
#> ℹ CH04_example-tsv.tsv
#> ℹ CH04_funky-csv-file.csv
#> ℹ CH04_ibovespa-Excel.xlsx
#> ℹ CH04_ibovespa.csv
#> ℹ CH04_price-and-prejudice.txt
#> ℹ CH04_SP500-Excel.xlsx
#> ℹ CH04_SP500.csv
#> ℹ CH07_FileWithLatinChar_Latin1.txt
#> ℹ CH07_FileWithLatinChar_UTF-8.txt
#> ℹ CH08_some-stocks-SP500.csv
#> ℹ CH08_wide-example-stocks.csv
#> ℹ CH10_sp500-stocks-long-by-year.csv
#> ℹ CH11_grunfeld.csv
#> ℹ CH11_SP500.csv
#> ℹ CH11_UCI-Credit-Card.csv
#> ℹ EX_B3-stocks.rds
#> ℹ EX_football-br.csv
#> ℹ EX_Ibov_PETR4.csv
#> ℹ EX_ibovespa.rds
#> ℹ EX_SP500-stocks-wide.csv
#> ℹ EX_SP500-stocks-yearly.rds
#> ℹ EX_SP500-stocks.rds
#> ℹ EX_TD-data.rds
#> ℹ EX_TweetsElonMusk.csv
#> 
#> ✔ You can get the local path of file using introR::data_path(name_of_file)
#> ✔ Example: local_path <- introR::data_path('CH04_example-tsv.tsv')
```

### Fetching data from book repository

``` r
file_name <- 'CH04_SP500.csv'
path_to_file <- introR::data_path(file_name)

df <- readr::read_csv(path_to_file)
#> Rows: 3269 Columns: 2
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> dbl  (1): price_close
#> date (1): ref_date
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
dplyr::glimpse(df)
#> Rows: 3,269
#> Columns: 2
#> $ ref_date    <date> 2010-01-04, 2010-01-05, 2010-01-06, 2010-01-07, 2010-01-0…
#> $ price_close <dbl> 1132.99, 1136.52, 1137.14, 1141.69, 1144.98, 1146.98, 1136…
```

### Copying all book files to local directory

``` r
temp_path <- fs::path_temp('introR')

flag <- introR::bookfiles_get(path_to_copy = temp_path)
#> ℹ Path '/tmp/Rtmp7BzxOE/introR' does not exists and is created.
#> ℹ Copying data files files to '/tmp/Rtmp7BzxOE/introR/data'
#> ✔    29 files copied
#> ℹ Copying book script files to '/tmp/Rtmp7BzxOE/introR/book-scripts'
#> ℹ Files available at /tmp/Rtmp7BzxOE/introR
```
