#set terminal postscript eps enhanced color size 3.9,2.9
set terminal postscript eps enhanced color size 3.9,2.9

set key samplen 2 spacing 1 font ",16"
set key left top

set xtics font ",16"
set ytics font ",16"
set ylabel font ",22"
set xlabel font ",22"

set xlabel "Number of Elements"
set ylabel "Speed Up"

set yrange[0:]
set ytic auto

set boxwidth 1 relative
set style data histograms
set style histogram cluster
set style fill pattern border

#plot 'speedup.out' u 2:xticlabels(1) title "Baseline",\
#'' u 3 title "Policy(A)" fillstyle pattern 7,\
#'' u 4 title "Policy(B)" fillstyle pattern 12,\
#'' u 5 title "Policy(C)" fillstyle pattern 14

set output "Speedup_plot.eps"
plot 'Speedup_Data.txt' u 3:xticlabels(1) title "1 Thread" fillstyle pattern 2,\
                       '' u 7 title "2 Threads" fillstyle pattern 4,\
                       '' u 11 title "4 Threads" fillstyle pattern 5,\
                       '' u 15 title "8 Threads" fillstyle pattern 6,\
                       '' u 19 title "16 Threads" fillstyle pattern 17
