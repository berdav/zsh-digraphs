/**
 * Custom database of digraphs for zsh completion.
 * Copyright (C) 2020  Davide Berardi <berardi.dav@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

/* Digraph structure:
 * { 'firstcode', 'secondcode', 'utf8code' }
 */
digr_T userdigraphs[] = {
	/* Sample digraph */
	{ 'x', 'z', 0x2f7 },
	{ 'e', 'I', 0x259 },
	/* emoji */
	{ '^', '^', 0x1f51d }, /* TOP */
};
