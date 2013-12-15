bitspace.o : bitspace.cpp bitspace.h NumListSpace.h
	g++ -c bitspace.cpp

NumListSpace.o : NumListSpace.cpp NumListSpace.h
	g++ -c NumListSpace.cpp

test.o : test.cpp bitspace.h 
	g++ -c test.cpp 

test : test.o bitspace.o NumListSpace.o
	g++ -o test test.o bitspace.o NumListSpace.o

.PHONY : clean
clean:
	rm test *.o
	rm *.log
