

[['TAB','ESC','F1','UP','DEL','PGUP','HOME','BKSP'], \ 
 ['CTRL','↔️','LEFT','DOWN','RIGHT','PGDN','END','ENTER']]


The result of using Ctrl in combination with a key depends on which program is used, but for many command line tools the following shortcuts works:

Ctrl+A → Move cursor to the beginning of line
Ctrl+C → Abort (send SIGINT to) current process
Ctrl+D → Logout of a terminal session
Ctrl+E → Move cursor to the end of line
Ctrl+K → Delete from cursor to the end of line
Ctrl+U → Delete from cursor to the beginning of line
Ctrl+L → Clear the terminal
Ctrl+Z → Suspend (send SIGTSTP to) current process
Ctrl+W → Clear prompt before word (a word is a set of characters after a space)
Ctrl+alt+C → Open new session (only works in Hacker's Keyboard)
The Volume up key also serves as a special key to produce certain input:

Volume Up+E → Escape key
Volume Up+T → Tab key
Volume Up+1 → F1 (and Volume Up+2 → F2, etc)
Volume Up+0 → F10
Volume Up+B → Alt+B, back a word when using readline
Volume Up+F → Alt+F, forward a word when using readline
Volume Up+X → Alt+X
Volume Up+W → Up arrow key
Volume Up+A → Left arrow key
Volume Up+S → Down arrow key
Volume Up+D → Right arrow key
Volume Up+L → | (the pipe character)
Volume Up+H → ~ (the tilde character)
Volume Up+U → _ (underscore)
Volume Up+P → Page Up
Volume Up+N → Page Down
Volume Up+. → Ctrl+\ (SIGQUIT)
Volume Up+V → Show the volume control
Volume Up+Q → Show extra keys view
Volume Up+K → Another variant to toggle extra keys view

The setting extra-keys-style can be used to choose which set of symbols to use for the keys. Valid options are "default," "arrows-only", "arrows-all", "all" and "none".

extra-keys-style = default 
Example configuration to enable 2-row (was in v0.65) extra keys:

extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]

The extra-keys definition itself can also be spread over multiple lines, if desired, by "backslash-escaping" the line feed at the end of each line, thus:

extra-keys = [ \
 ['ESC','|','/','HOME','UP','END','PGUP','DEL'], \
 ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN','BKSP'] \
]

Here is a syntax for key definition with popup:

{key: KEY, popup: POPUP_KEY}
and here is a syntax for a more advanced key:

{key: KEY, popup: {macro: 'KEY COMBINATION', display: 'Key combo'}}
Example of advanced extra keys configuration:

extra-keys = [[ \
  {key: ESC, popup: {macro: "CTRL d", display: "tmux exit"}}, \
  {key: CTRL, popup: {macro: "CTRL f BKSP", display: "tmux ←"}}, \
  {key: ALT, popup: {macro: "CTRL f TAB", display: "tmux →"}}, \
  {key: TAB, popup: {macro: "ALT a", display: A-a}}, \
  {key: LEFT, popup: HOME}, \
  {key: DOWN, popup: PGDN}, \
  {key: UP, popup: PGUP}, \
  {key: RIGHT, popup: END}, \
  {macro: "ALT j", display: A-j, popup: {macro: "ALT g", display: A-g}}, \
  {key: KEYBOARD, popup: {macro: "CTRL d", display: exit}} \
]]

