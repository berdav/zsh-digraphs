#!/bin/zsh
# Update the zsh database of digraphs
# Copyright (C) 2020  Davide Berardi <berardi.dav@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

DIGRAPH_URL="https://raw.githubusercontent.com/vim/vim/master/src/digraph.c"
TEXEC=/tmp/zsh-digraph

curl "$DIGRAPH_URL" |
	awk '/digraphdefault\[\] =/,/handle digraphs after/' > "$TEXEC.h"
echo "*/" >> "$TEXEC.h"

# Generate and execute a C program to generate digraphs associative
# array.
cat >"$TEXEC.c" <<_END_
/**
 * WARNING WARNING WARNING: This file is auto-generated, please do not
 * edit but add your digraphs via user_digraphs.h
 */

/**
 * Generate the zsh database of digraphs
 * Copyright (C) 2020  Davide Berardi <berardi.dav@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
#define _GNU_SOURCE 1
#include <stdlib.h>
#include <locale.h>
#include <stdio.h>
#define NUL '\0'

typedef struct {
	unsigned char code1;
	unsigned char code2;
	wchar_t result;
} digr_T;

#define USE_UNICODE_DIGRAPHS
#include "$TEXEC.h"
#include "$(pwd)/user_digraphs.h"

static int need_to_escape(unsigned char c)
{
	switch(c) {
		case '"':
		case ')':
		case '(':
		case '\`':
		case '\\\\':
			return 1;
		default:
			break;
	}
	return 0;
}

int main(int argc, char **argv)
{
	FILE *out;
	char *path = NULL;
	char *home = getenv("HOME");
	asprintf(&path, "%s/.zsh-digraphs/zsh-digraphs.sh", home);
	out = fopen(path, "w");
	free(path);

	if (out == NULL) {
		perror("fopen");
		return 1;
	}

	setlocale(LC_ALL, "");
	size_t len = sizeof(digraphdefault) / sizeof(*digraphdefault);
	/* ZSH instructions */
	fprintf(out, "function digraph {\n");
	fprintf(out, "\tdeclare -A _digraphs\n");
	for (int i = 0 ; i < len ; ++i) {
		if (digraphdefault[i].code1 == 0 || digraphdefault[i].code2 == 0)
			continue;
		fprintf(out, "\t_digraphs[\\"%s%c%s%c\\"]=\\"\\\\u%x\\"\n",
			(need_to_escape(digraphdefault[i].code1)? "\\\\" : ""),
			digraphdefault[i].code1,
			(need_to_escape(digraphdefault[i].code2)? "\\\\" : ""),
			digraphdefault[i].code2,
			digraphdefault[i].result);
	}
	len = sizeof(userdigraphs) / sizeof(*userdigraphs);
	fprintf(out, "\t# user digraphs\n");
	for (int i = 0 ; i < len ; ++i) {
		if (userdigraphs[i].code1 == 0 || userdigraphs[i].code2 == 0)
			continue;
		fprintf(out, "\t_digraphs[\\"%s%c%s%c\\"]=\\"\\\\u%x\\"\n",
			(need_to_escape(userdigraphs[i].code1)? "\\\\" : ""),
			userdigraphs[i].code1,
			(need_to_escape(userdigraphs[i].code2)? "\\\\" : ""),
			userdigraphs[i].code2,
			userdigraphs[i].result);
	}
	fprintf(out, "\tcode1=\\"\$BUFFER[-2]\\"\n");
	fprintf(out, "\tcode2=\\"\$BUFFER[-1]\\"\n");
	fprintf(out, "\tif [ \\"\$code1\\" = \\"\\" -o \\"\$code2\\" = \\"\\" ]; then\n");
	fprintf(out, "\t\treturn\n");
	fprintf(out, "\tfi\n");

	fprintf(out, "\tif [ \\"\$_digraphs[\\"\$code1\$code2\\"]\\" = \\"\\" ]; then\n");
	fprintf(out, "\t\treturn\n");
	fprintf(out, "\tfi\n");

	fprintf(out, "\tdigraph_to_add=\\"\$(printf \$_digraphs[\\"\$code1\$code2\\"])\\"\n");
	fprintf(out, "\tLBUFFER=\\"\${LBUFFER[1,-3]}\${digraph_to_add}\\"\n");
	fprintf(out, "}\n");
	fprintf(out, "zle -N digraph\n");
	fprintf(out, "if [[ \$- == *i* ]]; then\n");
	fprintf(out, "\tbindkey \\"\\\\C-k\\" \\"digraph\\"\n");
	fprintf(out, "fi\n");

	fclose(out);
	return 0;
}
_END_

make "$TEXEC"
"$TEXEC"

rm -rf $TEXEC{,.c,.h}
