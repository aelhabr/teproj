% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/templates.R
\name{word_document_te}
\alias{word_document_te}
\alias{word_document_rstudio}
\title{Custom Word document template}
\usage{
word_document_te(
  toc = FALSE,
  toc_depth = 3,
  fig_width = 5,
  fig_height = 4,
  fig_caption = TRUE,
  df_print = "default",
  smart = TRUE,
  highlight = "default",
  reference_docx = system.file("templates", "te", "template-te.docx", package =
    "teproj"),
  keep_md = FALSE,
  md_extensions = NULL,
  pandoc_args = NULL
)

word_document_rstudio(
  ...,
  reference_docx = system.file("templates", "rstudio", "template-default.docx", package
    = "teproj")
)
}
\arguments{
\item{toc}{\code{TRUE} to include a table of contents in the output}

\item{toc_depth}{Depth of headers to include in table of contents}

\item{fig_width}{Default width (in inches) for figures}

\item{fig_height}{Default height (in inches) for figures}

\item{fig_caption}{\code{TRUE} to render figures with captions}

\item{df_print}{Method to be used for printing data frames. Valid values
include "default", "kable", "tibble", and "paged". The "default" method
uses a corresponding S3 method of \code{print}, typically
\code{print.data.frame}. The "kable" method uses the
\code{\link[knitr:kable]{knitr::kable}} function. The "tibble" method uses
the \pkg{tibble} package to print a summary of the data frame. The "paged"
method creates a paginated HTML table (note that this method is only valid
for formats that produce HTML). In addition to the named methods you can
also pass an arbitrary function to be used for printing data frames. You
can disable the \code{df_print} behavior entirely by setting the option
\code{rmarkdown.df_print} to \code{FALSE}.}

\item{highlight}{Syntax highlighting style. Supported styles include
"default", "tango", "pygments", "kate", "monochrome", "espresso",
"zenburn", and "haddock". Pass \code{NULL} to prevent syntax highlighting.}

\item{reference_docx}{path. Refers to custom word document template.}

\item{keep_md}{Keep the markdown file generated by knitting.}

\item{md_extensions}{Markdown extensions to be added or removed from the
default definition or R Markdown. See the \code{\link[rmarkdown]{rmarkdown_format}} for
additional details.}

\item{pandoc_args}{Additional command line options to pass to pandoc}

\item{...}{dots. Arguments passed to \code{word_dcoument_te()}.}
}
\description{
Export an Rmarkdown file to a Word document using a custom template.
}
\details{
All of the default arguments are the same as those from the original
\code{rmarkdown::word_document()}. The \verb{_te} version uses a personally
customized Word document. The \verb{_rstudio} version is the document
that is generated by knitting the default \code{rmarkdown} Word document template.
}
\seealso{
\url{https://github.com/rstudio/rmarkdown/blob/master/R/word_document.R}.
}
