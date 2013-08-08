
BIN_DIR=export/


all: $(BIN_DIR) test

$(BIN_DIR):
	mkdir $(BIN_DIR)


#-----------------------------------------------------------------------
#-------------------------------------------------------

$(BIN_DIR)TestDoubleLinkedList-debug: \
                com/rocketshipgames/haxe/ds/DoubleLinkedList.hx \
                com/rocketshipgames/haxe/ds/DoubleLinkedListHandle.hx \
                com/rocketshipgames/haxe/ds/Heap.hx \
                tests/src/TestDoubleLinkedList.hx
	haxe -cp com -cp tests/src/ -cpp $(BIN_DIR) -debug -main TestDoubleLinkedList -D debug -D verbose -D verbose_ds
#	haxe -cp com -cp tests -swf export/TestDoubleLinkedList.swf -debug -main TestDoubleLinkedList

$(BIN_DIR)TestHeap-debug: \
                com/rocketshipgames/haxe/ds/Heap.hx \
                tests/src/TestHeap.hx
	haxe -cp com -cp tests/src/ -cpp $(BIN_DIR) -debug -main TestHeap -D debug -D verbose -D verbose_ds


#-----------------------------------------------------------------------
#-------------------------------------------------------
test: $(BIN_DIR)TestDoubleLinkedList-debug \
      $(BIN_DIR)TestHeap-debug
	./export/TestDoubleLinkedList-debug | diff -q tests/data/TestDoubleLinkedList.out -
	./export/TestHeap-debug | diff -q tests/data/TestHeap.out -


#-----------------------------------------------------------------------
#-------------------------------------------------------
clean:
	rm -rf $(BIN_DIR)

.PHONY: all test clean
