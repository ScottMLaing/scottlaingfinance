install.packages("tidyquant")
install.packages("tidyverse")

library(tidyverse)
library(tidyquant)

stock_returns_monthly <- c("AAPL", "TSLA", "MSFT") %>%
  tq_get(get = "stock.prices",
         from = "2023-01-01",
         to = "2023-09-01") %>%
  group_by(symbol) %>%
  tq_transmute(select = adjusted,
               mutate_fun = periodReturn,
               period = "monthly",
               col_rename = "Ra")

baseline_returns_monthly <- "XLK" %>%
  tq_get(get = "stock.prices",
         from = "2023-01-01", 
         to = "2023-09-01") %>%
  tq_transmute(select = adjusted,
               mutate_fun = periodReturn,
               period = "monthly",
               col_rename = "Rb")

stock_returns_monthly_multi <- stock_returns_monthly %>%
  tq_repeat_df(n=3)

weights <- c("AAPL", "TSLA", "MSFT") 

weights_table <- tibble(stocks) %>%
  tq_repeat_df(n=3) %>%
  bind_cols(tibble(weights)) %>%
  group_by(portfolio) 

weights_table

portfolio_returns_monthly_multi <- stock_returns_monthly_multi %>%
  tq_portfolio(assets_col = symbol,
               returns_col = Ra,
               weights = weights_table, 
               col_rename = "Ra")