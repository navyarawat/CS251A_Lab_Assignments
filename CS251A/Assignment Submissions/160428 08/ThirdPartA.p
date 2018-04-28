#set term postscript eps enhanced monochrome 20 dashed dashlength 1 lw 1.5
set terminal postscript eps enhanced color

set key samplen 2 spacing 1 font ",16"
set key left top

set xtics font ",16"
set ytics font ",16"
set ylabel font ",22"
set xlabel font ",22"

set logscale x
set logscale y 2
set xlabel "Number of Elements (logscale 10)"
set ylabel "Execution Time (logscale 2)"
set yrange[100:100000]
set xrange[1:10000000]
set ytic auto
set xtic auto

#outputfile and inputfile defined in the makefile
set output outputfile
plot inputfile using 1:2 title Title with points pt 1 ps 1.5
