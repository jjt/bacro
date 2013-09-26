# Edit here - set path to you directory with config.json & fonts

FONT_DIR      ?= ../../public/fontello

### Don't edit below ###

FONTELLO_HOST ?= http://fontello.com

fontopen:
	@if test ! `which curl` ; then \
		echo 'Install curl first.' >&2 ; \
		exit 128 ; \
		fi
	curl --show-error --fail --output .fontello \
		--form "config=@config.json" \
		${FONTELLO_HOST}
	#x-www-browser ${FONTELLO_HOST}/`cat .fontello`


fontsave:
	@if test ! `which unzip` ; then \
		echo 'Install unzip first.' >&2 ; \
		exit 128 ; \
		fi
	@if test ! -e .fontello ; then \
		echo 'Run `make fontopen` first.' >&2 ; \
		exit 128 ; \
		fi
	@if test ! -e ${FONT_DIR} ; then \
		echo "Creating ${FONT_DIR}" ; \
		mkdir ${FONT_DIR} ; \
		fi
	rm -rf .fontello.src .fontello.zip
	curl --silent --show-error --fail --output .fontello.zip \
		${FONTELLO_HOST}/`cat .fontello`/get
	unzip .fontello.zip -d .
	rm -rf ${FONT_DIR}/*
	mv fontello-*/* ${FONT_DIR}
	rm -rf fontello-* .fontello.zip
	#rm -rf ${FONT_DIR}
	#mv `find ./.fontello.src -maxdepth 1 -name 'fontello-*'` ${FONT_DIR}
	#rm -rf .fontello.src .fontello.zip
