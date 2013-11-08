.PHONY: all clean watch dist release

TARGET := report
TEX := xelatex -shell-escape
COMMON_SRC :=
RELEASE_SRC := $(COMMON_SRC) output/report.pdf
DIST_SRC := $(COMMON_SRC) *.tex img Makefile

NULL :=
SPACE := $(NULL) $(NULL)
remove-space = $(subst $(SPACE),,$1)

all output/$(TARGET).pdf: output/report.tex output/1.tex output/_title.tex | output
	cd output && $(TEX) $(TARGET).tex

output/%: % | output
	cd output && ln -s ../$< .

output:
	mkdir $@

clean:
	$(RM) -r output

dist:
	tar zcf '/tmp/$(call remove-space,$(notdir $(CURDIR)))-dist.tar.gz' $(DIST_SRC) --exclude '.*'

release:
ifeq ($(words $(RELEASE_SRC)),1)
	cp -a $(RELEASE_SRC) '/tmp/$(call remove-space,$(notdir $(CURDIR)))-release.pdf'
else
	tar zcf '/tmp/$(call remove-space,$(notdir $(CURDIR)))-release.tar.gz' $(RELEASE_SRC) --exclude '.*' --transform 's,output/report.pdf,report.pdf,' --transform s,^,2011011269/,
endif

watch:
	llpp output/report.pdf &
	(inotifywait -mqe CLOSE_WRITE output/report.pdf | while read; do pkill -1 llpp; done) &
