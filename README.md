# ZSH Digraphs

Insert VIM digraphs with ZSH.
![https://github.com/berdav/zsh-digraphs/raw/master/readme-img/zsh-digraphs.gif](Download of german's wikipedia and grep of eszet words.)

## Usage
The plugin uses VIM digraphs.
The most common ones used for German and Italian are:

| code | Glyph | Description               |
|------|-------|---------------------------|
|  a`  |   à   | Grave-accented a (là)     |
|  i`  |   ì   | Grave-accented i (così)   |
|  o`  |   ò   | Grave-accented o (però)   |
|  e`  |   è   | Grave-accented e (è)      |
|  e'  |   é   | Acute-accented e (perché) |
|  a:  |   ä   | Umlauted a (männer)       |
|  o:  |   ö   | Umlauted o (öl)           |
|  u:  |   ü   | Umlauted u (Tschüss)      |
|  ss  |   ß   | Eszett (Straße)           |

To insert one code, write the two characters and press Ctrl-K, the
characters will get translated to their relative glyph.

## Installation
To install the plugin put in your `.zshrc.local` the following
entry:
```bash
source $path_to_repo/zsh-digraphs.sh
```
substituting $path_to_repo with the path where you've downloaded this repo.

## Update and configuration
You can generate an up-to-date configuration using the upstream vim
repository, simply execute the `update_zsh_digraphs.sh` script to generate
a new `zsh-digraph.sh`.

You can also configure your digraphs, put them in the `user_digraphs.h`
and regenerate the configuration using the provided
`update_zsh_digraphs.sh` script.

## Motivation
From time to time I need to write words on the command line (e.g.
If I am taking ephemeral notes and I don't want to open VIM).

That is perfectly fine when I'm writing in English, but not when I'm
writing in Italian (which has accented vowels such as è, é, ù, ò and ì)
or German which has Ezset (ß) and Umlaut (ü, ö, ä).  And I don't want to
switch from USA layout to localized ones.

The solution could be to use the UTF8 input provided by the System, but
I would need to remember the conter-intuitive Unicode number.

The VIM input system is really easy to mesmorize.  Therefore this script
adapt VIM input to ZSH.
