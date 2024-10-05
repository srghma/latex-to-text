#!/usr/bin/env sh

# Run the Python scripts on examples.
# Usage: Run '../bin/test.sh' from the examples directory.
# The script compares the original and new tex files. They should be essentially identical.

# bin='../bin'
bin='/app/bin'

examples='/app/examples'

j=1
while [ "${j}" -le 3 ]
do
    printf '\n\n'
    echo "### Test ${j}."
    python3 "${bin}/latextotext.py" "${examples}/test-0${j}.tex"
    cp "${examples}/test-0${j}.txt" "${examples}/test-new-0${j}.txt"
    python3 "${bin}/texttolatex.py" "${examples}/test-new-0${j}.txt" "${examples}/test-0${j}.dic"
    printf '\n\n\n'
    echo "### Differences for test ${j}:"
    diff "${examples}/test-0${j}.tex" "${examples}/test-new-0${j}.tex"
    # echo '### Press [enter].'
    # read
    j="$(( j + 1 ))"
done
