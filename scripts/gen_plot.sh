#!/bin/sh
# this is a GNUPLOT script to take the website download data and create a
#  graphical overview png file
#
# Parkview August 2009
# src: http://www.bdug.org.au/project/raspberrypi/gnuPlot-temperatures

. $(dirname "$0")/CONFIG 

# Local Variables
DATA_SRC="$DATA_DIR/log.csv"
DATAFILE_IN1="/tmp/temp.THN132N.dat"
DATAFILE_IN2="/tmp/temp.OSv1.dat"
PNG="/tmp/plot.png"
MINY=13
MAXY=41
MYTICS=2
COLOR1="#AA0000"
COLOR2="#000066"
VALUES=20000

# prep data
tac $DATA_SRC | head -$VALUES | grep THN132N | cut -d , -f 1,6 | uniq > $DATAFILE_IN1
tac $DATA_SRC | head -$VALUES | grep OSv1 | cut -d , -f 1,6 | uniq > $DATAFILE_IN2

# extract the required data from the csv file
SDATE=`tail -1 $DATAFILE_IN1 | cut -d"," -f1`
EDATE=`head -1 $DATAFILE_IN1 | cut -d"," -f1`

# Now go and plot the graph
/usr/bin/gnuplot << EOF
set datafile separator ","
set style fill solid border -1
set style line 1 lt 2 lw 1
set pointsize .5
set sample 45
set terminal png size 1024,400
set terminal png
set output "$PNG"
set xlabel "Date - Time"
set ylabel "Grad C"
set title "Temperaturverlauf"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%d %h\n%H:%M"
set xrange [ "$SDATE":"$EDATE" ]
#set xrange [ "$EDATE":"$SDATE" ]
set timefmt "%Y-%m-%d %H:%M:%S"
set yrange [ * : * ]
#set yrange [ $MINY : $MAXY ]
set xtics border out scale 2
set ytics out mirror $MYTICS
set mxtics 4
set mytics 2
set grid x y
plot "$DATAFILE_IN1"  using 1:2 title "THN132N" with lines lc rgb "$COLOR1" , "$DATAFILE_IN2" using 1:2 title "OSv1 Temperature Sensor" with lines lc rgb "$COLOR2"
EOF
