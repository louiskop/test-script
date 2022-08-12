#!/bin/bash

# test script for part I
b=$(tput bold)
r=$(tput sgr0)
count=0
score=0

# header
function header {
	echo '======================================================================'
	echo '                        _           __     __            __           '
	echo '    ____  _________    (_)__  _____/ /_   / /____  _____/ /____  _____'
	echo '   / __ \/ ___/ __ \  / / _ \/ ___/ __/  / __/ _ \/ ___/ __/ _ \/ ___/'
	echo '  / /_/ / /  / /_/ / / /  __/ /__/ /_   / /_/  __(__  ) /_/  __/ /    '
	echo ' / .___/_/   \____/_/ /\___/\___/\__/   \__/\___/____/\__/\___/_/     '
	echo '/_/              /___/                                                '
	echo '									       								'
	echo '======================================================================'
	echo '@2022 part I - scanner'
	echo
	echo
}

# compile
function compile {
	echo "${b}[!] Compiling ...${r}"
	cd ../../src/
	err=$(make testscanner 2>&1 >/dev/null)
	comp=$(make testscanner 2> /dev/null)
	suc_comp="clang -ggdb -O0 -Wall -Wextra -Wno-variadic-macros -Wno-overlength-strings -pedantic -DDEBUG_CODEGEN"
	suc_comp+="  -o ../bin/testscanner testscanner.c error.o scanner.o token.o"
	alt_suc_comp="clang -ggdb -O0 -Wall -Wextra -Wno-variadic-macros -Wno-overlength-strings -pedantic -DDEBUG_CODEGEN"
	alt_suc_comp+="  -c scanner.c\nclang -ggdb -O0 -Wall -Wextra -Wno-variadic-macros -Wno-overlength-strings -pedantic -DDEBUG_CODEGEN"
	alt_suc_comp+="  -o ../bin/testscanner testscanner.c error.o scanner.o token.o"
	cd ../bin/
	echo '======================================================================'

	if [[ "$comp" == "$suc_comp" && "$err" == "" || "$comp" == "$alt_comp" && "$err" == "" ]]
	then
		echo "${b}[+] Finished${r}"
	else
		echo "${b}[-] Compilation Failed (resolve all errors & warnings)${r}"
		exit
	fi
	echo
	echo
}

# run tests
function tests {
	echo "${b}[!] Testing ...${r}"
	echo '======================================================================'
	for f in test-script/tests/part1Official/*.alan
	do
		f=$(basename -- "$f")
		n="${f%.*}"
		echo "	Testing $f against $n.alan.out.txt & $n.alan.err.txt"
		echo
		te=$(./testscanner test-script/tests/part1Official/$f 2>&1 >/dev/null)
		o=$(./testscanner test-script/tests/part1Official/$f 2> /dev/null)
		so=$(< test-script/tests/part1Official/report/$n.alan.out.txt)
		se=$(< test-script/tests/part1Official/report/$n.alan.err.txt)

		if [ "$o" == "$so" ] && [ "$te" == "$se" ]
		then
			echo "	[+] Test Passed !"
			((score++))
		else
			echo "	[-] Test Failed !"
		fi

		echo '======================================================================'
		((count++))
	done
}

#footer
function footer {
	echo
	echo
	echo "${b}[+] $score out of $count tests passed${r}"
	echo '======================================================================'
}

header

# compile and test scanner
compile
tests

footer
