renv::use(
  askpass    = "askpass@1.2.1",
  cli        = "cli@3.6.4",
  cpp11      = "cpp11@0.5.2",
  dplyr      = "dplyr@1.1.4",
  fansi      = "fansi@1.0.6",
  generics   = "generics@0.1.3",
  glue       = "glue@1.8.0",
  lifecycle  = "lifecycle@1.0.4",
  lubridate  = "lubridate@1.9.4",
  magrittr   = "magrittr@2.0.3",
  openssl    = "openssl@2.3.2",
  pillar     = "pillar@1.10.1",
  pkgconfig  = "pkgconfig@2.0.3",
  R6         = "R6@2.6.1",
  renv       = "renv@1.1.1",
  rlang      = "rlang@1.1.5",
  sys        = "sys@3.4.3",
  tibble     = "tibble@3.2.1",
  tidyselect = "tidyselect@1.2.1",
  timechange = "timechange@0.3.0",
  utf8       = "utf8@1.2.4",
  vctrs      = "vctrs@0.6.5",
  withr      = "withr@3.0.2"
)

renv::embed()

# de-hash shiny answerkey

library(renv)
library(openssl)
library(dplyr)
library(openssl)
library(lubridate)

rm(list=ls());cat('\f')

correct.answers <- data.frame(q_num = 1:6, 
                              answer = c("B", "C", "C", 
                                         "A", "BC", 
                                         as.character(ymd("1776-07-04"))))

temp.dates <- as.character(as_date(c(ymd("1776-07-04"),
                                     ymd("2025-03-01"):ymd("2025-03-06"))))

(length(temp.dates) * 2 * 4 * 3 * 2 * 4) # number of dates

# create list of all possible multiple choice responses for each question (just
# Q5 in this case)
mcex <- expand.grid(c("", LETTERS[1:4]), 
                    c("", LETTERS[1:4]), 
                    c("", LETTERS[1:4]), 
                    c("", LETTERS[1:4]), 
                    c("", LETTERS[1:4])) |> 
  mutate(ans1 = paste(Var1,Var2,Var3,Var4,Var5, sep = ""))

# cleanup to reorder the response into alphabetical order
mcex$ans1 <- strsplit(mcex$ans1, "") |> 
  lapply(unique) |> 
  lapply(sort) |> 
  lapply(paste, sep = "", collapse = "")  |> 
  unlist()


# Approach 1: Hash verbatim answers----
# get all possible answer combinations
answer.combinations.ap1 <- expand.grid(q1 = LETTERS[1:2], 
                                       q2 = LETTERS[1:4], 
                                       q3 = LETTERS[1:3], 
                                       q4 = LETTERS[1:2], 
                                       q5 = unique(mcex$ans1), 
                                       q6 = temp.dates # all possible date choices (truncated in this example)
)

rm(mcex)

# check each possible answer and see how many are correct
str_n.correct <- data.frame(n_correct = rep(0,nrow(answer.combinations.ap1)))
for(i in 1:ncol(answer.combinations.ap1)){
  str_n.correct <- str_n.correct + 
    as.numeric(as.character(answer.combinations.ap1[,i]) == correct.answers$answer[i])
}

# calc the number of questions answered correctly for each hash
answer.combinations.ap1$n_correct <- str_n.correct$n_correct

# update df with hash and n_correct
answer.combinations.ap1 <- answer.combinations.ap1 |> 
  mutate(string = paste(q1, q2, q3, q4, q5, q6, 
                        sep = ",")) |> 
  mutate(hash_ap1 = md5(string)) |> 
  as_tibble()

# cleanup
rm(str_n.correct, i, temp.dates)

# Approach 2: Check (then hash) if questions were answered correctly----

# cleanup 
# remove a column, 
answer.combinations.ap2 <- 
  (answer.combinations.ap1)[colnames(answer.combinations.ap1) != 
                              c("n_correct", "string", "hash_ap1")] |> 
  as.data.frame()

#factorized columns to character 
for(i in 1:ncol(answer.combinations.ap2)){
  if(class(answer.combinations.ap2[,i]) == "factor"){
    answer.combinations.ap2[,i] <- as.character(answer.combinations.ap2[,i])
  }
}

answer.combinations.ap2 <- as_tibble(answer.combinations.ap2)

answer.combinations.ap2$q1 <- answer.combinations.ap2$q1 == 
  correct.answers$answer[correct.answers$q_num == 1]
answer.combinations.ap2$q2 <- answer.combinations.ap2$q2 == 
  correct.answers$answer[correct.answers$q_num == 2]
answer.combinations.ap2$q3 <- answer.combinations.ap2$q3 == 
  correct.answers$answer[correct.answers$q_num == 3]
answer.combinations.ap2$q4 <- answer.combinations.ap2$q4 == 
  correct.answers$answer[correct.answers$q_num == 4]
answer.combinations.ap2$q5 <- answer.combinations.ap2$q5 == 
  correct.answers$answer[correct.answers$q_num == 5]
answer.combinations.ap2$q6 <- answer.combinations.ap2$q6 == 
  correct.answers$answer[correct.answers$q_num == 6]

answer.combinations.ap2$which_correct <- paste(answer.combinations.ap2$q1,
                                               answer.combinations.ap2$q2,
                                               answer.combinations.ap2$q3,
                                               answer.combinations.ap2$q4,
                                               answer.combinations.ap2$q5,
                                               answer.combinations.ap2$q6, 
                                               sep = ",")
# hash'em
answer.combinations.ap2$hash_ap2 <- md5(answer.combinations.ap2$which_correct)

# Approach 3: Count (then hash) the number of correct answers----
answer.combinations.ap3 <- 
  answer.combinations.ap2[!colnames(answer.combinations.ap2) %in%
                            c("hash_ap2", "which_correct")] |> 
  as.data.frame()

answer.combinations.ap3$n_correct <- NA
for(i in 1:nrow(answer.combinations.ap3)){
  answer.combinations.ap3$n_correct[i] <- sum(c(answer.combinations.ap3$q1[i],
                                                answer.combinations.ap3$q2[i],
                                                answer.combinations.ap3$q3[i],
                                                answer.combinations.ap3$q4[i],
                                                answer.combinations.ap3$q5[i],
                                                answer.combinations.ap3$q6[i]))
}

answer.combinations.ap3 <- as_tibble(answer.combinations.ap3)


#hash'em
answer.combinations.ap3$hash_ap3 <- md5(as.character(answer.combinations.ap3$n_correct))

# cleanup----

rm(i, correct.answers)


answer.combinations.ap1
answer.combinations.ap2
answer.combinations.ap3
