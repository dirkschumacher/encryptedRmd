
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

# Password protected html markdown documents

Self-encrypt html markdown reports using sodium. The goal is to provide
functionality to password protect markdown html documents and share them
with others securely. The code needed to decrypt the file is bundled
into the exported html file, which makes the resulting file fully self
contained.

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
#> The key to your file is: 70ca2dbb8f44908bdd12fe20df4b4cce36fb44cc0b482d96cd9704312ee7cb3b
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

See [here](devel/example/) for an example. After knitting, the document
is encrypted with a random key and the file is stored in the same
directory together with the key.

## Inspiration

Inspired and based on the work by @derhuerst on [self encrypting html
pages](https://github.com/derhuerst/self-decrypting-html-page).

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
