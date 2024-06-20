# SelectIndividual-byTemperature

MoveApps

Github repository: *https://github.com/alerte-telemetrie/SelectIndividual-byTemperature*

## Description
Takes an end date (default NOW) and filters on all locations within the last X hours (default 24 hours). Retrieves the minimum temperature recorded by the tag during this period and extracts the names of individuals with a temperature below a defined minimum temperature threshold (default 5°C).

## Documentation
The purpose of this function is to identify individuals tracked by telemetry whose tags have recorded an extremely low temperature (°C) over the last predefined hours. The minimum temperature recorded by the tags over the last X hours is retrieved. If the minimum temperature is below a user-defined threshold, a table is extracted with the individual's movebank identifier.

### Input data
MoveStack in Movebank format

### Output data
MoveStack in Movebank format

### Artefacts
`Low_Temperature_Animals.csv`: csv-file with Table of all individuals whose tag recorded a temperature below the defined threshold.

### Settings 
Reference timestamp (time_now): reference/end timestamp towards which the data selection is performed. Generally (and by default) this is NOW, especially if in the field and looking for one or the other animal. When analysing older data sets, this parameter can be set to other timestamps so that the to be plotted data fall into a selected back-time window.

Duration of data to select (dur): Duration number of the data to be selected. Unit hours. Default 24.

Low temperature threshold (low_temp): Temperature below which a temperature measurement taken by the beacon will be considered extremely low. Unit °C. Default 5.

### Null or error handling
Setting time_now: If this parameter is left empty (NULL) the reference time is set to NOW. The present timestamp is extracted in UTC from the MoveApps server system.

Setting dur: Duration NULL defaults to 24 (hours).

Setting low_temp: Temperature NULL defaults to 5 (°C).

Artefacts: If no individual has had a temperature below the predefined threshold in the last X hours, then no csv file is extracted.
