# This File helps to generate themes of your base16 template.
# Example of folder structure and use: https://github.com/theova/base16-telegram-desktop

BUILD=pybase16
REPO=$(pwd)
TEMPLATE="$(basename "$REPO")"
THEME_DIR="$REPO/themes"
TEMPLATE_DIR="$REPO/templates"
OUTPUT="$REPO/output"
THEME_DIR_TMP="$OUTPUT/$TEMPLATE/themes"

update(){
	eval $BUILD update
}

build(){
	eval "$BUILD" build -t "$REPO" -o "$OUTPUT"
	rm -rf "$THEME_DIR"

	for THEME in "$THEME_DIR_TMP"/*; do
		echo $THEME_DIR_TMP
		THEME_NAME="$(basename "$THEME")"
		COLORS_TDESKTOP_FILE=$THEME_DIR/$THEME_NAME/colors.tdesktop-theme
		mkdir -p "$THEME_DIR/$THEME_NAME"
		mv "$THEME" "$COLORS_TDESKTOP_FILE"
		cd "$THEME_DIR/$THEME_NAME" || exit
		BG_COLOR="$(grep "base01:" "$COLORS_TDESKTOP_FILE" | cut -d: -f2 | sed "s/;//")"
		convert -size 1x1 xc:"$BG_COLOR" "background.png"
			zip "$THEME_NAME.tdesktop-theme" colors.tdesktop-theme background.png
		cd || exit
	done


}

clean(){
	rm -rf "${OUTPUT}" "${TEMPLATE_DIR:?}"/*/
}


########
# MAIN #
########

option="$1"

case $option in
	"update")
		update
		clean
		;;
	"build")
		build
		clean
		;;
	"clean")
		clean
		;;
	*)
		update
		build
		clean
		;;
esac
