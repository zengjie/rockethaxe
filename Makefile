
BIN_DIR=export/


all: $(BIN_DIR) test

$(BIN_DIR):
	mkdir $(BIN_DIR)


#-----------------------------------------------------------------------
#-------------------------------------------------------

$(BIN_DIR)TestDoubleLinkedList/TestDoubleLinkedList-debug: \
                com/rocketshipgames/haxe/ds/DoubleLinkedList.hx \
                com/rocketshipgames/haxe/ds/DoubleLinkedListHandle.hx \
                com/rocketshipgames/haxe/ds/Heap.hx \
                com/rocketshipgames/haxe/ds/Deadpool.hx \
                com/rocketshipgames/haxe/ds/DeadpoolObject.hx \
                tests/src/TestDoubleLinkedList.hx
	haxe -cp com -cp tests/src/ -cpp $(BIN_DIR)TestDoubleLinkedList/ -debug -main TestDoubleLinkedList -D debug -D verbose -D verbose_ds
#	haxe -cp com -cp tests -swf export/TestDoubleLinkedList.swf -debug -main TestDoubleLinkedList

$(BIN_DIR)TestHeap/TestHeap-debug: \
                com/rocketshipgames/haxe/ds/Heap.hx \
                tests/src/TestHeap.hx
	haxe -cp com -cp tests/src/ -cpp $(BIN_DIR)TestHeap/ -debug -main TestHeap -D debug -D verbose -D verbose_ds

$(BIN_DIR)TestComponentContainer/TestComponentContainer-debug: \
                com/rocketshipgames/haxe/ds/DoubleLinkedList.hx \
                com/rocketshipgames/haxe/ds/DoubleLinkedListHandle.hx \
                com/rocketshipgames/haxe/ds/Deadpool.hx \
                com/rocketshipgames/haxe/ds/DeadpoolObject.hx \
                com/rocketshipgames/haxe/component/Component.hx \
                com/rocketshipgames/haxe/component/ComponentContainer.hx \
                com/rocketshipgames/haxe/component/ComponentHandle.hx \
                tests/src/TestComponentContainer.hx
	haxe -cp com -cp tests/src/ -cpp $(BIN_DIR)TestComponentContainer/ -debug -main TestComponentContainer -D debug -D verbose -D verbose_ds -D verbose_cmp

$(BIN_DIR)TestEntity/TestEntity-debug: \
                com/rocketshipgames/haxe/ds/DoubleLinkedList.hx \
                com/rocketshipgames/haxe/ds/DoubleLinkedListHandle.hx \
                com/rocketshipgames/haxe/ds/Deadpool.hx \
                com/rocketshipgames/haxe/ds/DeadpoolObject.hx \
                com/rocketshipgames/haxe/ds/Heap.hx \
                com/rocketshipgames/haxe/component/Component.hx \
                com/rocketshipgames/haxe/component/ComponentContainer.hx \
                com/rocketshipgames/haxe/component/ComponentHandle.hx \
                com/rocketshipgames/haxe/component/SignalDispatcher.hx \
                com/rocketshipgames/haxe/component/StateKeeper.hx \
                com/rocketshipgames/haxe/component/State.hx \
                com/rocketshipgames/haxe/component/Scheduler.hx \
                com/rocketshipgames/haxe/component/Event.hx \
                tests/src/TestEntity.hx
	haxe -cp com -cp tests/src/ -cpp $(BIN_DIR)TestEntity/ -debug -main TestEntity -D debug -D verbose -D verbose_ds -D verbose_cmp

$(BIN_DIR)TestJenkins/TestJenkins-debug: \
                com/rocketshipgames/haxe/util/Jenkins.hx \
                tests/src/TestJenkins.hx
	haxe -cp com -cp tests/src/ -cpp $(BIN_DIR)TestJenkins/ -debug -main TestJenkins -D debug -D verbose -D verbose_ds


#-----------------------------------------------------------------------
#-------------------------------------------------------
test: $(BIN_DIR)TestDoubleLinkedList/TestDoubleLinkedList-debug \
      $(BIN_DIR)TestHeap/TestHeap-debug \
      $(BIN_DIR)TestComponentContainer/TestComponentContainer-debug \
      $(BIN_DIR)TestEntity/TestEntity-debug \
      $(BIN_DIR)TestJenkins/TestJenkins-debug
	$(BIN_DIR)TestDoubleLinkedList/TestDoubleLinkedList-debug | diff -q tests/data/TestDoubleLinkedList.out -
	$(BIN_DIR)TestHeap/TestHeap-debug | diff -q tests/data/TestHeap.out -
	$(BIN_DIR)TestComponentContainer/TestComponentContainer-debug | diff -q tests/data/TestComponentContainer.out -
	$(BIN_DIR)TestEntity/TestEntity-debug | diff -q tests/data/TestEntity.out -
	$(BIN_DIR)TestJenkins/TestJenkins-debug | diff -q tests/data/TestJenkins.out -


#-----------------------------------------------------------------------
#-------------------------------------------------------
clean:
	rm -rf $(BIN_DIR)

.PHONY: all test clean
