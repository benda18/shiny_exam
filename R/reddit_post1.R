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
# single string, then compares to a hash of the correct answers. You are unable to tell how the student performed not only on any specific question, but how many questions they got correct

library(renv)
library(scales)
library(openssl)

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

all.possible.answers$q1_correct <- all.possible.answers$q1 == student1_ans[1]
all.possible.answers$q2_correct <- all.possible.answers$q2 == student1_ans[2]
all.possible.answers$q3_correct <- all.possible.answers$q3 == student1_ans[3]
all.possible.answers$q4_correct <- all.possible.answers$q4 == student1_ans[4]

all.possible.answers <- all.possible.answers |> 
  mutate(t_correct = q1_correct +q2_correct +q3_correct +q4_correct , 
         pct_correct = t_correct / 4, 
         hash.pct_correct = md5(as.character(pct_correct)))

all.possible.answers %>%
  group_by(t_correct,  
           pct_correct,
           hash.pct_correct) %>%
  summarise(n = n()) %>%
  .[order(.$n,decreasing = F),]
