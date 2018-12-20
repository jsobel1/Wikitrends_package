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
                                #print tg[0]#re.search("(\S*)\.sam$",line, re.M|re.I)
                                fo = open("".join(["day_",tg[1],"_job.sh"]),"w")
                                fo.write(header)
                               # fo.write("".join(["trimmomatic PE -phred33 ",tg[1]," ",tg[2]," ",tg[0],"_R1_P.fastq.gz ",tg[0],"_R1_U.fastq.gz ",tg[0],"_R2_P.fastq.gz ",tg[0],"_R2_U.fastq.gz ","ILLUMINACLIP:NexteraPE-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 \n"]))
                                #fo.write(line)
                                #trimmomatic PE -phred33 P10_1_R1.fastq.gz  P10_1_R2.fastq.gz P10_1_R1_P.fastq.gz P10_1_R1_U.fastq.gz P10_1_R2_P.fastq.gz P10_1_R2_U.fastq.gz ILLUMINACLIP:NexteraPE-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
                                #bwa mem ../../Rn5_assembly/Genome/rn5.fa Adult_4_R1_P.fastq.gz Adult_4_R2_P.fastq.gz > Adult_4.sam
                                #fo.write("".join(["bwa mem ../../Rn5_assembly/Genome/rn5.fa ",tg[0],"_R1_P.fastq.gz ",tg[0],"_R2_P.fastq.gz "," > ",tg[0],".sam \n"]))
                                fo.write("".join(["Rscript --vanilla Wiki_trends.R ",tg[0]," ",tg[1]," \n"]))
                                fo.close()

                                print(" ".join(['bsub','-q','normal','<',"".join(["day_",tg[1],"_job.sh"])]))
                                os.system(" ".join(['bsub','-q','normal','<',"".join(["day_",tg[1],"_job.sh"])]))
                                count=count+1
#subprocess.run(['bsub','-q','normal','<',"".join([tg.group(1),"_job.sh"])])

