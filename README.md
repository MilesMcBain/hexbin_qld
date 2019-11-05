# hexbin_qld
An example of hexbinning for mapping using {h3jsr}, {dplyr}, {sf}, and {mapdeck} using public data on Queensland Road Crashes.

see `./hexbin.R`

## Road Crash Data License
This material is licensed under a Creative Commons - Attribution 3.0 Australia licence.
Creative Commons License
Department of Transport and Main Roads requests attribution in the following manner:
                                                                               © State of Queensland (Department of Transport and Main Roads) 2019. Updated data available at http://qldspatial.information.qld.gov.au/catalogue//

## Reproducibility

There is a lockfile in this repo that can allow you to run this script with the same R package versions as I had when I wrote it.

try: 

```r
remotes::install_github("milesmcbain/capsule")

capsule::run_callr(function() source("./hexbin.R"))
```
