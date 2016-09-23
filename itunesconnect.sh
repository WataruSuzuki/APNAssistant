PROJ_FILE_PATH="ApnBookmarks.xcworkspace"
TARGET_HOST="ApnBookmarks"
OUT_ARCHIVES_DIR="out_archives"
OUT_IPA_DIR="out_ipa"
ALTTOOL="/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Support/altool"
ITUNES_ID=""
ITUNES_PW=""

# 出力先ipaディレクトリ作成
# -------------------------
if [ ! -d ${OUT_ARCHIVES_DIR} ]
then
    mkdir "${OUT_ARCHIVES_DIR}"
fi
if [ ! -d ${OUT_IPA_DIR} ]
then
    mkdir "${OUT_IPA_DIR}"
fi

# 関数の定義
# -------------------------
itunes_connect () {
    xcodebuild clean -workspace "${PROJ_FILE_PATH}"
    xcodebuild archive -workspace "${PROJ_FILE_PATH}" -scheme "${TARGET_HOST}" -archivePath "${PWD}/${OUT_ARCHIVES_DIR}/$1.xcarchive" -configuration $1
    xcodebuild -exportArchive -archivePath "${PWD}/${OUT_ARCHIVES_DIR}/$1.xcarchive" -exportPath "${PWD}/${OUT_IPA_DIR}" -exportOptionsPlist "${PWD}/exportOptions.Plist"
    "${ALTTOOL}" --validate-app -f "${PWD}/${OUT_IPA_DIR}/${TARGET_HOST}.ipa"  -u ${ITUNES_ID} -p ${ITUNES_PW}
    "${ALTTOOL}" --upload-app -f "${PWD}/${OUT_IPA_DIR}/${TARGET_HOST}.ipa"  -u ${ITUNES_ID} -p ${ITUNES_PW}
}

#Release
itunes_connect Release
