## Introduction

I wanted to automate the process of updating my background images so I decided to write a script around the enhanced natural color images of the Meteosat satellite which are provided by EUMETSAT on [their website](https://eumetview.eumetsat.int/static-images/MSG/RGB/NATURALCOLORENHNCD/FULLRESOLUTION/index.html). 

## Implementation

Basically the workflow is:

- downloading the latest image
- detect the date string in the bottom right corner with [gocr](https://www-e.uni-magdeburg.de/jschulen/ocr/)
- rename the file and make it the desktop background

## Usage

Just copy `background_standalone.sh` to a place where you want to run it and make sure it's executable ( `chmod +x /PATH/TO/background_standalone.sh` )

Optionally you can set up a [cron job](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/crontab.html) to automate the process. To edit your crontab type:

```bash
crontab -e
```

Add the line e.g.

```bash
25 * * * * /bin/bash /PATH/TO/background_standalone.sh
```

to run the script at minute 25 of every hour - ever.


![](images/2019_07_15.gif)
