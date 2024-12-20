# Beep!Mania

4keys game which developed with assembly language and raylib 

GamePlay: Notes fall in straight lines down the screen randomly in 30 seconds(default, you can change it), and players must press the correct key for the corresponding note column.

There are three judgements: Perfect, Great, Good which corresponding to different scores.

7keys may be added afterward.

## Dependancies

- nasm
- raylib

** Windows** need MinGW

## How to start

Default platform is Linux

```
make 
```

then 

```
./beep
```

if your using windows, try

```
make win
```

## Guide

You can change the speed of notes, the time of game and keybindings you want to use in the game.
By modifying the contents of the txt file in the config directory.
*the key files need ASCII code*

