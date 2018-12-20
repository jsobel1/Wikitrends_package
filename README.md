# Wikitrends_package
This code (not yet a clean package) allows to retrive the number of wikipedia (English) reverts per day. The job_submitter.py code allows to submit multiple LSF jobs to do several days in parallel. the file Wiki_trends_analysis.R allows to visualise weekly pattern for specific artilces and output a table of articles with the highest number of reverts in total.

## run a single day
`Rscript --vanilla Wiki_trends.R 20181213000000 20181212000000`

## several days in parallel
- make config file (see config_dates.txt)
- in a LSF cluster 
`python job_submitter.py`
