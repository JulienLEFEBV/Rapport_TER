CC_TYPST = typst

SOURCE = rapport
SOURCE_EXT = typ

RAPPORT_OUT = rapport
RAPPORT_OUT_EXT = pdf

PRESENTATION_OUT = presentation
PRESENTATION_OUT_EXT = pdf

all: build_rapport build_presentation

build_rapport:
	$(CC_TYPST) compile $(SOURCE).$(SOURCE_EXT) $(RAPPORT_OUT).$(RAPPORT_OUT_EXT)


build_presentation:
	$(CC_TYPST) compile $(PRESENTATION_OUT).$(SOURCE_EXT) $(PRESENTATION_OUT).$(PRESENTATION_OUT_EXT)
	$(CC_TYPST) query $(PRESENTATION_OUT).$(SOURCE_EXT) --field value --one "<pdfpc-file>" > ./$(PRESENTATION_OUT).pdfpc

watch:
	$(CC_TYPST) watch $(SOURCE).$(SOURCE_EXT) $(RAPPORT_OUT).$(RAPPORT_OUT_EXT)

clean:
	rm -f $(RAPPORT_OUT).$(RAPPORT_OUT_EXT)

info:
	@echo CC_TYPST = $(CC_TYPST)
	@echo SOURCE = $(SOURCE)
	@echo SOURCE_EXT = $(SOURCE_EXT)
	@echo RAPPORT_OUT = $(RAPPORT_OUT)
	@echo RAPPORT_OUT_EXT = $(RAPPORT_OUT_EXT)

.PHONY: all build_rapport build_presentation watch clean info
