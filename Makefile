
clean:
	rm -rf zig-out .zig-cache
.PHONY: clean

reset: 
	sudo rm -rf /opt/rum
	rm -rf ~/Library/Caches/Rum
.PHONY: reset
