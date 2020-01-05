#' Encrypt an html file
#'
#' @param path the file you want to encrypt
#' @param output_path optional, the output path
#' @param key optional, the encryption key
#' @param message_key optional, print the encryption key to the console
#' @param write_key_file optional, write a key file in the same directory
#' @param output_template_path a path to the output template. The output template needs have the same html form elements (same ids) and the same placeholders as the default template. Everything else can be customized.
#'
#' @return
#' The key used to encrypt the file in hex encoding as an invisible character vector.
#' @export
encrypt_html_file <- function(path,
                              output_path = paste0(path, ".enc.html"),
                              key = sodium::random(32L),
                              message_key = TRUE,
                              write_key_file = FALSE,
                              output_template_path = system.file("html-template.html", package = "encryptedRmd")) {
  stopifnot(file.exists(path), is.raw(key), length(key) >= 32L)
  content <- charToRaw(readr::read_file(path))
  nonce <- sodium::random(24L)
  encrypted_content <- sodium::data_encrypt(content, key, nonce)
  tpl <- readr::read_file(output_template_path)
  js <- read_pkg_file("html-template.js")
  tpl <- inject_raw_data(tpl, "encrypted", encrypted_content)
  tpl <- inject_raw_data(tpl, "nonce", nonce)
  tpl <- inject_raw_data(tpl, "js", js, to_hex = FALSE)
  readr::write_file(tpl, output_path)
  hex_key <- sodium::bin2hex(key)
  if (message_key) {
    message("The key to your file is: ", hex_key)
    message("Your file has been encrypted and saved at ", output_path)
  }
  if (write_key_file) {
    readr::write_file(paste0(output_path, ".key"), x = hex_key)
  }
  invisible(hex_key)
}

inject_raw_data <- function(template, key, content, to_hex = TRUE) {
  gsub(
    x = template,
    pattern = paste0("{{", key, "}}"),
    replacement = if (to_hex) sodium::bin2hex(content) else content,
    fixed = TRUE
  )
}

read_pkg_file <- function(path) {
  readr::read_file(system.file(path, package = "encryptedRmd"))
}


#' Create an encrypted HTML document
#'
#' In addition to a standard html file the function also creates an encrypted version
#' together with the key as two separate files.
#'
#' Two files are created:
#' \describe{
#'  \item{filename.enc.html}{This is the password protected file.}
#'  \item{filename.enc.html.key}{This file contains the key with which the report was encrypted.}
#' }
#'
#' Please only share the key file with trusted communication partners.
#'
#' @param ... all parameters are passed to rmarkdown::html_document
#'
#' @export
encrypted_html_document <- function(...) {
  format <- rmarkdown::html_document(...)
  initial_post_process <- format$post_processor
  format$post_processor <- function(metadata, input_file, output_file, clean, verbose) {
    on.exit(encrypt_html_file(path = output_file, message_key = FALSE, write_key_file = TRUE))
    initial_post_process(metadata, input_file, output_file, clean, verbose)
  }
  format
}

