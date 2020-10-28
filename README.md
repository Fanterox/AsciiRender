# AsciiRender!

![Haskell CI](https://github.com/flleeppyy/AsciiRender/workflows/Haskell%20CI/badge.svg)

### Prerequisites

You're going to need Haskell installed. This code has been made in Haskell version 8.0.2.

Get Haskell here: http://www.haskell.org/ghc/ 

If you're already on linux with `apt`, you can install it with `sudo apt install haskell-platform` (Please do note that this is 1GB! yes its absurd we know)

If you're on Windows, you'll probably want the linux subsystem installed, as to use the linux terminal, or use a virtual machine.

## Instructions

### How to compile:

1. Go to your preferred folder for cloning repositorys, `git clone https://github.com/fanterox/asciirender`, then `cd ascii

2. Then type `make Render`

If you get an error for `Failed to load interface for ‘Data.List.Split’`, Run `cabal install --lib split` then compile again


### Getting ready

For now, the code can only process .obj files

The .obj files will need to be located in the Models folder.

### Running the Render

In order to run the program you need to type `./Render` while in the main folder.

If you get `./Render: Permission denied`, you must type in `chmod +x ./Render`, then you may execute it.

You will be prompted to input a filename. This will be the name of the file in the Models folder, without the `.obj` extension

### How to stop the program

I haven't made a more optimal way to stop the execution of the code, so for now if you want to stop the program you will need to press "ctrl + z". 

### Considerations

This project is still in its early stages, so there are lots of things yet to be implemented. I'll try to continue working on it, but for the most part, it may not get updated often.
So if you want to contribute to this project, feel completely free to do so.
