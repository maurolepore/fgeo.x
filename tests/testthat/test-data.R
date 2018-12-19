expect_printed_output <- function(object, update = FALSE) {
  file <- rlang::quo_text(rlang::enquo(object))

  testthat::expect_known_output(
    object, paste0("ref-", file),
    print = TRUE, update = update
  )

  invisible(object)
}



context("data")

test_that("data remains unchanged", {
  skip_if_not_installed("purrr")
  skip_if_not_installed("tibble")

  library(fgeo.x)
  pkg <- "fgeo.x"
  datasets_chr <-   utils::data(package = pkg)$results[, "Item"]
  datasets <- datasets_chr %>%
    purrr::map(~get(.x, asNamespace(pkg))) %>%
    purrr::set_names(datasets_chr) %>%
    purrr::map_if(is.data.frame, tibble::as.tibble) %>%
    # head of each list item
    purrr::map_if(Negate(is.data.frame), ~purrr::map(.x, head))

  expect_printed_output(datasets)
})
