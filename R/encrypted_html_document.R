#' Encrypt an html file
#'
#' @param path the file you want to encrypt
#' @param output_path optional, the output path
#' @param key optional, the encryption key
#' @param message_key optional, print the encryption key to the console
#' @param write_key_file optional, write a key file in the same directory
#'
#' @export
encrypt_html_file <- function(path,
                              output_path = paste0(path, ".enc.html"),
                              key = sodium::random(32L),
                              message_key = TRUE,
                              write_key_file = FALSE) {
  stopifnot(file.exists(path), is.raw(key), length(key) >= 32L)
  content <- charToRaw(readr::read_file(path))
  nonce <- sodium::random(24L)
  encrypted_content <- sodium::data_encrypt(content, key, nonce)
  tpl <- read_pkg_file("html-template.html")
  tpl <- inject_raw_data(tpl, "encrypted", encrypted_content)
  tpl <- inject_raw_data(tpl, "nonce", nonce)
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

inject_raw_data <- function(template, key, content) {
  gsub(
    x = template,
    pattern = paste0("{{", key, "}}"),
    replacement = sodium::bin2hex(content),
    fixed = TRUE
  )
}

read_pkg_file <- function(path) {
  readr::read_file(system.file(path, package = "encryptedRmd"))
}


#' Convert to an encrypted HTML document
#'
#' In addition to a standard html file the function also creates an encrypted version
#' together with the key as two separate files.
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

