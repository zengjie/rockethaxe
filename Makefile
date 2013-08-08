
BIN_DIR=export/


all: $(BIN_DIR) test

$(BIN_DIR):
	mkdir $(BIN_DIR)


#-----------------------------------------------------------------------
#-------------------------------------------------------

$(BIN_DIR)TestDoubleLinkedList-debug: \
                com/rocketshipgames/haxe/ds/DoubleLinkedList.hx \
                com/rocketshipgames/haxe/ds/DoubleLinkedListHandle.hx \
                tests/src/TestDoubleLinkedList.hx \
                tests/data/TestDoubleLinkedList.out
	haxe -cp com -cp tests/src/ -cpp $(BIN_DIR) -debug -main TestDoubleLinkedList -D debug -D verbose -D verbose_ds
#	haxe -cp com -cp tests -swf export/TestDoubleLinkedList.swf -debug -main TestDoubleLinkedList


#-----------------------------------------------------------------------
#-------------------------------------------------------
test: $(BIN_DIR)TestDoubleLinkedList-debug
	./export/TestDoubleLinkedList-debug | diff -q tests/data/TestDoubleLinkedList.out -


#-----------------------------------------------------------------------
#-------------------------------------------------------
clean:
	rm -rf $(BIN_DIR)

.PHONY: all test clean
