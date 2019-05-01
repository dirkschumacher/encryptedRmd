
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

# encryptedRmd

Self-encrypt html markdown reports using sodium. The goal is to provide
functionality to encrypt markdown html documents and share them with
others securely. The code needed to decrypt the file is bundled into the
exported html file.

\*\* EXPERIMENTAL \*\*

## Installation

``` r
remotes::install_github("dirkschumacher/encryptedRmd")
```

## Functions

### Encrypt html files

``` r
library(encryptedRmd)
encrypt_html_file("devel/example/test.html", output_path = "docs/test.encrypted.html")
#> The key to your file is: 0268989a8721953c4fbb4536ba249cea06d0b7ca289d8b439c4421f89965bbb9
#> Your file has been encrypted and saved at docs/test.encrypted.html
```

You can take a look at the exported file
[here](https://dirkschumacher.github.io/encryptedRmd/test.encrypted.html)
and use the key printed above to decrypt it.

### Encrypted rmarkdown html format

``` yml
---
title: "test"
output: encryptedRmd::encrypted_html_document
---
```

See [here](devel/example/) for an example. After knitting the document
is encrypted with a random key and the file is stored in the same
directory together with the key.

## Inspiration

Inspired and based on the work by @derhuerst on [self encrypting html
pages](https://github.com/derhuerst/self-decrypting-html-page).
