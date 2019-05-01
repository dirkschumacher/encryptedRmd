tpl <- readr::read_file("devel/html-template.html")
js <- readr::read_file("devel/html-template.js")

# prepend licenses
js_licenses <- readr::read_file("devel/JSLICENSES.txt")
js_licenses <- paste0(
"The javascript and html code is based on a number of JS packages. The licenses are listed below:\n",
'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
self-decrypting-html-page v1.0.1- License ISC
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Copyright (c) 2018, Jannis R

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

',
js_licenses
)

js_licenses <- paste0(paste0("// ", strsplit(js_licenses, split = "\n", fixed = TRUE)[[1]]), collapse = "\n")

js <- paste0(js_licenses, "\n", js, collapse = "\n")

tpl <- gsub(pattern = "{{js}}", replacement = js, x = tpl, fixed = TRUE)
readr::write_file(tpl, "inst/html-template.html")
