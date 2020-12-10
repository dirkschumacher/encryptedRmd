
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/encryptedRmd)](https://CRAN.R-project.org/package=encryptedRmd)
[![R build
status](https://github.com/dirkschumacher/encryptedRmd/workflows/R-CMD-check/badge.svg)](https://github.com/dirkschumacher/encryptedRmd/actions)
<!-- badges: end -->

# Password protected html markdown documents

Self-encrypt html markdown reports using
[libsodium](https://doc.libsodium.org/). The package lets you password
protect markdown html documents and share them with others securely. The
code needed to decrypt the file is bundled into the exported html file,
which makes the resulting file fully self contained.

*Use at your own risk. Feedback and bug reports very welcome\!*

## Installation

``` r
install.packages("encryptedRmd")
```

``` r
remotes::install_github("dirkschumacher/encryptedRmd")
```

## Functions

### Encrypt html files

``` r
library(encryptedRmd)
encrypt_html_file("devel/example/test.html", output_path = "docs/test.encrypted.html")
#> The key to your file is: f5c8c13752cf4e8cc59b59e9f96279ceb6836fc8ce957e55e232724dd80c318f
#> Your file has been encrypted and saved at docs/test.encrypted.html
```

You can take a look at the exported file
[here](https://dirkschumacher.github.io/encryptedRmd/test.encrypted.html)
and use the key printed above to decrypt it.

### Encrypted `rmarkdown` html format

``` yml
---
title: "test"
output: encryptedRmd::encrypted_html_document
---
```

See
[here](https://github.com/dirkschumacher/encryptedRmd/tree/master/devel/example)
for an example. After knitting, the document is encrypted with a random
key and the file is stored in the same directory together with the key.

## Inspiration

Inspired and based on the work by @derhuerst on [self encrypting html
pages](https://github.com/derhuerst/self-decrypting-html-page).

## License

MIT

## Development

In `devel/r-encrypted-html-template` the code to generate the javascript
file is contained. In order to update the template, you have to run the
following:

  - In `devel/r-encrypted-html-template` run `npm run build`. This
    creates a new version of the template and copies it to
    `devel/html-template.js`. It also creates a file called
    `JSLICENSES.txt` that contains all licenses of used node packages.
  - In `devel` run `combine.R`. This generates the file report template
    and copies it to `inst/html-template.html`. This template is then
    used within the R package to generate encrypted html files.
