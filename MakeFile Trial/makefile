all: app.ex1 Input.txt answers.txt

OBJS = prog.o
new_files = Input.txt answers.txt app.ex1

app.ex1: $(OBJS)
	gcc $(OBJS) -o app.ex1
prog.o: Binary_Search.c
	gcc -c Binary_Search.c -o prog.o

Input.txt: Format_Input.py Lists.txt
	python Format_Input.py Lists.txt

answers.txt: Execute.sh Input.txt app.ex1
	./Execute.sh Input.txt app.ex1

open: answers.txt
	open answers.txt

clean:
	rm -f *.o $(new_files)
