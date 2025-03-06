renv::use(
  askpass    = "askpass@1.2.1",
  cli        = "cli@3.6.4",
  dplyr      = "dplyr@1.1.4",
  fansi      = "fansi@1.0.6",
  generics   = "generics@0.1.3",
  glue       = "glue@1.8.0",
  lifecycle  = "lifecycle@1.0.4",
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
  utf8       = "utf8@1.2.4",
  vctrs      = "vctrs@0.6.5",
  withr      = "withr@3.0.2"
)



# de-hash shiny answerkey

library(renv)
library(openssl)
library(dplyr)
library(openssl)


correct.answers <- data.frame(q_num = 1:6, 
                              answer = c("B", "D", "B", 
                                         "A", "D", "C"))

# get all possible answer combinations
answer.combinations <- expand.grid(q1 = LETTERS[1:2], 
                                   q2 = LETTERS[1:4], 
                                   q3 = LETTERS[1:3], 
                                   q4 = LETTERS[1:2], 
                                   q5 = LETTERS[1:4], 
                                   q6 = LETTERS[1:4])

# check each possible answer and see how many are correct
str_n.correct <- data.frame(n_correct = rep(0,nrow(answer.combinations)))
for(i in 1:ncol(answer.combinations)){
  str_n.correct <- str_n.correct + 
    as.numeric(as.character(answer.combinations[,i]) == correct.answers$answer[i])
}

answer.combinations$n_correct <- str_n.correct$n_correct

# update df with hash and n_correct
hashes <- answer.combinations |> 
  mutate(string = paste(q1, q2, q3, q4, q5, q6, 
                        sep = ",")) |> 
  mutate(hash.md5 = md5(string)) |> 
  as_tibble()

# sort df
key.hashes <- hashes[order(hashes$n_correct,decreasing = T),]

# cleanup
rm(answer.combinations, correct.answers, hashes, str_n.correct, i)


