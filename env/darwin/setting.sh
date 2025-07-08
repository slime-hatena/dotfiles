#!/usr/bin/env bash

# Dock を自動的に隠さない
defaults write com.apple.dock autohide -bool false
# Dock の位置を左に移動
defaults write com.apple.dock orientation -string "left"
# アイコンサイズの設定
defaults write com.apple.dock tilesize -int 40
# Dock の拡大機能を入にする
defaults write com.apple.dock magnification -bool false


# Mission Controlのホットコーナーの設定: 全部無効に
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-br-modifier -int 0


# マウントされたディスクがあったら、自動的に新しいウィンドウを開く
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# 新しいウィンドウでデフォルトでホームフォルダを開く
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# ステータスバーを表示
defaults write com.apple.finder ShowStatusBar -bool true

# パスバーを表示
defaults write com.apple.finder ShowPathbar -bool true

# タブバーを表示
defaults write com.apple.finder ShowTabView -bool true

# ライブラリディレクトリを表示、デフォルトは非表示
chflags nohidden ~/Library

# 不可視ファイルを表示
defaults write com.apple.finder AppleShowAllFiles YES

## 全ての拡張子のファイルを表示する
defaults write -g AppleShowAllExtensions -bool true

## 名前で並べ替えを選択時にディレクトリを前に置くようにする
defaults write com.apple.finder _FXSortFoldersFirst -bool true

## ネットワークフォルダで .DS_Store ファイルを作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE


## トラックパッド関連の設定
defaults write -g com.apple.trackpad.scaling 2
defaults write -g com.apple.mouse.scaling 2
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15

# タップでクリックを有効にする
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFiveFingerPinchGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerPinchGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadHandResting -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadHorizScroll -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadMomentumScroll -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadScroll -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad USBMouseStopsTrackpad -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad UserPreferences -int 1

## 三本指でドラッグ
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true && \
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

## スクロールバーを常時表示する
defaults write -g AppleShowScrollBars -string "Always"

## 未確認のアプリケーションを実行する際のダイアログを無効にする
defaults write com.apple.LaunchServices LSQuarantine -bool false 

## ダウンロードしたファイルを開くときの警告ダイアログをなくしたい
defaults write com.apple.LaunchServices LSQuarantine -bool false

## terminalでUTF-8のみを使用する
defaults write com.apple.terminal StringEncodings -array 4

killall Dock
