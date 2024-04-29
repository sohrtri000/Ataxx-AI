CXX := g++
CXXFLAGS := -std=gnu++14 -MMD -MP -O3 -g -pg #-Wall -Wextra

INCLUDE_DIR := include
SOURCE_DIR := source
BUILD_DIR := build

SOURCES := $(wildcard $(SOURCE_DIR)/*.cc)
OBJECTS := $(patsubst $(SOURCE_DIR)/%.cc,$(BUILD_DIR)/%.o,$(SOURCES))
DEPENDENCIES := $(patsubst $(SOURCE_DIR)/%.cc,$(BUILD_DIR)/%.d,$(SOURCES))
TARGET := run.out

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) $(CXXFLAGS) $^ -o $@

$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.cc | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -I$(INCLUDE_DIR) -c $< -o $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	$(RM) -r $(BUILD_DIR) $(TARGET) analysis.txt gmon.out

run: $(TARGET)
	./$(TARGET)

debug: $(TARGET)
	gdb -ex run ./$(TARGET)

lint:
	cpplint --filter=-legal/copyright,-build/include,-build/namespaces,-runtime/explicit,-build/header_guard,-runtime/references,-runtime/threadsafe_fn $(shell find ./include/ ./source/ -type f -name '*.cc' -o -name '*.h')

-include $(DEPENDENCIES)
