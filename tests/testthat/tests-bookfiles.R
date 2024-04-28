test_that("book files functions", {

  my_dir <- fs::path(tempdir(), 'introR-test')
  flag <- introR::bookfiles_get(my_dir)

  expect_true(flag)

})
