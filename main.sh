#!/bin/bash

# test script for part I
b=$(tput bold)
r=$(tput sgr0)

# header
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

# compile
echo "${b}[!] Compiling ...${r}"
echo '======================================================================'

cd ../../src/
comp=$(make testscanner)
suc_comp="clang -ggdb -O0 -Wall -Wextra -Wno-variadic-macros -Wno-overlength-strings -pedantic -DDEBUG_CODEGEN"
suc_comp+="  -o ../bin/testscanner testscanner.c error.o scanner.o token.o"
alt_suc_comp="clang -ggdb -O0 -Wall -Wextra -Wno-variadic-macros -Wno-overlength-strings -pedantic -DDEBUG_CODEGEN"
alt_suc_comp+="  -c scanner.c\nclang -ggdb -O0 -Wall -Wextra -Wno-variadic-macros -Wno-overlength-strings -pedantic -DDEBUG_CODEGEN"
alt_suc_comp+="  -o ../bin/testscanner testscanner.c error.o scanner.o token.o"
cd ../bin/
echo '======================================================================'

if [ "$comp"=="$suc_comp" ] || [ "$comp"=="$alt_comp" ]
then
	echo "${b}[+] Finished${r}"
else
	echo "${b}[-] Compilation Failed (check directory)${r}"
	exit
fi
echo
echo


# run tests
count=0
score=0

echo "${b}[!] Testing ...${r}"
echo '======================================================================'

for f in test-script/tests/*.alan
do
	f=$(basename -- "$f")
	n="${f%.*}"
	echo "	Testing $f against $n.out"
	echo
	o=$(./testscanner test-script/tests/$f)
	so=$(< test-script/tests/$n.out)

	if [ "$o"=="$so" ]
	then
		echo "	[+] Test Passed !"
		((score++))
	else
		echo "	[-] Test Failed !"
	fi

	echo '======================================================================'
	((count++))

done


#footer
echo
echo
echo "${b}[+] $score out of $count tests passed${r}"
echo '======================================================================'


