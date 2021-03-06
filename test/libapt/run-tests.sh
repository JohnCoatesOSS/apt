#!/bin/sh
set -e

echo "Compiling the tests ..."
make
echo "Running all testcases ..."
LDPATH=$(pwd)/../../build/bin
EXT="_libapt_test"
for testapp in $(ls ${LDPATH}/*$EXT)
do
	name=$(basename ${testapp})
	tmppath=""

	if [ $name = "GetListOfFilesInDir${EXT}" ]; then
		# TODO: very-low: move env creation to the actual test-app
		echo "Prepare Testarea for \033[1;35m$name\033[0m ..."
		tmppath=$(mktemp -d)
		touch "${tmppath}/anormalfile" \
			"${tmppath}/01yet-anothernormalfile" \
			"${tmppath}/anormalapt.conf" \
			"${tmppath}/01yet-anotherapt.conf" \
			"${tmppath}/anormalapt.list" \
			"${tmppath}/01yet-anotherapt.list" \
			"${tmppath}/wrongextension.wron" \
			"${tmppath}/wrong-extension.wron" \
			"${tmppath}/strangefile." \
			"${tmppath}/s.t.r.a.n.g.e.f.i.l.e" \
			"${tmppath}/.hiddenfile" \
			"${tmppath}/.hiddenfile.conf" \
			"${tmppath}/.hiddenfile.list" \
			"${tmppath}/multi..dot" \
			"${tmppath}/multi.dot.conf" \
			"${tmppath}/multi.dot.list" \
			"${tmppath}/disabledfile.disabled" \
			"${tmppath}/disabledfile.conf.disabled" \
			"${tmppath}/disabledfile.list.disabled" \
			"${tmppath}/invälid.conf" \
			"${tmppath}/invalíd" \
			"${tmppath}/01invalíd"
		ln -s "${tmppath}/anormalfile" "${tmppath}/linkedfile.list"
		ln -s "${tmppath}/non-existing-file" "${tmppath}/brokenlink.list"
	fi

	echo -n "Testing with \033[1;35m${name}\033[0m ... "
	LD_LIBRARY_PATH=${LDPATH} ${testapp} ${tmppath} && echo "\033[1;32mOKAY\033[0m" || echo "\033[1;31mFAILED\033[0m"

	if [ -n "$tmppath" -a -d "$tmppath" ]; then
		echo "Cleanup Testarea after \033[1;35m$name\033[0m ..."
		rm -rf "$tmppath"
	fi

done
