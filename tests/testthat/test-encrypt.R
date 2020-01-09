test_that("we can encrypt a file", {
  tmp <- tempfile(fileext = ".html")
  file.create(tmp)
  on.exit(file.remove(tmp))
  key <- sodium::random(32)
  expect_message(
    result <- encrypt_html_file(tmp, key = key),
    "key|enc\\.html"
  )
  expect_equal(result, key)
})
