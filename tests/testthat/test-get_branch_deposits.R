context("test-get_branch_deposits")

test_that("get_branch_deposits works", {
  if (curl::has_internet())
  {
    # Chase
    X <- get_branch_deposits(628, 2018)
    expect_true(nrow(X) > 0 && ncol(X) == 9)
    # Chase is a 1 trillion dollar bank, but deposits is in thousands
    expect_true(sum(X$deposit)*1000 > 1E12)
  } else
  {
    expect_true(TRUE)
  }
})
