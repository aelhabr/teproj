
# #' @seealso https://github.com/r-lib/rlang/blob/b70d83efa4e96106c915e40375eb7b4d7f5b6fa5/R/env-special.R
# .is_installed <- function(pkg) {
#   isTRUE(requireNamespace(pkg), quietly = TRUE)
# }
#
# #' @seealso https://github.com/tidyverse/dplyr/blob/d3c2365c88a041cbf9aa1bd8b1f21a15ccc31215/R/error.R
# .check_pkg <- function(name, reason, install = TRUE) {
#   if (.is_installed(name)) {
#     return(invisible(TRUE))
#   }
#   msg <- sprintf("The {%s} package is required to {%s}.", name, reason)
#   message(msg)
#   )
# }

.print_tibblefail_msg <- function(ext = NULL) {
  parent.call <- sys.call(sys.nframe() - 1L)
  message("Could not convert imported data to tibble.")
}


.import_readr_or_rio <-
  function(path = NULL, ext = ext, ...) {

    fun_readr <- sprintf("readr::read_%s", ext)
    res <- try({
      .do_call_with(fun_readr, list(file = path))
    }, silent = TRUE)

    if(inherits(res, "try-error")) {
      res <- rio::import(path, ...)
      if(!inherits(res, "try-error")) {
        .print_nonreadr_msg("rio")
      }

      res <- try(tibble::as_tibble(res), silent = TRUE)

      if(inherits(res, "try-error")) {
        .print_tibblefail_msg()
      }
    }

    invisible(res)
  }

#' Import an object
#'
#' @description Reads in data given a file, directory, and extension, or a full path directly.
#' @details This function is intended to be a direct counterpart to the similarly
#' named export function. It should be used in a NSE manner. However, this may not be what the user wants.
#' (The NSE aspect is perhaps more appropriate for exporting, where choices about file name
#' may be determined from the object name.)
#' `import_path()` may be a suitable alternative.
#'
#' Note that the user may not typically be concerned with the `import` and
#' `return` parameters. Nonetheless, these are provided in order to facilitate usage
#' with scripts run using "meta"-parameters that determine what data to import.
#'
#' Internally, a distinct method (`session::restore.session`)
#' is used for the RData-type file extension in order
#' to allow for importing of packages.
#'
#' Many supplementary functions, using the format `import_ext_*()` are provided
#' for convenience. (e.g. `import_ext_csv()` instead of `import_ext(..., ext = 'csv').`
#'
#' @inheritParams export_ext
#' @param import logical. Indicates whether to actually execute function.
#' @param ... dots. Arguments to pass dircetly to internally used import function.
#' @return object.
#' @export
#' @importFrom rio import
#' @importFrom session restore.session
#' @importFrom utils capture.output
#' @importFrom tibble as_tibble
import_ext <-
  function(file,
           dir = getwd(),
           ext,
           path = file.path(dir, paste0(file, ".", ext)),
           ...,
           import = TRUE,
           return = TRUE) {
    # browser()
    if (!import & !return) {
      .print_argfalse_msg("import")
      return(invisible())
    }

    file_try <- try(file, silent = TRUE)
    if (!inherits(file_try, "try-error") & is.character(file_try)) {
      file <- file_try
    } else {
      file <- deparse(substitute(file))
    }

    if(missing(file) & missing(ext)) {
      .print_ismiss_msg()
      return(invisible())
    }

    path <- .get_path_safely(dir, file, ext, path)

    if(!file.exists(path)) {
      .print_filenotexist_msg(path)
      return(invisible(path))
    }

    if(!import & return) {
      return(invisible(path))
    }

    if(grepl("rda", tolower(ext))) {
      # x <- ls(parent.frame())
      res <- suppressWarnings(utils::capture.output(session::restore.session(path)))
    } else {
      res <- .import_readr_or_rio(path = path, ext = ext)
    }

    invisible(res)
  }

#' Import an object
#'
#' @description Reads in data given a full path.
#' @details Works similarly to `import_ext()` internally, but may be considered simpler.
#' @inheritParams import_ext
#' @return object.
#' @export
#' @importFrom tools file_ext
import_path <-
  function(path, ..., import = TRUE, return = TRUE) {

    if (!import & !return) {
      .print_argfalse_msg("import")
      return(invisible())
    }

    if(!file.exists(path)) {
      .print_filenotexist_msg(path)
      return(invisible(path))
    }

    if(!import & return) {
      return(invisible(path))
    }

    stopifnot(!is.null(path))
    ext <- .file_ext(path)
    res <- .import_readr_or_rio(path = path, ext = ext)
    invisible(res)
  }

#' Import an object
#'
#' @description Reads in data given a full path and 'cleans' the names.
#' @details Calls `import_path()` internally.
#' @inheritParams import_ext
#' @return object.
#' @export
#' @importFrom janitor clean_names
import_path_cleanly <-
  function(path, ...) {
    res <- import_path(path = path, ...)
    if(!requireNamespace("janitor", quiet = TRUE)) {
      stop("Missing required package: `{janitor}`.")
    }
    res <- try({janitor::clean_names(res)}, silent = TRUE)
    invisible(res)
  }

#' @export
#' @rdname import_ext
import_ext_csv <- function(...) import_ext(ext = "csv", ...)

#' @export
#' @rdname import_ext
import_ext_xlsx <- function(...) import_ext(ext = "xlsx", ...)

#' @export
#' @rdname import_ext
import_ext_rdata <- function(...) import_ext(ext = "RData", ...)

#' @export
#' @rdname import_ext
import_ext_rda <- import_ext_rdata

#' @export
#' @rdname import_ext
import_ext_rds <- function(...) import_ext(ext = "rds", ...)

