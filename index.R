source(here::here('library.R'))
purrr::walk(dir(here::here('functions')), source)


api_key <- readLines("data/api_key")