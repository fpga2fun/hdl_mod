##############################################################
## Purpose: Gnuplot script for Chap_Randomization/exercise4
# (c) by Greg Tumbush
#
# REVISION HISTORY:
# $Log: histogram.plt,v $
# Revision 1.1  2011/05/29 19:09:57  tumbush.tumbush
# Check into cloud repository
#
# Revision 1.1  2011/05/10 18:19:35  Greg
# Initial check-in
#
##############################################################

# this is a gnuplot script to plot a histgram of address.dat
# into 3 buckets, 0, 1:15, and 15
# To execute a script in gnuplot do gnuplot> load "histogram.plt"

clear
reset
set key off
set border 3
set auto
 
set xrange[0:16]
set xtics 0, 1, 15 offset 1.5

################################################################
# Uncomment the following 2 lines to print to file address.ps  #
################################################################
# set terminal postscript color
# set output "address.ps"
 
# Make some suitable labels.
set title "Occurrences of Address"
set xlabel "Address"
set ylabel "Occurrences"
 
set style histogram clustered gap 1
set style fill solid border -1
 
binwidth=1
set boxwidth binwidth
bin(x,width)=width*floor(x/width) + width/2.0
plot 'address.dat' using (bin($1,binwidth)):(1.0) smooth freq with boxes
