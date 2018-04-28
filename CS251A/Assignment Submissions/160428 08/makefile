Thread_Data = Thread1.txt Thread2.txt Thread4.txt Thread8.txt Thread16.txt
Thread_Avg = AverageThread1.txt AverageThread2.txt AverageThread4.txt AverageThread8.txt AverageThread16.txt
Scatter_plots = t1.eps t2.eps t4.eps t8.eps t16.eps
CC = gcc
CFLAGS = -g -I. -DDBG
LDFLAGS = -lpthread -lm

all: app.ex1 op.txt analyse plot #report
App: app.ex1
runtest: op.txt
analyse: $(Thread_Data) $(Thread_Avg) Speedup_Data.txt
plot: plot_a plot_b plot_c plot_d
report: plot report.pdf

OBJS = prog.o thread_func.o

app.ex1: $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) -o app.ex1
prog.o: prog.c common.h
	$(CC) $(CFLAGS) $(LDFLAGS) -c prog.c -o prog.o
thread_func.o: thread_function.c common.h
	$(CC) $(CFLAGS) $(LDFLAGS) -c thread_function.c -o thread_func.o

op.txt: app.ex1 params.txt threads.txt
	./execute.sh params.txt threads.txt

Thread1.txt: op.txt
	python extract_data.py op.txt
Thread2.txt: op.txt
	python extract_data.py op.txt
Thread4.txt: op.txt
	python extract_data.py op.txt
Thread8.txt: op.txt
	python extract_data.py op.txt
Thread16.txt: op.txt
	python extract_data.py op.txt
AverageThread1.txt: Thread1.txt
	python Calculate\ Average.py $(Thread_Data)
AverageThread2.txt: Thread2.txt
	python Calculate\ Average.py $(Thread_Data)
AverageThread4.txt: Thread4.txt
	python Calculate\ Average.py $(Thread_Data)
AverageThread8.txt: Thread8.txt
	python Calculate\ Average.py $(Thread_Data)
AverageThread16.txt: Thread16.txt
	python Calculate\ Average.py $(Thread_Data)
Speedup_Data.txt: $(Thread_Avg)
	python Find\ Speedup.py $(Thread_Avg)

plot_a: $(Scatter_plots)
t1.eps: Thread1.txt
	gnuplot -e "inputfile='Thread1.txt'; outputfile='t1.eps'; Title='1 Thread'" ThirdPartA.p
t2.eps: Thread2.txt
	gnuplot -e "inputfile='Thread2.txt'; outputfile='t2.eps'; Title='2 Threads'" ThirdPartA.p
t4.eps: Thread4.txt
	gnuplot -e "inputfile='Thread4.txt'; outputfile='t4.eps'; Title='4 Threads'" ThirdPartA.p
t8.eps: Thread8.txt
	gnuplot -e "inputfile='Thread8.txt'; outputfile='t8.eps'; Title='8 Threads'" ThirdPartA.p
t16.eps: Thread16.txt
	gnuplot -e "inputfile='Thread16.txt'; outputfile='t16.eps'; Title='16 Threads'" ThirdPartA.p

plot_b: Average_Time_Plot.eps
Average_Time_Plot.eps: $(Thread_Avg)
	gnuplot ThirdPartB.p

plot_c: Speedup_plot.eps
Speedup_plot.eps: Speedup_Data.txt
	gnuplot ThirdPartC.p

plot_d: Speedup_Errorbar.eps
Speedup_Errorbar.eps: Speedup_Data.txt
	gnuplot ThirdPartD.p

report.pdf: report.tex
	pdflatex report.tex

clean:
	rm -f *.o app.ex1 op.txt output.txt $(Thread_Data) $(Thread_Avg) *.eps Speedup_Data.txt
	rm -f *.pdf *.log *.aux *.dvi
	clear

cplot:
	rm -f *.eps
