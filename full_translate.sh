#!/usr/bin/env sh

function work() {
  texfile="$@"
  file="${texfile%%.*}"

  # mv "${file}.tex" "${file}.tex.variant1"
  # mv "${file}.tex.bkp" "${file}.tex"

  echo docker run -u $UID -v $HOME/projects/hpmor/:$HOME/projects/hpmor -v $HOME/projects/latex-to-text:/app latex-to-text python3 /app/bin/latextotext.py "${file}.tex" "${file}.en.txt" "${file}.dic"
  docker run -u $UID -v $HOME/projects/hpmor/:$HOME/projects/hpmor -v $HOME/projects/latex-to-text:/app latex-to-text python3 /app/bin/latextotext.py "${file}.tex.original" "${file}.en.txt" "${file}.dic"

  # echo "From ${file}.tex created ${file}.dic and $entxt_file"
  # echo mv "${file}.tex" "${file}.tex.original"
  # mv "${file}.tex" "${file}.tex.original"

  # rm -f "${file}.kh.txt"

  # # pandoc -s "${file}.en.txt" -o "${file}.en.doc"

  # # cat "$entxt_file" | translate --source en --target km > "${file}.kh.txt"

  # # in terminal: rm -f totranslatelist.txt
  # echo "${file}.en.txt|${file}.kh.txt" >> totranslatelist.txt

  # echo node /home/srghma/projects/latex-to-text/translate.js --source en --target km --file "${file}.en.txt" --output "${file}.kh.txt"

  # node /home/srghma/projects/latex-to-text/translate.js --source en --target km --fileoutput /home/srghma/projects/latex-to-text/totranslatelist.txt

  # node /home/srghma/projects/latex-to-text/translate.js --source en --target km --file "${file}.en.txt" --output "${file}.kh.txt"

  # echo "Translated ${file}.en.txt to ${file}.kh.txt"

  # echo docker run -u $UID -v $HOME/projects/hpmor/:$HOME/projects/hpmor latex-to-text python3 /app/bin/texttolatex.py "${file}.kh.txt" "${file}.dic" "${file}.tex.original"
  # docker run -u $UID -v $HOME/projects/hpmor/:$HOME/projects/hpmor latex-to-text python3 /app/bin/texttolatex.py "${file}.kh.txt" "${file}.dic" "${file}.tex"

  # fd --glob '*.tex' "$HOME/projects/hpmor" --exec sd -s '\thispagestyle{ទទេ}' '\thispagestyle{empty}' {}
  #
  # fd --glob '*.tex' "$HOME/projects/hpmor" --exec sd -s '\hpfont[ទីតាំងខាងក្រៅ]' '\hpfont[ExternalLocation]' {}
  # fd --glob '*.tex' "$HOME/projects/hpmor" --exec sd -s '\ptsansi[ទីតាំងខាងក្រៅ]' '\ptsansi[ExternalLocation]' {}
  #
  # fd --glob '*.tex' "$HOME/projects/hpmor" --exec sd -s '\baselineskip បូក' '\baselineskip plus' {}
  # fd --glob '*.tex' "$HOME/projects/hpmor" --exec sd -s '\baselineskip ដក' '\textheight minus' {}

  # fd --glob '*.tex' "$HOME/projects/hpmor" --exec sd -s '\newpagecolor{ខ្មៅ}' '\newpagecolor{black}' {}
  # fd --glob '*.tex' "$HOME/projects/hpmor" --exec sd -s 'pt ដក ' 'pt minus ' {}
  # fd --glob '*.tex' "$HOME/projects/hpmor" --exec sd -s 'pt បូក ' 'pt plus ' {}
  # fd --glob '*.tex' "$HOME/projects/hpmor" --exec sd -s 'settocdepth{ជំពូក}' 'settocdepth{chapter}' {}
}

# fd --glob '*.tex' "$HOME/projects/hpmor" --exec /home/srghma/projects/latex-to-text/full_translate.sh {}
# fd --glob '*.tex.original' "$HOME/projects/hpmor" --exec /home/srghma/projects/latex-to-text/full_translate.sh {}

