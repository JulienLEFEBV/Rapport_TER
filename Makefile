CC_TYPST = typst

SOURCE = rapport
SOURCE_EXT = typ

OUT = rapport
OUT_EXT = pdf

all: build

build:
	$(CC_TYPST) compile $(SOURCE).$(SOURCE_EXT) $(OUT).$(OUT_EXT)

watch:
	$(CC_TYPST) watch $(SOURCE).$(SOURCE_EXT) $(OUT).$(OUT_EXT)

clean:
	rm -f $(OUT).$(OUT_EXT)

info:
	@echo CC_TYPST = $(CC_TYPST)
	@echo SOURCE = $(SOURCE)
	@echo SOURCE_EXT = $(SOURCE_EXT)
	@echo OUT = $(OUT)
	@echo OUT_EXT = $(OUT_EXT)

.PHONY: all build watch clean info