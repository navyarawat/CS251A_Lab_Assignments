set terminal postscript eps enhanced color size 3.9,2.9

set key samplen 2 spacing 1 font ",16"
set key left top

set xtics font ",16"
set ytics font ",16"
set ylabel font ",22"
set xlabel font ",22"

set xlabel "Number of Elements"
set ylabel "Speed Up (log scale base 2)"

set logscale y 2
set yrange[0:100000000]
set ytic auto

set boxwidth 1 relative
set style data histograms
set style histogram cluster
set style fill pattern border
set style histogram errorbars lw 3
set style data histogram

set output "Speedup_Errorbar.eps"
plot 'Speedup_Data.txt' u 3:4:xticlabels(1) title "1 Thread" fillstyle pattern 2,\
                       '' u 7:8 title "2 Threads" fillstyle pattern 4,\
                       '' u 11:12 title "4 Threads" fillstyle pattern 5,\
                       '' u 15:16 title "8 Threads" fillstyle pattern 6,\
                       '' u 19:20 title "16 Threads" fillstyle pattern 17
