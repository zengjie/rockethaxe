
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

$(BIN_DIR)TestComponentContainer-debug: \
                com/rocketshipgames/haxe/ds/DoubleLinkedList.hx \
                com/rocketshipgames/haxe/ds/DoubleLinkedListHandle.hx \
                com/rocketshipgames/haxe/component/Component.hx \
                com/rocketshipgames/haxe/component/ComponentContainer.hx \
                com/rocketshipgames/haxe/component/ComponentHandle.hx \
                tests/src/TestComponentContainer.hx
	haxe -cp com -cp tests/src/ -cpp $(BIN_DIR) -debug -main TestComponentContainer -D debug -D verbose -D verbose_ds -D verbose_cmp

$(BIN_DIR)TestEntity-debug: \
                com/rocketshipgames/haxe/ds/DoubleLinkedList.hx \
                com/rocketshipgames/haxe/ds/DoubleLinkedListHandle.hx \
                com/rocketshipgames/haxe/component/Component.hx \
                com/rocketshipgames/haxe/component/ComponentContainer.hx \
                com/rocketshipgames/haxe/component/ComponentHandle.hx \
                com/rocketshipgames/haxe/component/Entity.hx \
                com/rocketshipgames/haxe/component/SignalDispatcher.hx \
                com/rocketshipgames/haxe/component/Signal.hx \
                com/rocketshipgames/haxe/component/StateKeeper.hx \
                com/rocketshipgames/haxe/component/State.hx \
                com/rocketshipgames/haxe/component/Scheduler.hx \
                com/rocketshipgames/haxe/component/Event.hx \
                tests/src/TestEntity.hx
	haxe -cp com -cp tests/src/ -cpp $(BIN_DIR) -debug -main TestEntity -D debug -D verbose -D verbose_ds -D verbose_cmp


#-----------------------------------------------------------------------
#-------------------------------------------------------
test: $(BIN_DIR)TestDoubleLinkedList-debug \
      $(BIN_DIR)TestHeap-debug \
      $(BIN_DIR)TestComponentContainer-debug \
      $(BIN_DIR)TestEntity-debug
	./export/TestDoubleLinkedList-debug | diff -q tests/data/TestDoubleLinkedList.out -
	./export/TestHeap-debug | diff -q tests/data/TestHeap.out -
	./export/TestComponentContainer-debug | diff -q tests/data/TestComponentContainer.out -
	./export/TestEntity-debug | diff -q tests/data/TestEntity.out -

#-----------------------------------------------------------------------
#-------------------------------------------------------
clean:
	rm -rf $(BIN_DIR)

.PHONY: all test clean
