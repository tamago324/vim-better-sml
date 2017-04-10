all: install

MLTON = mlton

support/def-use-util: support/*.sml support/def-use-util.mlb
	$(MLTON) -show-def-use support/def-use-util.du -prefer-abs-paths true support/def-use-util.mlb

.PHONY: install
install: support/def-use-util
	mkdir -p bin
	mv support/def-use-util bin

.PHONY: clean
clean:
	rm -rf bin
	rm -f support/def-use-util
