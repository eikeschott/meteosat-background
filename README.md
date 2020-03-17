## Introduction

I wanted to automate the process of updating my background images so I decided to write a script around the enhanced natural color images of the Meteosat satellite which are provided by EUMETSAT on [their website](https://eumetview.eumetsat.int/static-images/MSG/RGB/NATURALCOLORENHNCD/FULLRESOLUTION/index.html). 

## Implementation

Basically the workflow is:

- downloading the latest image
- detect the date string in the bottom right corner with [gocr](https://www-e.uni-magdeburg.de/jschulen/ocr/)
- rename the file and make it the desktop background


![](images/2019_07_15.gif)
