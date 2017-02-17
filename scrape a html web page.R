# ----------------------------------------------------------------------------
# @description
# 
# scrape a web page and parse data
#
# @version 1.0
# @author Ceeb
# (C)Fatkahawai 2016
# ----------------------------------------------------------------------------



library(XML)
library(lubridate)

time_url <- "http://tycho.usno.navy.mil/cgi-bin/timer.pl"

time_parsedhtml <- htmlParse(time_url)
# > class(time_parsedhtml)
# [1] "HTMLInternalDocument" "HTMLInternalDocument" "XMLInternalDocument" 
# [4] "XMLAbstractDocument"
# > time_parsedhtml
# <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final">
# <html><body>
# <p>/EN&gt;
#
# </p>
# <title>What time is it?</title>
# <h2> US Naval Observatory Master Clock Time</h2> <h3><pre>
# <br>Nov. 19, 22:54:04 UTC		Universal Time
# <br>Nov. 19, 05:54:04 PM EST		Eastern Time
# <br>Nov. 19, 04:54:04 PM CST		Central Time
# <br>Nov. 19, 03:54:04 PM MST		Mountain Time
# <br>Nov. 19, 02:54:04 PM PST		Pacific Time
# <br>Nov. 19, 01:54:04 PM AKST	Alaska Time
# <br>Nov. 19, 12:54:04 PM HAST	Hawaii-Aleutian Time
# </pre></h3>
# <p><a href="http://www.usno.navy.mil"> US Naval Observatory</a>
# 
# </p>
# </body></html>

# first extract the block in the <pre> label 
#
timeblock_list <- xpathApply(xmlRoot(time_parsedhtml),"//pre",xmlValue)

# > class(timeblock_list)
# [1] "list"
# > timeblock_list
# [[1]]
# [1] "\nNov. 19, 22:54:04 UTC\t\tUniversal Time\nNov. 19, 05:54:04 PM EST\t\tEastern Time\nNov. 19, 04:54:04 PM CST\t\tCentral Time\nNov. 19, 03:54:04 PM MST\t\tMountain Time\nNov. 19, 02:54:04 PM PST\t\tPacific Time\nNov. 19, 01:54:04 PM AKST\tAlaska Time\nNov. 19, 12:54:04 PM HAST\tHawaii-Aleutian Time\n"

# convert the single-item list to a char vector
#
timeblock_vector <- timeblock_list[[1]]
# > class(timeblock_vector)
# [1] "character"
# timeblock_vector
# [1] "\nNov. 19, 22:54:04 UTC\t\tUniversal Time\nNov. 19, 05:54:04 PM EST\t\tEastern Time\nNov. 19, 04:54:04 PM CST\t\tCentral Time\nNov. 19, 03:54:04 PM MST\t\tMountain Time\nNov. 19, 02:54:04 PM PST\t\tPacific Time\nNov. 19, 01:54:04 PM AKST\tAlaska Time\nNov. 19, 12:54:04 PM HAST\tHawaii-Aleutian Time\n"

# split out each time field into a list then convert to a multi-member char vector
#
times_list <- strsplit(timeblock_vector, "\n")
times_vector <- times_list[[1]]
# [1] ""                                                "Nov. 19, 22:54:04 UTC\t\tUniversal Time"        
# [3] "Nov. 19, 05:54:04 PM EST\t\tEastern Time"        "Nov. 19, 04:54:04 PM CST\t\tCentral Time"       
# [5] "Nov. 19, 03:54:04 PM MST\t\tMountain Time"       "Nov. 19, 02:54:04 PM PST\t\tPacific Time"       
# [7] "Nov. 19, 01:54:04 PM AKST\tAlaska Time"          "Nov. 19, 12:54:04 PM HAST\tHawaii-Aleutian Time"

# Next, filter the vector to remove empty entries.
# first create a vector map where each index is T if we want to keep it or F if we want to drop it
# then use that map to filter the vector
filter <- times_vector != ""

times <- times_vector[filter]
# [1] "Nov. 19, 22:54:04 UTC\t\tUniversal Time"         "Nov. 19, 05:54:04 PM EST\t\tEastern Time"       
# [3] "Nov. 19, 04:54:04 PM CST\t\tCentral Time"        "Nov. 19, 03:54:04 PM MST\t\tMountain Time"      
# [5] "Nov. 19, 02:54:04 PM PST\t\tPacific Time"        "Nov. 19, 01:54:04 PM AKST\tAlaska Time"         
# [7] "Nov. 19, 12:54:04 PM HAST\tHawaii-Aleutian Time"

# convert those text dates & times to a POSIX date class
#
parse_date_time(times,"b. d, I:M:S p")
# [1] "2016-11-19 22:54:04 UTC" "2016-11-19 05:54:04 UTC" "2016-11-19 04:54:04 UTC" "2016-11-19 03:54:04 UTC"
# [5] "2016-11-19 02:54:04 UTC" "2016-11-19 01:54:04 UTC" "2016-11-19 12:54:04 UTC"
