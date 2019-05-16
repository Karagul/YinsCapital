#' @title Warning Message
#' @description This function accepts personalized input and reads out a warning message.
#' @param symbol
#' @return NULL
#' @examples  job_finished_warning()
#' @export job_finished_warning
#'
#' # Define function
job_finished_warning <- function(
  path = "C:/Users/eagle/Desktop/",
  speed = 2,
  content = c(
    "Mr. Yin, your program is ready.",
    "Sir, your code is finished.",
    "Running job is done, sir.",
    "Mr. Yin, job has just finished running."),
  choose_or_random = TRUE
){
  if (choose_or_random == TRUE) {
    content <- content[sample(length(content),1)]
  } else {
    content <- content[choose_or_random]
  }; content
  x = "Angela"; Rtts::tts_ITRI(content, speaker = x, speed = speed, destfile = paste0(path,"audio_tts_", x, ".wave"))
  tmp = audio::load.wave(paste0(path, "audio_tts_Angela.wave"))
  beepr::beep(10); audio::play(tmp)
} # End of function
