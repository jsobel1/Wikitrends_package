#!/usr/bin/python

#Jobs writer and submitter 

import subprocess

import os

import re

header = """#!/bin/bash

#BSUB -L /bin/bash
#BSUB -o wiki.txt
#BSUB -e wiki.err
#BSUB -R rusage[mem=2000]
#BSUB -M 2000000

module add R/3.5.1;\n"""

count=0

with open('config_dates.txt') as f:
        for line in f:
               # if count ==1:
                #       break
        #line = f.readline()
                if not line == "\n":
                        if not (re.match('#', line)):
                                tg = line.rstrip("\n").split()
                                fo = open("".join(["day_",tg[1],"_job.sh"]),"w")
                                fo.write(header)
                               
                                fo.write("".join(["Rscript --vanilla Wiki_trends.R ",tg[0]," ",tg[1]," \n"]))
                                fo.close()

                                print(" ".join(['bsub','-q','normal','<',"".join(["day_",tg[1],"_job.sh"])]))
                                os.system(" ".join(['bsub','-q','normal','<',"".join(["day_",tg[1],"_job.sh"])]))
                                count=count+1


