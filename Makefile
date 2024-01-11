# Makefile
# 
#



CONTAINER_NAME = coverpage
CONTAINER_VERSION = windows-python3


dist/coverpage.exe: coverpage.py coverpage.spec Dockerfile requirements.txt
	docker images | grep $(CONTAINER_NAME) | grep $(CONTAINER_VERSION) >/dev/null 2>&1 || docker build -t $(CONTAINER_NAME):$(CONTAINER_VERSION) .
	docker run --rm -v "$(shell pwd)":/src $(CONTAINER_NAME):$(CONTAINER_VERSION) 'pyinstaller --clean --onefile coverpage.spec'



.PHONY: test release clean clean_all
test: dist/coverpage.exe test.sh
	./test.sh


VERSION=v0.1.0
release: dist/coverpage.exe
	gh release create $(VERSION) 'dist/coverpage.exe#coverpage.exe'


clean:
	sudo rm -rf __pycache__/ build/ dist/
	sudo rm -f test_files/output.docx


clean_all:
	sudo rm -rf __pycache__/ build/ dist/
	sudo rm -f test_files/output.docx 
	docker rmi $(CONTAINER_NAME):$(CONTAINER_VERSION)

