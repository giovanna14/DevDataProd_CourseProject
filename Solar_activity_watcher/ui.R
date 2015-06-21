library(shiny)
library(shinythemes)

imageset  <- c("EIT 171","EIT 195","EIT 284","EIT 304","LASCO C2","LASCO C3") 

# Define UI for application that shows latest satellite images and daily movies of the Sun
# and allows to choose instrument/wavelength for the images and date of the daily
# movie to be displayed. 

shinyUI(fluidPage(theme=shinytheme("spacelab"),

  # Application title
  titlePanel("Solar activity watcher"),

  # Sidebar with an input selection list for instrument/wavelength
  # and slider input for date selection
  sidebarLayout(
      sidebarPanel(
             helpText("Select the latest", a("SOHO", href="http://sci.esa.int/soho/"), 
                 "images of the Sun you wish to display. Multiple choices are possible. 
                  The available ones are:",
                 br(), 
                 "EIT observations at wavelengths 171, 195, 284, and 304 Angstrom
                  and", a("LASCO",href="http://lasco-www.nrl.navy.mil/index.php"), 
                 "observations with the telescopes C2 and C3.",
                 br(), 
                 "The selected images are displayed in the 'SOHO Latest Images' tab,
                  after pressing the 'Submit request' button."),
             selectInput("images", "SOHO Latest Images", imageset, 
	          selected= c("EIT 171","LASCO C2"), multiple=TRUE),        
             br(),
             helpText("Daily movies of observations of the solar corona made with the C2 
                  and C3 LASCO telescopes
                  aboard SOHO are available from Jan 10th, 1996 to the present.",
                  br(),
                 "Select the date of your interest from the calendar below and
                  press 'Submit request' for the selection to take effect.",
                  br(),
                 "Movies are displayed in the 'LASCO Daily Movies' tab."),
             dateInput("day","LASCO Daily Movie Date",value="2015-05-14",min="1996-01-10",
                  startview="decade"),
             br(),
             submitButton(text="Submit request", icon=NULL)		  
      ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Description",
	  fluidRow(
            h3("Usage of the app"),
            p("This web-app allows the user to view:",br(),
              "1) a choice of the latest images of the Sun as 
               obtained by the Extreme ultraviolet Imaging Telescope,", 
               a("EIT",href="http://umbra.nascom.nasa.gov/eit/"), 
	       " and Large Angle and Spectrometric Coronograph Experiment", 
	       a("LASCO", href="http://lasco-www.nrl.navy.mil/index.php"), 
	       "instruments aboard the", a("ESA",href="http://www.esa.int/"),"/",
	       a("NASA",href="http://www.nasa.gov/"), 
               "Solar and Heliospheric Observatory",
	       a("SOHO",href="http://sohowww.nascom.nasa.gov/"),";", 
	       br(), 
              "2) daily movies of the solar corona produced by the LASCO team since 
	      the start of operations in 1996.",
               br(), 
#              "3) movies of the Sun during the latest 48 hours at various wavelengths from the 
#                NASA Solar Dynamics Observatory", a("SDO",href="http://sdo.gsfc.nasa.gov/"),br(),
              "Images and dates of the movies to be displayed can be selected on the 
               side-panel. Selections affecting both data product types listed above
               take effect upon clicking on the 'Submit request' button."
	     ),
            h4("Selection items"),
            p("On the side-panel on the left, the user can choose one or more of the SOHO 
	      latest images to be displayed from the 'Latest SOHO Images' list. EIT images 
	      are available at 4 different wavelengths in the extreme ultraviolet range: 
	      171, 195, 284, and 304 Angstrom. 
              LASCO images are available at two wavelengths, observed with the telescopes 
	      C2 and C3, respectively. In LASCO images, the view to the Sun itself is blocked 
	      and only the solar corona is visible. User-selected images are shown in the 
	      'SOHO Latest Images' tab on the main panel.",
	      br(),
              "LASCO movies of observations with the C2 and C3 telescopes are shown in the
               'LASCO Daily Movies' tab for the date selected by the user from the 
	       'LASCO Daily Movie Date' calendar on the side-panel. Movies start playing 
	       automatically after a request submission and stop after 22 cycles. They are 
	       in mpg format, hence they require a suitable browser plugin.",
	       br(),
	       "Examples of movies and images are available in the 'Examples' tab."
## the text below is for future implementation of additional features:		 
#                "Finally from the 'SDO Movies' list on the side-panel it is possible to select the 
#                 wavelength of the observations with the Atmospheric Imaging Assembly (AIA) and 
#                 Helioseismic and Magnetic Imager (HMI) instruments aboard SDO, 
#                 for which the latest 48-hours movie of the Sun will be shown in the 'SDO movies' tab. 
#                 Besides the same wavelengths available for SOHO EIT, the following choices are possible: TBC"
              ),
             h4("Acknowledgements"),
	     p("This application makes use of publicly available data products from the 
	        SOHO Science Archive, accessed through the SOHO Archive
	        Inter-Operability Subsystem", a("SAIO", 
		href="http://ssa.esac.esa.int/ssa/aio/html/home_main.shtml"),
	        "developed by the ESAC Science Archives Team, and from the ", 
		a("LASCO", href="http://lasco-www.nrl.navy.mil/index.php"), "team.",
		br(),
		"The SOHO/LASCO data used here are produced by a consortium of the Naval Research 
		Laboratory (USA), Max-Planck-Institut fuer Aeronomie (Germany), Laboratoire 
		d'Astronomie (France), and the University of Birmingham (UK). SOHO is a project 
		of international cooperation between ESA and NASA." 
		),
             h4("Resources"),
	     p("The Solar and Heliospheric Observatory (SOHO) is a space observatory realized and 
	        operated by the European Space Agency (ESA) 
		and US National Aeronautics and Space Administration (NASA). 
		Its goal is to study the physical properties of the Sun including its interior,
		its visible surface, and its atmosphere. Data concerning solar flares and 
		coronal mass ejections are collected by SOHO and are helpful for the prediction
		of space weather events such as magnetic storms that can affect our planet. 
		Details about the SOHO mission and informative articles for the public about space
		weather in connection with effects on the Earth and human activities, as well as
		links to scientific information can be found
		in the dedicated", a("space science",
		href="http://www.esa.int/Our_Activities/Space_Science/SOHO_overview2"),
		" pages of the ESA Web Portal and in", a("ESA's SOHO home page",
		href="http://sohowww.estec.esa.nl/about/about.html"), "."
	      )
	  )
	),
        tabPanel("SOHO Latest Images",
            p("You have selected the following latest images of the Sun:"),
            textOutput("choices"),
            p("Images are retrieved on the fly from SOHO archive, they may take",
	      "some time to load. Should the archive server be too busy or",
	      "unreachable, submit the request again after a few minutes."),  
            br(),   
            column(5,
                textOutput("title1"),
                htmlOutput("request1"),
                textOutput("title3"),
                htmlOutput("request3"),
                textOutput("title5"),
                htmlOutput("request5")
                   ),
            column(5,offset=1,
                textOutput("title2"),
                htmlOutput("request2"),
                textOutput("title4"),
                htmlOutput("request4"),
                textOutput("title6"),
                htmlOutput("request6")
                   )         
        ),
	tabPanel("LASCO Daily Movies",
            p("Daily movies of observations with LASCO telescopes C2 and C3
               for the selected date:"),
            textOutput("chosendate"),
            br(),
            p("Note: After first loading, movies are set to play in a loop for
               22 times. For some dates, movies with one or both
               telescopes may be very short or unavailable, especially in
               the first few years of operation of the instrument."),
            br(),
            column(5,
                   htmlOutput("movie1")
            ),
            column(5,offset=1,
                   htmlOutput("movie2")  
            )
        ),       
	tabPanel("Examples",
	   fluidRow(
	        p("Examples of daily movies and images from observations with the 
		  LASCO and EIT instruments aboard SOHO.
	          Daily movies are in mpg format, hence they require an appropriate 
		  browser plugin."
	        ),
	       column(5,
                h5("Coronal Mass Ejection - LASCO C3 daily movie 14/04/2015"),
	        HTML('<embed src="150414_c2.mpg" width="270" height="270" autostart="true" playcount="5" loop="3" frameborder="0"></embed>'),
	        h5("EIT wavelength 171 Angstrom"),
	        img(src='EIT171.jpg',height=270,width=270),
	        h5("EIT wavelength 284 Angstrom"),
	        img(src='EIT284.jpg',height=270,width=270),
	        h5("LASCO C2"),
                img(src='LASCO_C2.jpg',align="center",height=270,width=270)
	        ),
	       column(5,offset=1,
                h5("Coronal Mass Ejection - LASCO C3 daily movie 14/04/2015"),
	        HTML('<embed src="150414_c3.mpg" width="270" height="270" autostart="true" playcount="5" loop="3" frameborder="0"></embed>'),
	        h5("EIT wavelength 195 Angstrom"),
	        img(src='EIT171.jpg',height=270,width=270),
	        h5("EIT wavelength 304 Angstrom"),
	        img(src='EIT304.jpg',height=270,width=270),
	        h5("LASCO C3"),
                img(src='LASCO_C3.jpg',align="center",height=270,width=270)
	       )
	   )
        )
      )
    )
  )
))
