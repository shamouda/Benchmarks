#!/bin/bash

FileName=$1

tar xvzf "$FileName".tar

cd $FileName

NumNodes=`cat numNodes`
NumBenchNodes=`cat numBenchNodes`
NumDCs=`cat numDCs`

mkdir -p results-"$NumDCs"dcs-"$NumNodes"nodes-"$NumBenchNodes"benchNodes

BenchFile=`ls -l summary-* | awk -F "-" 'FNR==1 && /^summary/{print $2}' -`
ReadPortion=`ls -l summary-* | awk -F "[-:]" '/^summary/{print $3}' - | sort -nr`

cd ..

#Basho bench grapsh
for Read in $ReadPortion; do
    Rscript --vanilla priv/summary.r -i $FileName/summary-"$BenchFile"-"$Read"
    mv $FileName/summary-"$BenchFile"-"$Read"/summary.png $FileName/results-"$NumDCs"dcs-"$NumNodes"nodes-"$NumBenchNodes"benchNodes/overall-summary-"$Read".png
done

cd $FileName

# Read latencies
rm plots
AllFiles=""
I=1
sed -i '/output/d' ../script/plot/readlatencies.plot
OutName="results-"$NumDCs"dcs-"$NumNodes"nodes-"$NumBenchNodes"benchNodes/read_latencies.png"
sed -i "2i set output \"$OutName\"" ../script/plot/readlatencies.plot
sed -i '/set title/d' ../script/plot/readlatencies.plot
Title="Read Latencies - $NumDCs DCs - $NumNodes Nodes - $NumBenchNodes Bench Nodes"
sed -i "3i set title \"$Title\"" ../script/plot/readlatencies.plot
for Read in $ReadPortion; do
    AllFiles="summary"-$BenchFile-$Read"/read_latencies.csv "$AllFiles""
    #echo summary-"$BenchFile"-"$Read"/read_latencies.csv
    awk -f ../script/mergeLatencies.awk summary-"$BenchFile"-"$Read"/read_latencies.csv >> plots
    sed -i "${I} s/^/${I}, /" plots
    I=$(($I + 1))
done
sed -i "1i # read_ratio, min, mean, median, 95th, 99th, 99_9th, max" plots
gnuplot ../script/plot/readlatencies.plot

# Write latencies
rm plots
AllFiles=""
I=1
sed -i '/output/d' ../script/plot/readlatencies.plot
OutName="results-"$NumDCs"dcs-"$NumNodes"nodes-"$NumBenchNodes"benchNodes/write_latencies.png"
sed -i "2i set output \"$OutName\"" ../script/plot/readlatencies.plot
sed -i '/set title/d' ../script/plot/readlatencies.plot
Title="Write Latencies - $NumDCs DCs - $NumNodes Nodes - $NumBenchNodes Bench Nodes"
sed -i "3i set title \"$Title\"" ../script/plot/readlatencies.plot
for Read in $ReadPortion; do
    AllFiles="summary"-$BenchFile-$Read"/append_latencies.csv "$AllFiles""
    #echo summary-"$BenchFile"-"$Read"/read_latencies.csv
    awk -f ../script/mergeLatencies.awk summary-"$BenchFile"-"$Read"/append_latencies.csv >> plots
    sed -i "${I} s/^/${I}, /" plots
    I=$(($I + 1))
done
sed -i "1i # read_ratio, min, mean, median, 95th, 99th, 99_9th, max" plots
gnuplot ../script/plot/readlatencies.plot

# Throughput
rm plots
AllFiles=""
I=1
sed -i '/output/d' ../script/plot/summary.plot
OutName="results-"$NumDCs"dcs-"$NumNodes"nodes-"$NumBenchNodes"benchNodes/summary_overall.png"
sed -i "2i set output \"$OutName\"" ../script/plot/summary.plot
sed -i '/set title/d' ../script/plot/summary.plot
Title="Throughput - $NumDCs DCs - $NumNodes Nodes - $NumBenchNodes Bench Nodes"
sed -i "3i set title \"$Title\"" ../script/plot/summary.plot
for Read in $ReadPortion; do
    AllFiles="summary"-$BenchFile-$Read"/summary.csv "$AllFiles""
    #echo summary-"$BenchFile"-"$Read"/read_latencies.csv
    awk -f ../script/mergeSummaries.awk summary-"$BenchFile"-"$Read"/summary.csv >> plots
    sed -i "${I} s/^/${I}, /" plots
    I=$(($I + 1))
done
sed -i "1i # total, successful, failed" plots
gnuplot ../script/plot/summary.plot

