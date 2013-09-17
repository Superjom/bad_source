heap_sort_objects=utils.o heapsort.o test.o

heapsort_file_objects=utils.o heapsort.o heapsort_file.o

test_method_objects=utils.o test_method.o heapsort.o

heapsort_file: $(heapsort_file_objects)
	cc -o heapsort_file $(heapsort_file_objects)

test_heapsort: $(heap_sort_objects)
	cc -o test_heapsort $(heap_sort_objects)

test_method: $(test_method_objects)
	cc -o test_method $(test_method_objects)


test.o:unitest/test.c
	cc -c unitest/test.c

test_method.o:unitest/test_method.c
	cc -c unitest/test_method.c

.PHONY: clean all
clean:
	rm *.o
all: test_method test_heapsort heapsort_file
