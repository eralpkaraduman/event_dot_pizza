#!/usr/bin/env bash 
set -e
bundle
flutter clean
flutter pub get
flutter test
# (cd ios && bundle exec fastlane test)
# (cd android && bundle exec fastlane test)

flutter build ios --release --no-codesign
(cd ios && bundle exec fastlane build)
# (cd ios && bundle exec fastlane update_credentials) # Run this if credentials are expired

flutter build appbundle --release

(cd ios && bundle exec fastlane upload)
(cd android && bundle exec fastlane upload)
