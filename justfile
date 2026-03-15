tests:
    bash tests/run.sh

examples:
    for f in examples/*.typ; do typst compile "$f" --root .; done

ci: tests examples

clean:
    rm -f examples/*.pdf tests/*.pdf

watch file:
    typst watch "{{file}}" --root .
