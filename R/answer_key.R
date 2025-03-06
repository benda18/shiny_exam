renv::use(
  askpass   = "askpass@1.2.1",
  dplyr     = "dplyr@1.1.4",
  lubridate = "lubridate@1.9.4",
  openssl   = "openssl@2.3.2",
  renv      = "renv@1.1.1",
  sys       = "sys@3.4.3"
)



# de-hash shiny answerkey

library(renv)
library(openssl)
library(dplyr)
library(openssl)
library(lubridate)


correct.answers <- data.frame(q_num = 1:6, 
                              answer = c("B", "D", "B", 
                                         "A", "D", 
                                         as.character(ymd("1776-07-04"))))

temp.dates <- as.character(as_date(ymd("1700-01-01"):Sys.Date()))

(length(temp.dates) * 2 * 4 * 3 * 2 * 4)

# get all possible answer combinations
answer.combinations <- expand.grid(q1 = LETTERS[1:2], 
                                   q2 = LETTERS[1:4], 
                                   q3 = LETTERS[1:3], 
                                   q4 = LETTERS[1:2], 
                                   q5 = LETTERS[1:4], 
                                   q6 = LETTERS[1:4] # every day bw 1/1/1400 and today
                                   )

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


