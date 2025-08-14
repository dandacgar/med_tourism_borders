all: $(foreach lang, python stata, ../output/$(lang)_packages.txt)

include ../../generic.make

../output/python_packages.txt: python_packages.sh | ../output
	./$<

../output/stata_packages.txt: packages.do | ../output
	stata-se -e $<
