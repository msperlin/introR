#' Get official links from book
#'
#' Use this function in the book so that all links are updated in a single location.
#'
#' @return A list with links
#' @export
#'
#' @examples
#'
#' print(links_get())
links_get <- function() {

  my_l <- list(
    book_blog_site  = 'https://msperlin.com/publication/2024_book-intror/',
    book_blog_zip = 'XXX',
    book_amazon_ebook = "TODO",
    book_amazon_print = "TODO",
    book_amazon_hardcover = "TODO",
    book_github = 'https://github.com/msperlin/introR',
    book_online = "https://www.msperlin.com/introR",
    blog_site = 'https://www.msperlin.com',
    exercises_solutions = 'https://msperlin.com/afedr/intror-eoc-solutions',
    link_script_example = 'https://github.com/msperlin/introR/blob/main/inst/extdata/others/S_Example_Script.R',
    link_blog_dyn_exerc = 'https://www.msperlin.com/post/2023-03-09-compiling-exercises-introR/'
  )

  return(my_l)

}
