# Define the compiler
CC = clang

# Define compile-time flags
CFLAGS = -fobjc-arc -framework Foundation -framework AVFoundation

# Define the source files
SRC = main.m

# Define the output executable
OUT = micacc

# Default target
all: $(OUT)

# Rule for building the executable
$(OUT): $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(OUT)

# Rule for cleaning up the project
clean:
	rm -f $(OUT)

.PHONY: all clean
