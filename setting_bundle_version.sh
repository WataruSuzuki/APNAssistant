#!/bin/bash

APP_VERSION=$MARKETING_VERSION
/usr/libexec/PlistBuddy -c "Set :PreferenceSpecifiers:1:DefaultValue ${APP_VERSION}" "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}/Settings.bundle/Root.plist"

APP_BUILD_NO=$CURRENT_PROJECT_VERSION
/usr/libexec/PlistBuddy -c "Set :PreferenceSpecifiers:2:DefaultValue ${APP_BUILD_NO}" "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}/Settings.bundle/Root.plist"
