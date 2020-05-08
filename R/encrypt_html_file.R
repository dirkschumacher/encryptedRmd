#' Encrypt an html file
#'
#' This function takes an html file, encrypts the complete file using \code{\link[sodium:data_encrypt]{sodium::data_encrypt}}
#' and a given key. It then injects the encrypted content into an html template that
#' contains the \code{sodium} decryption code compiled to javascript.
#' The resulting file is fully self contained as it can decrypt itself.
#' When the user enters the correct key, the DOM of the html files gets replaced with
#' the initially encrypted html file.
#'
#' @param path the file you want to encrypt
#' @param output_path optional, the output path
#' @param key optional, the encryption key
#' @param message_key optional, print the encryption key to the console
#' @param write_key_file optional, write a key file in the same directory
#' @param output_template_path a path to the output template.
#' The output template needs have the same html form elements (same ids) and the same placeholders as the default template. Everything else can be customized.
#'
#' @details
#' Warning: You are using this at your own risk. Make sure your encryption key is
#' strong enough. For serious use cases, please also review the code of the functions.
#' Any feedback is appreciated. This is an early package version.
#'
#' @return
#' The key used to encrypt the file as an invisible raw vector.
#'
#' @references
#' The package follows the same approach as the node module \href{https://github.com/derhuerst/self-decrypting-html-page}{self-decrypting-html-page}.
#' The decryption code is based on a number of great node modules.
#' All licenses are also bundled with each encrypted html file.
#'
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
  invisible(key)
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
