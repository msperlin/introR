#' Compiles exercises from book afedR
#'
#' This function uses the \link{exams} package to create exercises in the html or pdf format with
#' random selections. This means that each student will receive a different version of the same
#' exercise. All exercise files are taken from book "Analysing Financial and Economic Data with R".
#'
#' @param students_names Names of students (a vector)
#' @param students_ids Ids of students (a vector)
#' @param class_name The name of the class
#' @param exercise_name The name of the exercises
#' @param links_in_html A dataframe with links to be added in the html page. This can
#'     be anything that helps the students. The dataframe must have two columns: "text" with the text to
#'     appear in the html and "url" with the actual link (see default options for details).
#' @param chapters_to_include Chapter to include in exercise (1-13)
#' @param solution flag (TRUE/FALSE) for whether printing solutions or not
#' @param dir_out Folder to copy exercise html files
#' @param language Selection of language ("en" only so far)
#'
#' @return TRUE, if sucessfull
#' @export
#'
#' @examples
#' \dontrun{
#' afedR_build_exam(students_names = 'George', chapters_to_include = 2,
#'                  dir_out = tempdir())
#'  }
compile_html_exercises <- function(students_names,
                             students_ids = paste0('Exam ', 1:length(students_names)),
                             class_name = 'Sample class',
                             exercise_name = paste0('Sample Exercise'),
                             links_in_html = dplyr::tibble(text = 'Analyzing Financial and Economic Data with R',
                                                           url = 'https://www.msperlin.com/afedr'),
                             chapters_to_include = 1:3,
                             solution = FALSE,
                             dir_out = 'html exams',
                             language = 'en') {

  # check args
  if (length(students_names) != length(students_ids)) {
    stop('Length of students_names does no match the length of studends_ids. Check your inputs..')
  }

  if (!is.numeric(chapters_to_include)) {
    stop('Arg chapters_to_include should be of numeric type.')
  }

  if ( any(chapters_to_include < 0)|any(chapters_to_include > 13 ) ) {
    stop('Arg chapters_to_include should be between 1 and 13.')
  }

  path_exercises <- system.file('extdata/exams_files/02-EOCE-Rmd', package = 'introR')
  available_exercises <- list.files(path_exercises,
                                    full.names = TRUE,
                                    recursive = TRUE, pattern = '.Rmd')

  if (!dir.exists(dir_out)) dir.create(dir_out)

  chapter_names <- paste0('afedR_Chap-', sprintf('%02d', chapters_to_include))
  idx <- stringr::str_sub(basename(available_exercises), 1, 13) %in%
    chapter_names

  exercises_to_compile <- available_exercises[idx]

  n_ver <- length(students_names)

  # set template
  template_html_file <- system.file('extdata/exams_files/templates/Exams_Template.html',
                                    package = 'introR')

  my_temp_dir <- file.path(tempdir(), paste0('exams files ',
                                             basename(tempfile())) )

  # make sure duplicate labels are possible
  options(knitr.duplicate.label = "allow")

  my_exam <- exams::exams2html(file = exercises_to_compile,
                               n = length(students_names),
                               name = paste0(class_name, ' - ',
                                             exercise_name,
                                             ' - Version '),
                               encoding = 'UTF-8',
                               dir = my_temp_dir,
                               mathjax = TRUE,
                               template = template_html_file,
                               question = '',
                               verbose = TRUE,
                               solution = solution,
                               quiet = TRUE)

  # make sure duplicate labels are no longer possible
  options(knitr.duplicate.label = "deny")

  # df_answer_key <- dplyr::tibble()
  # for (i_ver in seq(n_ver)){
  #
  #
  #   exam_now <- my_exam[[i_ver]]
  #
  #   n_q <- length(exam_now)
  #
  #   for (i_q in seq(n_q)){
  #
  #     sol_now <- letters[which(exam_now[[i_q]]$metainfo$solution)]
  #
  #     temp <- dplyr::tibble(i_name = students_names[i_ver],
  #                           i_ver = i_ver,
  #                           i_q = i_q,
  #                           solution = sol_now)
  #
  #     df_answer_key <- dplyr::bind_rows(df_answer_key, temp)
  #   }
  #
  # }

  my_old_files <- list.files(my_temp_dir,
                             full.names = TRUE)[1:n_ver]

  # replace content of html and save new files
  l_args <- list(f_in = stringr::str_sort(my_old_files[1:n_ver],
                                          numeric = TRUE),
                 dir_out = dir_out,
                 student_name = students_names[1:n_ver],
                 student_version = 1:n_ver,
                 n_q = length(exercises_to_compile),
                 class_name = class_name,
                 exam_links = rep(list(links_in_html), n_ver),
                 exercise_name = exercise_name)

  purrr::pwalk(.l = l_args, .f = add_html_content)

  # save output
  solutions_out <- build_answer_key(my_exam = my_exam, students_names = students_names)

  return(solutions_out)

}

#' Replaces content in html template file
#'
#' Used for replacing names, id, version and so on on html exercise files.
#'
#' @param f_in File with html code
#' @param dir_out Folder out
#' @param student_name Name of student
#' @param student_version Version of student
#' @param n_q Number of questions in exercise
#' @param class_name Name of class
#' @param exercise_name Name of exercise
#' @param exam_links Links to add
#'
#' @return TRUE, if sucessfull
#' @export
#'
#' @examples
#' \dontrun{
#' afedR_add_html_content(f_in = 'example.html', dir_out = tempdir(),
#'                        student_name = 'George', student_version = 1,
#'                        n_q = 10, class_name = 'example class', exercise_name = 'sample',
#'                        exam_links = NA)
#' }
add_html_content <- function(f_in,
                                   dir_out,
                                   student_name,
                                   student_version,
                                   n_q,
                                   class_name,
                                   exercise_name,
                                   exam_links) {


  if (is.na(student_name)) {
    std.name <- 'ZZ-NO NAME'
  }

  message('Adding content to html: ', student_name)

  html_content <- paste0(readr::read_lines(f_in), collapse = '\n')

  # replace links for html

  base_str <- '<p><a href="%s"> %s </a>.</p>'
  text_itself <- sapply(exam_links, names)

  html_links <- paste0(sprintf(base_str, exam_links$url, exam_links$text),
                       collapse = '\n')

  # make replacements
  replace_vec <- list('EXAM_LINKS' = html_links,
                   'EXAM_NAME' = exercise_name,
                   'TAB_TITLE' = paste0(exercise_name, '-', student_name),
                   'STD_NAME' = student_name,
                   'STD_VERSION' = student_version,
                   'N_QUESTIONS' = n_q,
                   'CLASS_NAME' = class_name,
                   'DATE_COMPILE' = paste0(Sys.time(), ' at ', Sys.info()['nodename']))

  for (i_vec in seq(length(replace_vec))) {
    html_content <- stringr::str_replace_all(html_content,
                                             pattern = stringr::fixed(names(replace_vec[i_vec])),
                                             replacement = replace_vec[[i_vec]])
  }

  my_new_name <- file.path(dir_out,
                           paste0(exercise_name, '_',
                                  student_name, '_',
                                  stringr::str_c('Ver ', sprintf("%02d",student_version)),
                                  '.html') )

  cat(html_content, file = my_new_name, append = FALSE)

  return(invisible(TRUE))
}

