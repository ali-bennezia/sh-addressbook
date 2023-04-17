# Shell addressbook
An address book written in shell, as an exercise as required: https://www.shellscript.sh/exercises.html

## Features
- Search
- Add
- Remove
- Edit

## Usage
Go to either menu-based (interactive) or cli-based, depending on the version you'd like to try, then execute addressbook.sh
Use CTRL+C to exit an option, or exit the address book entirely.

### Options
Using the CLI version, you can use the -o option to specify a menu option to launch directly, using its index.
Example:
```
./addressbook.sh -o 1
```
Will select and launch the search records option.

### Interactive menu
Use the up and down arrow keys to navigate through the interactive menu. Press enter to select an option.
