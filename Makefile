rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
PACKED := $(call rwildcard,build/opt/pdfstudioviewer2019/jre/lib,*.jar.pack)

SOURCE="https://download.qoppa.com/pdfstudioviewer/PDFStudioViewer_linux64.deb"
DESTINATION="build.deb"
OUTPUT="PDFStudioViewer.AppImage"

.PHONY: all
all: pack clean

pack: download
	echo "Building: $(OUTPUT)"
	rm -rf AppDir/opt

	mkdir --parents AppDir/opt
	cp -r build/* AppDir/

	chmod +x AppDir/AppRun

	export ARCH=x86_64 && bin/appimagetool.AppImage AppDir $(OUTPUT)

	chmod +x $(OUTPUT)

download:
	wget --output-document=$(DESTINATION) --continue $(SOURCE) --no-check-certificate
	dpkg -x $(DESTINATION) ./build
	make unpack -B

clean:
	rm -rf ./AppDir/opt
	rm -rf ./build

unpack: $(PACKED)
$(PACKED):
	unpack200 -r $@ $(@:.pack=)
