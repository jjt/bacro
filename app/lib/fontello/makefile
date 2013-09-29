### CONFIG OPTIONS ###
# Build path
BUILD_DIR ?= ../../../public/fontello

# Command line launching of browser - tweak to your own system
BROWSER_COMMAND ?= x-www-browser
# For OS X with Chrome:
 BROWSER_COMMAND ?= open -a "Google Chrome" 

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
	${BROWSER_COMMAND} ${FONTELLO_HOST}/`cat .fontello`	


fontsave:
	@if test ! `which unzip` ; then \
		echo 'Install unzip first.' >&2 ; \
		exit 128 ; \
		fi
	@if test ! -e .fontello ; then \
		echo 'Run `make fontopen` first.' >&2 ; \
		exit 128 ; \
		fi
	@if test ! -e ${BUILD_DIR} ; then \
		echo "Creating ${BUILD_DIR}" ; \
		mkdir ${BUILD_DIR} ; \
		fi
	rm -rf .fontello.src .fontello.zip
	curl --silent --show-error --fail --output .fontello.zip \
		${FONTELLO_HOST}/`cat .fontello`/get
	unzip .fontello.zip -d .
	rm -rf ${BUILD_DIR}/*
	mv fontello-*/* ${BUILD_DIR}
	rm -rf fontello-* .fontello.zip
	#rm -rf ${BUILD_DIR}
	#mv `find ./.fontello.src -maxdepth 1 -name 'fontello-*'` ${BUILD_DIR}
	#rm -rf .fontello.src .fontello.zip
