# TMK Keyboard Firmware

## TMK Keymap Editor
[http://www.tmk-kbd.com/tmk_keyboard/editor](http://www.tmk-kbd.com/tmk_keyboard/editor)

## Installation
```bash
# Mac
brew tap osx-cross/avr
brew install avr-gcc
brew install dfu-programmer
```

```bash
$ sudo dfu-programmer atmega32u4 erase --force
$ sudo dfu-programmer atmega32u4 flash your.hex
$ sudo dfu-programmer atmega32u4 reset
```
