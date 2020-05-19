# 20200519 Ronald FUNG

getwd()
ipath <- "./POE/raw/berndt-econometrics-master/data/floppy_ver"
opath <- "./POE/data"
setwd(ipath)

list <- list.files(path = ipath, recursive = TRUE)

# remove FINDER.DAT, README.DAT, and the other doc files
list <- list[!stringr::str_detect(list,pattern="FINDER.DAT") 
             & !stringr::str_detect(list,pattern="README.DOC")
             & stringr::str_detect(list,pattern="CHAP")
             & !stringr::str_detect(list,pattern="CIGAD")
             & !stringr::str_detect(list,pattern="KLEM")]
length(list) # 45 (+2 requires special handling);  47 in total

# write the data files into csvs
for (file in list){
  # import from raw file
  print(file)
  mydata <- data.table::fread(file, header = FALSE)
  # colnames
  header <- scan(file, nmax = ncol(mydata), what = character())
  names(mydata) <- header
  # remove duplicate headers
  if ((mydata[1,1] == colnames(mydata)) |
      (substr(mydata[1,1], 1, nchar(colnames(mydata)[1])) == colnames(mydata)[1])){
    mydata <- mydata[-1, ]
  }
  # write as csv
  write.csv(mydata, 
            file = paste(opath, "/", substr(file, stringr::str_locate(file, "/")[1] + 1, nchar(file)), ".csv", sep = ""), 
            row.names = FALSE)
}

# Problem:
# multiple datasets in the same text file
# "CHAP8.DAT/CIGAD"
# "CHAP9.DAT/KLEM"

# "CHAP8.DAT/CIGAD"
file = "CHAP8.DAT/CIGAD"
txt <- readLines(con = file)
mydata1 <- data.table::fread(text = txt[1:50], header = TRUE)
mydata2 <- data.table::fread(text = txt[51:length(txt)], header = TRUE)
mydata <- cbind(mydata1, mydata2[, -1])
write.csv(mydata, 
          file = paste(opath, "/", substr(file, stringr::str_locate(file, "/")[1] + 1, nchar(file)), ".csv", sep = ""), 
          row.names = FALSE)
# mydata <- read.csv("C:/Users/rfung/Desktop/POE/data/CIGAD.csv", header = TRUE)

# "CHAP9.DAT/KLEM"
file = "CHAP9.DAT/KLEM"
txt <- readLines(con = file)
which(txt == "")
mydata1 <- data.table::fread(text = txt[1:26], header = TRUE)
mydata2 <- data.table::fread(text = txt[28:53], header = TRUE)
mydata3 <- data.table::fread(text = txt[55:length(txt)], header = TRUE)
mydata <- cbind(mydata2[, 1], mydata1[, -1], mydata2[, -1], mydata3[, -1])
mydata <- plyr::rename(mydata, c("DATE" = "YEAR"))
write.csv(mydata, 
          file = paste(opath, "/", substr(file, stringr::str_locate(file, "/")[1] + 1, nchar(file)), ".csv", sep = ""), 
          row.names = FALSE)
# mydata <- read.csv("C:/Users/rfung/Desktop/POE/data/KLEM.csv", header = TRUE)

