"
This file contains code for scraping historical powerball game data for project

The first part extracts all first five ball historical value
The second part extracts the 'power ball' historical value

I intentionally separate the two parts as their tags in html are different.
"

"======= set up working environment ==============================="

setwd("E:/Project/Powerball Distribution")
library(rvest)


"======== collect the the first five ball historical value from website ===================="

## create a dataframe to store first five balls' values
fiveball_data = matrix(numeric(0),0,5)

collect_fiveballvalue = function(fivevalue_df,page_index)
# function to web scrapping first five ball historical value
{
  url = paste("https://www.usamega.com/powerball-history.asp?p=",as.character(page_index),sep="")
  webpage = read_html(url) # download webpage
  nodes_tags = html_nodes(webpage,"td:nth-child(4) b") # get first 5 ball data. tag is obtained by SelectorGadget
  nodes_notags = html_text(nodes_tags) # remove tag
  ## function to retrieve only number information
  split_function = function(string)
  {
    return (strsplit(string,' · '))
  }
  ballvalue_str = sapply(nodes_notags,split_function) # split one string to five, each of which is a ball value
  ballvalue_mx = matrix(unlist(ballvalue_str),nrow=length(ballvalue_str),byrow=T) # unlist to dataframe
  fivevalue_df=rbind(fivevalue_df,ballvalue_mx)
}

"Loop through all pages to extract historical powerball data"
ind = 1:104
for (i in (ind))
{
  fiveball_data = collect_fiveballvalue(fiveball_data,i)
}
fiveball_data_num = apply(fiveball_data,2,as.numeric)
write.csv(fiveball_data_num,"fiveballdata.csv",row.names = FALSE) # save first five ball value



"=================== collect 'power ball' information ===================="
powerball_data = character()
collect_powerballvalue = function(powerball_df,page_index)
  # function to web scrapping powerball historical value
{
  url = paste("https://www.usamega.com/powerball-history.asp?p=",as.character(page_index),sep="")
  webpage = read_html(url) # download webpage
  nodes_tags = html_nodes(webpage,"b+ font strong") # get powerball value. tag is obtained by SelectorGadget
  nodes_notags = html_text(nodes_tags) # remove tag
  powerball_data=c(powerball_data,nodes_notags)
  return (powerball_data)
}
ind = 1:104
for (i in (ind))
{
  powerball_data = collect_powerballvalue(powerball_data,i)
}
write.csv(powerball_data,"powerballdata.csv",row.names = FALSE) # save powerball value

"==================== combine first five ball and power ball value =========="
fiveball = read.csv("fiveballdata.csv")
powerball = read.csv("powerballdata.csv")
alldata = cbind(fiveball,powerball) # combine first five ball and power ball
write.csv(alldata,"allballdata.csv",row.names = FALSE)
