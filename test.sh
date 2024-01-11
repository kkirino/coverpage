#!/usr/bin/env bash

assert() {
    if [ $# -ne 3 ]; then
        echo 'Usage: assert args expected_exit_status expected_errorname'
        exit 1
    fi

    expected_exit_status="$1"
    expected_errorname="$2"
    args="$3"

    stdout=$(powershell.exe -C "..\dist\coverpage.exe $args" 2>&1)
    actual_exit_status=$?
    actual_errorname=$(echo "$stdout" | grep -oE '^.+Error')

    if [ -n "$actual_errorname" ] && [ $(echo "$stdout" | wc -l) -gt 1 ]; then
        echo ".\coverpage.exe $args => FAIL: got $actual_errorname, but exception handling not implemented"
        exit 1
    fi

    if [ "$actual_exit_status" = "$expected_exit_status" ] && [ "$actual_errorname" = "$expected_errorname" ]; then
        echo ".\coverpage.exe $args => PASS (exit status: $actual_exit_status, error name: $actual_errorname)"
    elif [ "$actual_exit_status" = "$expected_exit_status" ]; then
        echo ".\coverpage.exe $args => FAIL: $expected_errorname expected as an exit status, but got $actual_errorname"
        exit 1
    else
        echo ".\coverpage.exe $args => FAIL: $expected_exit_status expected as an error, but got $actual_exit_status"
        exit 1
    fi
}


cd test_files

# pass
assert 0 "" "-o output.docx cover.docx text.docx" 

# help
assert 0 "" "-h"

# required args
assert 1 "" ""
assert 1 "" "cover.docx"
assert 1 "" "cover.docx text.docx"
assert 1 "" "-o output.docx cover.docx"

# error handled
assert 1 PackageNotFoundError "-o output.docx filenotexist.docx text.docx"
assert 1 PackageNotFoundError "-o output.docx cover.docx filenotexist.docx"
assert 1 PackageNotFoundError "-o output.docx formatnotdocx.docx text.docx"
assert 1 PackageNotFoundError "-o output.docx cover.docx formatnotdocx.docx"
assert 1 ValueError "-o notdocx.doc cover.docx text.docx"
assert 1 ValueError "-o notdocx cover.docx text.docx"
