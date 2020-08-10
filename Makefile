COMMON_SOURCES = ./Files/AsciiRender.hs ./Files/Reader.hs

Render:
	ghc $(COMMON_SOURCES) ./Files/Main.hs -o Render

clear:
	rm ./Files/*.o ./Files/*.hi || true
