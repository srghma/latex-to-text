build:
	docker build -t latex-to-text .

test:
	git checkout origin -- examples/
	docker run -it -v ./:/app latex-to-text bin/test.sh

fd --glob '*.tex' $HOME/projects/hpmor --exec bash -c "docker run -u $UID:$GID -v $HOME/projects/hpmor/:$HOME/projects/hpmor -v $HOME/projects/latex-to-text:/app latex-to-text python3 /app/bin/latextotext.py {}"
fd --glob '*.tex.kh.txt' $HOME/projects/hpmor --exec rm -f {}
fd --glob '*.kh.txt' $HOME/projects/hpmor --exec rm -f {}
fd --glob '*.kh.kh.txt' $HOME/projects/hpmor --exec rm -f {}
fd --glob '*.txt' $HOME/projects/hpmor --exec rm -f {}
fd --glob '*.dic' $HOME/projects/hpmor --exec rm -f {}

cd $HOME/projects/hpmor
rm -f **/*.{out,log,toc,xdv,fls,fdb_latexmk,aux,xdv,pdf}
rm -f **/*.{dic,txt,bkp,tex}
rm -f **/*.en.tex
rm -f **/*.kh.tex
rm -f **/*.tex.bkp
git clean -fd
git checkout -- .
# git checkout -- fonts hpmor-1.tex hpmor-2.tex hpmor-3.tex hpmor-4.tex hpmor-5.tex hpmor-6.tex hpmor.tex spelling-list.txt **/*.tex

fd --glob '*.tex' "$HOME/projects/hpmor" --exec $HOME/projects/latex-to-text/full_translate.sh {}

node /home/srghma/projects/latex-to-text/translate.js --source en --target km --file "$HOME/projects/hpmor/chapters/hpmor-chapter-028.en.txt" --output "$HOME/projects/hpmor/chapters/hpmor-chapter-028.kh.txt"
node /home/srghma/projects/latex-to-text/translate.js --source en --target km --file "$HOME/projects/hpmor/chapters/hpmor-chapter-027.en.txt" --output "$HOME/projects/hpmor/chapters/hpmor-chapter-027.kh.txt"

export PUPPETEER_EXECUTABLE_PATH=google-chrome-stable
export PUPPETEER_EXECUTABLE_PATH=/nix/store/glidmvvbp9lyw6bwypg7vb3rqnm79474-google-chrome-126.0.6478.114/bin/google-chrome-stable
node /home/srghma/projects/latex-to-text/translate.js --source en --target km --fileoutput /home/srghma/projects/latex-to-text/totranslatelist.txt

hpmor_latextotext:
	docker run -u $$UID:$$GID -it -v $$HOME/projects/hpmor/:$$HOME/projects/hpmor latex-to-text python3 /app/bin/latextotext.py $$HOME/projects/hpmor/layout/hpmor-title-1.tex
