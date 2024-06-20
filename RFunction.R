library('move2')
library('lubridate')
library('logger')

# dur = duration (in hours)
# low_temp = threshold below which a temperature is considered extremely low (in °C)

data <- readRDS("C:/Users/typhaine.rousteau/OneDrive - LPO/MoveApps/SelectIndividual-byTemperature/SelectIndividual-byTemperature/tests/testthat/data/input3_move2loc_LatLon.rds")

rFunction = function(data, time_now = NULL, dur = 24, low_temp = 5)
  {
    Sys.setenv(tz = "UTC") 
  
    if (is.null(time_now)) time_now <- Sys.time() else time_now <- as.POSIXct(time_now, format = "%Y-%m-%d %H:%M:%OS", tz = "UTC")
   
     log_info(paste("You have selected the data of the last", dur,"hours starting from", time_now, "(UTC)."))
    
     startTime <- time_now - lubridate::hours(dur)

     # Splits the stack to account for various individuals
     splitStack <- split(data, mt_track_id(data))
    
     # Helper function to analyse the different stacks separately
     helperFunction = function(splitMoveStack) {
      
      # Initializes the variables
      Ind <- c()
      Min_temp <- c()
      
      # data of the defined last hours
      data_dur <- splitMoveStack[which(splitMoveStack$timestamp > startTime ), ]
      
      # For ornitela tags ------------------------------------------------------
      ornitela_data <- data_dur[which(!is.na(data_dur$external_temperature)), ]
      
      if(nrow(data_dur) > 0 & nrow(ornitela_data) > 0) { 
        
        # Gets min temperature
        data_dur <- data_dur[which(data_dur$ornitela_transmission_protocol == "GPRS"),]
        min_temp <- as.numeric(min(data_dur$external_temperature))
        
        # Is the temperature over the last defined hours below the minimum temperature threshold ?
        if( min_temp <- low_temp) {
            Min_temp <- append(Min_temp, min_temp)
            Ind <- append(Ind, unique(mt_track_id(splitMoveStack)))
        }
        
      }
      
      # For other tags ---------------------------------------------------------
      other_data <- data_dur[which(!is.na(data_dur$eobs_temperature)), ]
      
      if(nrow(data_dur) > 0 & nrow(other_data) > 0) { 
        
        # Gets min temperature
        min_temp <- as.numeric(min(data_dur$eobs_temperature))
        
        # Is the temperature over the last defined hours below the minimum temperature threshold ?
        if(min_temp <- low_temp) {
           Min_temp <- append(Min_temp, min_temp)
           Ind <- append(Ind, unique(mt_track_id(splitMoveStack)))
        }
        
      }
      
      return(data.frame(Ind, Min_temp, row.names=NULL))
     
      }
     
        output <- lapply(splitStack, helperFunction)	

        # Gathers the results in a data frame
        output <- do.call("rbind", output)
        
        if(nrow(output > 0)) {
          
          log_warn(paste("You have", nrow(output),"individuals whose tag recorded a temperature below", low_temp, "°C."))
          
          # Writes the csv
          write.csv(output, appArtifactPath("Low_Temperature_Animals.csv"), row.names = FALSE)
          
        } else {
          
          log_info("You have no individuals whose tag recorded a temperature below ", low_temp, "°C.")
          
        }
     
}
