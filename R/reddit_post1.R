renv::use(
  askpass      = "askpass@1.2.1",
  cli          = "cli@3.6.4",
  colorspace   = "colorspace@2.1-1",
  dplyr        = "dplyr@1.1.4",
  fansi        = "fansi@1.0.6",
  farver       = "farver@2.1.2",
  generics     = "generics@0.1.3",
  glue         = "glue@1.8.0",
  labeling     = "labeling@0.4.3",
  lifecycle    = "lifecycle@1.0.4",
  magrittr     = "magrittr@2.0.3",
  munsell      = "munsell@0.5.1",
  openssl      = "openssl@2.3.2",
  pillar       = "pillar@1.10.1",
  pkgconfig    = "pkgconfig@2.0.3",
  R6           = "R6@2.6.1",
  RColorBrewer = "RColorBrewer@1.1-3",
  renv         = "renv@1.1.2",
  rlang        = "rlang@1.1.5",
  scales       = "scales@1.3.0",
  sys          = "sys@3.4.3",
  tibble       = "tibble@3.2.1",
  tidyselect   = "tidyselect@1.2.1",
  utf8         = "utf8@1.2.4",
  vctrs        = "vctrs@0.6.5",
  viridisLite  = "viridisLite@0.4.2",
  withr        = "withr@3.0.2"
)

renv::embed()

# From the code I posted, it's fairly easy to generate a hash for a student's
# quiz responses (assuming all questions are multiple choice).  However,
# depending on how you want to grade that exam (pass-fail, every question has
# the same weight, weighing questions differently) it becomes more complicated.
#
# I'll put links to the source code at the bottom for 2 files (a shiny app that
# represents an sample exam, and a .R script to show how you can build an answer
# key to evaluate/grade performance based on these 3 different approaches.
#
# Here's a brief description of each of those approaches though:
#
#   **PASS-FAIL (@100% correct answers) **
# the shiny app captures the student's responses in memory, hashes them as a
# single string, then compares to a hash of the correct answers. You are unable
# to tell how the student performed not only on any specific question, but how
# many questions they got correct

library(renv)
library(scales)
library(openssl)
library(dplyr)

rm(list=ls());cat('\f')
gc()

student1_hash <- "A,B,C,D" |> md5()
## [1] "93f9dc4db1b82845990c5124e8b1c45a"
key_hash <- "B,B,C,D" |> md5()
## [1] "1165419d17192b0727a71195237d584d"
ifelse(test = student1_hash == key_hash, yes  = "PASS",  no   = "FAIL")
## [1] "FAIL"

# **EQUAL WEIGTH ANSWERS**
# the shiny app counts how many questions the student guessed correctly and
# returns a hash of that number.

student1_ans <- c("A", "B", "C", "D")
key_ans      <- c("B", "B", "C", "D")

all.possible.answers <- expand.grid(q1 = LETTERS[1:4], 
                                    q2 = LETTERS[1:4], 
                                    q3 = LETTERS[1:4], 
                                    q4 = LETTERS[1:4], stringsAsFactors = F)
as_tibble(all.possible.answers)

all.possible.answers$q1_correct <- all.possible.answers$q1 == key_ans[1]
all.possible.answers$q2_correct <- all.possible.answers$q2 == key_ans[2]
all.possible.answers$q3_correct <- all.possible.answers$q3 == key_ans[3]
all.possible.answers$q4_correct <- all.possible.answers$q4 == key_ans[4]

all.possible.answers <- all.possible.answers |> 
  mutate(t_correct = q1_correct +q2_correct +q3_correct +q4_correct , 
         pct_correct = t_correct / 4, 
         hash.pct_correct = md5(as.character(pct_correct)))

hash.equal_weight <- all.possible.answers %>%
  group_by(t_correct,  
           pct_correct = scales::percent(pct_correct),
           hash.pct_correct) %>%
  summarise(n = n()) %>%
  .[order(.$t_correct,decreasing = T),]

# get hash of student


hash_student.weighted (sum(student1_ans[1] == key_ans[1],
      student1_ans[2] == key_ans[2],
      student1_ans[3] == key_ans[3],
      student1_ans[4] == key_ans[4])/4) |> 
  as.character() |> 
  md5()

# **Unequal Weight Answers**
# the shiny app does everything that the equal-weight approach does, but weights
# the questions before assigning a percent_correct value to the student's
# outcome.

