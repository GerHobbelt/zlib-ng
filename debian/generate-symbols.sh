#!/bin/sh
set -e

SYMBOLS_FILE=debian/zlib1-ng/DEBIAN/symbols
trap 'rm -f "$SYMBOLS_FILE.new"' EXIT

dependency_id=$(($(grep '^|\s' "$SYMBOLS_FILE" | wc -l) + 1))

for lib_version in $(dpkg-query --control-show zlib1g:$(dpkg-architecture -qDEB_HOST_ARCH) symbols |
	grep '^\s' |
	while IFS="${IFS}@-" read -r _ _ version _; do
		echo "$version"
	done |
	sort -u); do
	head -n1 "$SYMBOLS_FILE" > "$SYMBOLS_FILE.new"
	grep '^|\s' "$SYMBOLS_FILE" >> "$SYMBOLS_FILE.new" || [ $? = 1 ]
	echo "| zlib1g (>= $lib_version) | zlib1-ng #MINVER#" >> "$SYMBOLS_FILE.new"
	grep '^\*\?\s' "$SYMBOLS_FILE" >> "$SYMBOLS_FILE.new"
	mv debian/zlib1-ng/DEBIAN/symbols.new debian/zlib1-ng/DEBIAN/symbols
	dpkg-query --control-show zlib1g:$(dpkg-architecture -qDEB_HOST_ARCH) symbols |
		grep "^\\s\\S\\+@\\S\\+\\s$lib_version\\(-\\S\\+\\)\\?$" |
		while IFS="${IFS}@-" read -r symbol symver _; do
			sed -i "s/^\\s$symbol@$symver\\s\\S\\+$/\\0 $dependency_id/" "$SYMBOLS_FILE"
		done
	: $((dependency_id += 1))
done

sed -i 's/^\s\S\+@\S\+\s\S\+$/\0 1/' "$SYMBOLS_FILE"