files="
$HOME/projects/hpmor/chapters/hp-exam
$HOME/projects/hpmor/chapters/hpmor-chapter-000
$HOME/projects/hpmor/chapters/hpmor-chapter-001
$HOME/projects/hpmor/chapters/hpmor-chapter-002
$HOME/projects/hpmor/chapters/hpmor-chapter-003
$HOME/projects/hpmor/chapters/hpmor-chapter-004
$HOME/projects/hpmor/chapters/hpmor-chapter-005
$HOME/projects/hpmor/chapters/hpmor-chapter-006
$HOME/projects/hpmor/chapters/hpmor-chapter-007
$HOME/projects/hpmor/chapters/hpmor-chapter-008
$HOME/projects/hpmor/chapters/hpmor-chapter-009
$HOME/projects/hpmor/chapters/hpmor-chapter-010
$HOME/projects/hpmor/chapters/hpmor-chapter-011
$HOME/projects/hpmor/chapters/hpmor-chapter-012
$HOME/projects/hpmor/chapters/hpmor-chapter-013
$HOME/projects/hpmor/chapters/hpmor-chapter-014
$HOME/projects/hpmor/chapters/hpmor-chapter-015
$HOME/projects/hpmor/chapters/hpmor-chapter-016
$HOME/projects/hpmor/chapters/hpmor-chapter-017
$HOME/projects/hpmor/chapters/hpmor-chapter-018
$HOME/projects/hpmor/chapters/hpmor-chapter-019
$HOME/projects/hpmor/chapters/hpmor-chapter-020
$HOME/projects/hpmor/chapters/hpmor-chapter-021
$HOME/projects/hpmor/chapters/hpmor-chapter-022
$HOME/projects/hpmor/chapters/hpmor-chapter-023
$HOME/projects/hpmor/chapters/hpmor-chapter-024
$HOME/projects/hpmor/chapters/hpmor-chapter-025
$HOME/projects/hpmor/chapters/hpmor-chapter-026
$HOME/projects/hpmor/chapters/hpmor-chapter-027
$HOME/projects/hpmor/chapters/hpmor-chapter-028
$HOME/projects/hpmor/chapters/hpmor-chapter-029
$HOME/projects/hpmor/chapters/hpmor-chapter-030
$HOME/projects/hpmor/chapters/hpmor-chapter-031
$HOME/projects/hpmor/chapters/hpmor-chapter-032
$HOME/projects/hpmor/chapters/hpmor-chapter-033
$HOME/projects/hpmor/chapters/hpmor-chapter-034
$HOME/projects/hpmor/chapters/hpmor-chapter-035
$HOME/projects/hpmor/chapters/hpmor-chapter-036
$HOME/projects/hpmor/chapters/hpmor-chapter-037
$HOME/projects/hpmor/chapters/hpmor-chapter-038
$HOME/projects/hpmor/chapters/hpmor-chapter-039
$HOME/projects/hpmor/chapters/hpmor-chapter-040
$HOME/projects/hpmor/chapters/hpmor-chapter-041
$HOME/projects/hpmor/chapters/hpmor-chapter-042
$HOME/projects/hpmor/chapters/hpmor-chapter-043
$HOME/projects/hpmor/chapters/hpmor-chapter-044
$HOME/projects/hpmor/chapters/hpmor-chapter-045
$HOME/projects/hpmor/chapters/hpmor-chapter-046
$HOME/projects/hpmor/chapters/hpmor-chapter-047
$HOME/projects/hpmor/chapters/hpmor-chapter-048
$HOME/projects/hpmor/chapters/hpmor-chapter-049
$HOME/projects/hpmor/chapters/hpmor-chapter-050
$HOME/projects/hpmor/chapters/hpmor-chapter-051
$HOME/projects/hpmor/chapters/hpmor-chapter-052
$HOME/projects/hpmor/chapters/hpmor-chapter-053
$HOME/projects/hpmor/chapters/hpmor-chapter-054
$HOME/projects/hpmor/chapters/hpmor-chapter-055
$HOME/projects/hpmor/chapters/hpmor-chapter-056
$HOME/projects/hpmor/chapters/hpmor-chapter-057
$HOME/projects/hpmor/chapters/hpmor-chapter-058
$HOME/projects/hpmor/chapters/hpmor-chapter-059
$HOME/projects/hpmor/chapters/hpmor-chapter-060
$HOME/projects/hpmor/chapters/hpmor-chapter-061
$HOME/projects/hpmor/chapters/hpmor-chapter-062
$HOME/projects/hpmor/chapters/hpmor-chapter-063
$HOME/projects/hpmor/chapters/hpmor-chapter-064
$HOME/projects/hpmor/chapters/hpmor-chapter-065
$HOME/projects/hpmor/chapters/hpmor-chapter-066
$HOME/projects/hpmor/chapters/hpmor-chapter-067
$HOME/projects/hpmor/chapters/hpmor-chapter-068
$HOME/projects/hpmor/chapters/hpmor-chapter-069
$HOME/projects/hpmor/chapters/hpmor-chapter-070
$HOME/projects/hpmor/chapters/hpmor-chapter-071
$HOME/projects/hpmor/chapters/hpmor-chapter-072
$HOME/projects/hpmor/chapters/hpmor-chapter-073
$HOME/projects/hpmor/chapters/hpmor-chapter-074
$HOME/projects/hpmor/chapters/hpmor-chapter-075
$HOME/projects/hpmor/chapters/hpmor-chapter-076
$HOME/projects/hpmor/chapters/hpmor-chapter-077
$HOME/projects/hpmor/chapters/hpmor-chapter-078
$HOME/projects/hpmor/chapters/hpmor-chapter-079
$HOME/projects/hpmor/chapters/hpmor-chapter-080
$HOME/projects/hpmor/chapters/hpmor-chapter-081
$HOME/projects/hpmor/chapters/hpmor-chapter-082
$HOME/projects/hpmor/chapters/hpmor-chapter-083
$HOME/projects/hpmor/chapters/hpmor-chapter-084
$HOME/projects/hpmor/chapters/hpmor-chapter-085
$HOME/projects/hpmor/chapters/hpmor-chapter-086
$HOME/projects/hpmor/chapters/hpmor-chapter-087
$HOME/projects/hpmor/chapters/hpmor-chapter-088
$HOME/projects/hpmor/chapters/hpmor-chapter-089
$HOME/projects/hpmor/chapters/hpmor-chapter-090
$HOME/projects/hpmor/chapters/hpmor-chapter-091
$HOME/projects/hpmor/chapters/hpmor-chapter-092
$HOME/projects/hpmor/chapters/hpmor-chapter-093
$HOME/projects/hpmor/chapters/hpmor-chapter-094
$HOME/projects/hpmor/chapters/hpmor-chapter-095
$HOME/projects/hpmor/chapters/hpmor-chapter-096
$HOME/projects/hpmor/chapters/hpmor-chapter-097
$HOME/projects/hpmor/chapters/hpmor-chapter-098
$HOME/projects/hpmor/chapters/hpmor-chapter-099
$HOME/projects/hpmor/chapters/hpmor-chapter-100
$HOME/projects/hpmor/chapters/hpmor-chapter-101
$HOME/projects/hpmor/chapters/hpmor-chapter-102
$HOME/projects/hpmor/chapters/hpmor-chapter-103
$HOME/projects/hpmor/chapters/hpmor-chapter-104
$HOME/projects/hpmor/chapters/hpmor-chapter-105
$HOME/projects/hpmor/chapters/hpmor-chapter-106
$HOME/projects/hpmor/chapters/hpmor-chapter-107
$HOME/projects/hpmor/chapters/hpmor-chapter-108
$HOME/projects/hpmor/chapters/hpmor-chapter-109
$HOME/projects/hpmor/chapters/hpmor-chapter-110
$HOME/projects/hpmor/chapters/hpmor-chapter-111
$HOME/projects/hpmor/chapters/hpmor-chapter-112
$HOME/projects/hpmor/chapters/hpmor-chapter-113
$HOME/projects/hpmor/chapters/hpmor-chapter-114
$HOME/projects/hpmor/chapters/hpmor-chapter-115
$HOME/projects/hpmor/chapters/hpmor-chapter-116
$HOME/projects/hpmor/chapters/hpmor-chapter-117
$HOME/projects/hpmor/chapters/hpmor-chapter-118
$HOME/projects/hpmor/chapters/hpmor-chapter-119
$HOME/projects/hpmor/chapters/hpmor-chapter-120
$HOME/projects/hpmor/chapters/hpmor-chapter-121
$HOME/projects/hpmor/chapters/hpmor-chapter-122
$HOME/projects/hpmor/hpmor
$HOME/projects/hpmor/hpmor-1
$HOME/projects/hpmor/hpmor-2
$HOME/projects/hpmor/hpmor-3
$HOME/projects/hpmor/hpmor-4
$HOME/projects/hpmor/hpmor-5
$HOME/projects/hpmor/hpmor-6
$HOME/projects/hpmor/layout/hp-blurbs
$HOME/projects/hpmor/layout/hp-colophon
$HOME/projects/hpmor/layout/hp-contents
$HOME/projects/hpmor/layout/hp-dust-jacket
$HOME/projects/hpmor/layout/hp-format
$HOME/projects/hpmor/layout/hp-header
$HOME/projects/hpmor/layout/hp-intro
$HOME/projects/hpmor/layout/hp-markup
$HOME/projects/hpmor/layout/hp-paper-type
$HOME/projects/hpmor/layout/hp-title
$HOME/projects/hpmor/layout/hpmor-dust-jacket-1
$HOME/projects/hpmor/layout/hpmor-dust-jacket-2
$HOME/projects/hpmor/layout/hpmor-dust-jacket-3
$HOME/projects/hpmor/layout/hpmor-dust-jacket-4
$HOME/projects/hpmor/layout/hpmor-dust-jacket-5
$HOME/projects/hpmor/layout/hpmor-dust-jacket-6
$HOME/projects/hpmor/layout/hpmor-title
$HOME/projects/hpmor/layout/hpmor-title-1
$HOME/projects/hpmor/layout/hpmor-title-2
$HOME/projects/hpmor/layout/hpmor-title-3
$HOME/projects/hpmor/layout/hpmor-title-4
$HOME/projects/hpmor/layout/hpmor-title-5
$HOME/projects/hpmor/layout/hpmor-title-6
$HOME/projects/hpmor/layout/papers
$HOME/projects/hpmor/scripts/ebook/hpmor-ebook"

# Loop over each file and call the work function
for texfile in $files; do
  work "$texfile"
done
