library(shiny)
library(lubridate)

## Define some variables depending on dataset

# definitions for LASCO movies
refdate <<- as.Date("2015-04-14")
specialdates <<- as.Date(c("2010-01-29","2010-01-30","2010-01-31","2015-01-30"))
dates96 <<- as.character(c(10:24,26:29))
specialdates96 <<- as.Date(c(paste0("1996-01-",dates96)))
mnames <- c("movieC2","movieC3")
movieext <- ".mpg"

# definitions for SOHO latest images
url1 <- "http://ssa.esac.esa.int/ssa/aio/product-action?RETRIEVALTYPE=LATEST_POSTCARD&FILTER="
url2 <- "&INSTRUMENT="
url3 <- "&RESOLUTION=512"
ext <- ".jpg"


## Define server logic required to retrieve from web and display selected images/movies

shinyServer(function(input, output, session) {


## Reactively render a list of selected SOHO images

    output$choices <- renderText({
         input$images
    })

## Reactively create SOHO archive requests in html format for user selection
## and image titles to be displayed

    imagedata <- reactive({
         images <- input$images
         nIma <- length(images)
         list <- sapply(images, strsplit, split=" ")
         m <- matrix(unlist(list),ncol=2,byrow=TRUE)
         instr <- m[,1]
         filter <- m[,2]
         url <- paste0(url1,filter,url2,instr,url3)
	 # create temporary names for files to be downloaded to www directory
	 fileprefix <- paste0(instr,filter)
	 files <- tempfile(fileprefix, tmpdir="www",ext)
	 # download files
	 for (i in 1:length(files)){
	     download.file(url[i],files[i])}    
         if (nIma < 6){
         x <- 6 - nIma
         images <- c(images, rep("",x))
	 filenames <- c(basename(files), rep("",x))	 	 
         } else {
	 filenames <- basename(files)
	 }
         return(list(images,filenames))     
    })

## Render the html instructions to embed the requested images

     output$request1 <- renderUI({tags$embed(src=imagedata()[[2]][1],width="270",height="270")})
     output$request2 <- renderUI({tags$embed(src=imagedata()[[2]][2],width="270",height="270")})
     output$request3 <- renderUI({tags$embed(src=imagedata()[[2]][3],width="270",height="270")})
     output$request4 <- renderUI({tags$embed(src=imagedata()[[2]][4],width="270",height="270")})
     output$request5 <- renderUI({tags$embed(src=imagedata()[[2]][5],width="270",height="270")})
     output$request6 <- renderUI({tags$embed(src=imagedata()[[2]][6],width="270",height="270")})

## Render the image titles

     output$title1 <- renderText({imagedata()[[1]][1]})
     output$title2 <- renderText({imagedata()[[1]][2]})
     output$title3 <- renderText({imagedata()[[1]][3]})
     output$title4 <- renderText({imagedata()[[1]][4]})
     output$title5 <- renderText({imagedata()[[1]][5]})
     output$title6 <- renderText({imagedata()[[1]][6]})
    
## Reactively define URLs of movies to be displayed depending on user-selected date 
  
     movie <- reactive({
           # transform input date to build URL of movie for that date
           day <- input$day
           x1 <- unlist(strsplit(as.character(day),"\\-"))
           x2 <- unlist(strsplit(as.character(format(day,format="%y-%m-%d")),"\\-"))
           # 4-digits year, 2-digits month and day
           yyyy <- x1[1]; mm <- x1[2]; dd <- x1[3]
           # 2-digits year
           yy <- x2[1]
	   # create temporary names for files to be downloaded to www directory
	   movienames <- tempfile(paste0(yy,mm,dd,mnames),tmpdir="www",movieext)
           if (day %in% specialdates96 & day < as.Date("1996-01-16")){
           movieC2URL <- ""
	   movienames[1] <- ""
           movieC3URL <- paste0("http://lasco-www.nrl.navy.mil/daily_mpg/",yyyy,"_",mm,"/",yy,mm,dd,"_c3or.mpg")
           } else if (day %in% specialdates96 & day >= as.Date("1996-01-16")){
           movieC2URL <- ""
	   movienames[1] <- ""
           movieC3URL <- paste0("http://lasco-www.nrl.navy.mil/daily_mpg/",yyyy,"_",mm,"/",yy,mm,dd,"_c3.mpg")
           } else if (day < refdate || day %in% specialdates){
           movieC2URL <- paste0("http://lasco-www.nrl.navy.mil/daily_mpg/",yyyy,"_",mm,"/",yy,mm,dd,"_c2.mpg") 
           movieC3URL <- paste0("http://lasco-www.nrl.navy.mil/daily_mpg/",yyyy,"_",mm,"/",yy,mm,dd,"_c3.mpg")          
           } else {
           movieC2URL <- paste0("http://lasco-www.nrl.navy.mil/daily_mpg/",yy,mm,dd,"_c2.mpg")
           movieC3URL <- paste0("http://lasco-www.nrl.navy.mil/daily_mpg/",yy,mm,dd,"_c3.mpg")
           }
	   movieURL <- c(movieC2URL,movieC3URL)
	   # download files
	   for (j in 1:length(movienames)){
	        if (!file.exists(movienames[j])){
		    download.file(movieURL[j],movienames[j])
		}
           }
           # strip "www/" path from filename
           movienames <- basename(movienames)
	   return(movienames)
    })

## Render text with chosen date for LASCO movies and html instructions to embed them

    output$chosendate <- renderText({as.character(input$day)}) 
    output$movie1 <- renderUI({
                              tags$embed(src=movie()[1], width= "270", height="270", autostart="TRUE",
                               playcount="5", loop="10", frameborder="0")
                     })
    output$movie2 <- renderUI({
                              tags$embed(src=movie()[2], width= "270", height="270", autostart="TRUE",
                               playcount="5", loop="10", frameborder="0")
                     })
})
