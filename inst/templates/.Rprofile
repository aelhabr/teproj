
library("base")
library("methods")
library("datasets")
library("utils")
library("grDevices")
library("graphics")
library("stats")

suppressWarnings(suppressPackageStartupMessages(library("tidyverse")))
suppressWarnings(suppressPackageStartupMessages(library("rlang")))
suppressWarnings(suppressPackageStartupMessages(library("teplot")))

paths_funcs <-
  list.files(
    path = file.path("R"),
    pattern = "func",
    recursive = FALSE,
    full.names = TRUE
  )
invisible(sapply(paths_funcs, source))
rm("paths_funcs")

config <- config::get()

path_r_profile <- "~/.Rprofile"
if(file.exists(path_r_profile)) {
  source(path_r_profile)
}
rm("path_r_profile")
