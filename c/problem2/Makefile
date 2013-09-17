heap_sort_objects=utils.o heapsort.o test.o

test_heapsort: $(heap_sort_objects)
	cc -o test_heapsort $(heap_sort_objects)
test.o:unitest/test.c
	cc -c unitest/test.c

.PHONY: clean
clean:
	rm *.o
