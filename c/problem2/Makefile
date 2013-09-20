heap_sort_objects=utils.o heapsort.o test.o
heapsort_file_objects=utils.o heapsort.o heapsort_file.o
test_method_objects=utils.o test_method.o heapsort.o
test_buff_objects=utils.o buff.o test_buff.o

heapsort_file: $(heapsort_file_objects)
	cc -o heapsort_file $(heapsort_file_objects)

#   test  ------------------------------
test_heapsort: $(heap_sort_objects)
	cc -o test_heapsort $(heap_sort_objects)
test_method: $(test_method_objects)
	cc -o test_method $(test_method_objects)
test_buff: $(test_buff_objects)
	cc -o test_buff -g $(test_buff_objects)
test.o:unitest/test.c
	cc -c unitest/test.c
test_method.o:unitest/test_method.c
	cc -c unitest/test_method.c
test_buff.o:unitest/test_buff.c
	cc -c unitest/test_buff.c

.PHONY: clean all test gdb
clean:
	rm *.o
all: heapsort_file
test: test_method test_heapsort test_buff
gdb:
	cc -o test_buff -g utils.c buff.c unitest/test_buff.c
	cc -o test_losertree -g utils.c losertree.c unitest/test_losertree.c
