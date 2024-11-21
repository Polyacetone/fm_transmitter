EXECUTABLE = fm_transmitter
VERSION = 0.9.6
FLAGS = -Wall -O3 -std=c++11
TRANSMITTER = -fno-strict-aliasing -I/opt/vc/include
SRC_DIR = src
TARGET_DIR = target
OBJS = $(TARGET_DIR)/fm_transmitter.o $(TARGET_DIR)/mailbox.o $(TARGET_DIR)/wave_reader.o $(TARGET_DIR)/transmitter.o

ifdef GPIO21
	TRANSMITTER += -DGPIO21
endif

all: $(OBJS)
	g++ -o $(TARGET_DIR)/$(EXECUTABLE) $(OBJS) -L/opt/vc/lib -lm -lpthread -lbcm_host

$(TARGET_DIR)/mailbox.o: $(SRC_DIR)/mailbox.cpp $(SRC_DIR)/mailbox.hpp
	@mkdir -p $(TARGET_DIR)
	g++ $(FLAGS) -c $< -o $@

$(TARGET_DIR)/wave_reader.o: $(SRC_DIR)/wave_reader.cpp $(SRC_DIR)/wave_reader.hpp
	@mkdir -p $(TARGET_DIR)
	g++ $(FLAGS) -c $< -o $@

$(TARGET_DIR)/transmitter.o: $(SRC_DIR)/transmitter.cpp $(SRC_DIR)/transmitter.hpp
	@mkdir -p $(TARGET_DIR)
	g++ $(FLAGS) $(TRANSMITTER) -c $< -o $@

$(TARGET_DIR)/fm_transmitter.o: $(SRC_DIR)/fm_transmitter.cpp
	@mkdir -p $(TARGET_DIR)
	g++ $(FLAGS) -DVERSION=\"$(VERSION)\" -DEXECUTABLE=\"$(EXECUTABLE)\" -c $< -o $@

clean:
	rm -rf $(TARGET_DIR)

.PHONY: all clean