.PHONY: all clean

all: yolo
	./yolo

clean:
	rm -f *.o yolo

yolo: $(wildcard *.m)
	clang -Werror -framework Foundation -o $@ $^
