### CONFIG OPTIONS ###
# Destination path
DEST_PATH ?= ../public/fontello

# Command line launching of browser - tweak to your own system
#BROWSER_COMMAND ?= x-www-browser
# For OS X with Chrome:
BROWSER_COMMAND ?= open -a "Google Chrome" 

### Don't edit below ###

FONTELLO_HOST ?= http://fontello.com

fontopen:
	@if test ! `which curl` ; then \
		echo 'Install curl first.' >&2 ; \
		exit 128 ; \
		fi
	curl --silent --show-error --fail --output .fontello \
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
	@if test ! -e ${DEST_PATH} ; then \
		echo "Creating ${DEST_PATH}" ; \
		mkdir ${DEST_PATH} ; \
		fi
	rm -rf .fontello.src .fontello.zip
	curl --silent --show-error --fail --output .fontello.zip \
		${FONTELLO_HOST}/`cat .fontello`/get
	unzip .fontello.zip -d .
	rm -rf ${DEST_PATH}/*
	cp fontello-*/config.json .
	mv fontello-*/* ${DEST_PATH}
	rm -rf fontello-* .fontello.zip
	#rm -rf ${DEST_PATH}
	#mv `find ./.fontello.src -maxdepth 1 -name 'fontello-*'` ${DEST_PATH}
	#rm -rf .fontello.src .fontello.zip
