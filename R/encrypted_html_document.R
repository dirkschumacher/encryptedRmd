#' Create an encrypted HTML document
#'
#' In addition to a standard html file this \code{rmarkdown} format also creates
#' an encrypted version together with the key as two separate files.
#'
#' Two files are created:
#' \describe{
#'  \item{filename.enc.html}{This is the password protected file.}
#'  \item{filename.enc.html.key}{This file contains the key with which the report was encrypted.}
#' }
#'
#' @param ... all parameters are passed to \code{rmarkdown::html_document}
#'
#' @details
#' Warning: You are using this at your own risk. Make sure your encryption key is
#' strong enough. For serious use cases, please also review the code of the functions.
#' Any feedback is appreciated. This is an early package version.
#' Please only share the key file with trusted parties
#'
#' @return
#' R Markdown output format to pass to \code{\link[rmarkdown]{render}}
#'
#' @seealso
#' \code{\link{encrypt_html_file}} for more information on the encryption.
#'
#' @export
#' @include encrypt_html_file.R
encrypted_html_document <- function(...) {
  format <- rmarkdown::html_document(...)
  initial_post_process <- format$post_processor
  format$post_processor <- function(metadata, input_file, output_file, clean, verbose) {
    on.exit(encrypt_html_file(path = output_file, message_key = FALSE, write_key_file = TRUE))
    initial_post_process(metadata, input_file, output_file, clean, verbose)
  }
  format
}
