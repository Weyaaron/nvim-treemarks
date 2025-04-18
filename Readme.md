# nvim-treemarks: Marks stored as a tree for efficient code navigation

[![License: GPL](https://img.shields.io/badge/License-GPL-brightgreen.svg)](https://opensource.org/license/gpl-3-0/)


# As of 2025-04, WIP!
This code implements a Neovim Plugin for moving through code
based on a tree of marks.

It provides usefull functions for moving through marks,
such as sending them to the qickfix-list or iteration.


# Getting Started
## Installation
Install it using the plugin manager of your choice.
[Lazy](https://github.com/folke/lazy.nvim) is tested,
if any other fails, please open an issue. Pinning your local installation to a fixed version is encouraged.
In Lazy, a possible setup might be:

```lua
local lazy = require("lazy")
local plugin_list = {
    -- Your various other plugins ..
    {"https://github.com/Weyaaron/nvim-treemarks", pin= true, opts = {}}
    -- Support for configuration with opts is included, see below for the options
}
lazy.setup(plugin_list)
```

## How to Setup/Introduction to Actions
This plugin uses subcommands of `TreeMarks` to activate certain actions.
They are not intended for "interactive" use, but should be used through
keybinds.
Currently, these are the available actions:

| Name | Syntax | Description |
| --- | -------- | -------- |
| Start | `:TreeMarks PlaceRootMark `| Places a root mark at the cursor location. |


# Philosophy

I noticed that when navigating code there is a structure to the movement that
lends itself to presentation as a tree. Furthermore, I have not found
a suitable plugin for motions across files. So I wrote my own.


# Contributions

Some of the work on this plugin has been done under the supervision of
[Jonas und der Wolf.](https://www.jonasundderwolf.de/) I am gratefull
for this oppoturnity to contribute to open source on my own terms.


# Configuration
A interface for configuration is provided. These are the default values.
Simply copying then but leaving the defaults in is actually discouraged. Some of these names
might change, and if you leave this in your config these changes are not propagated.
```lua
local treemarks= require("nvim-treemarks")
treemarks.configure({ -- All of these options work for 'opts' of lazy as well.
})
```

# Goals
- Provide a variety of movement options based on a tree of marks
- Support marks per project and per Git-Branch.

# On Contributions
Contributions are welcome! Any input is appreciated, be it a bug report, a feature request, or a pull request.
Just open a issue and we shall get cooking :)

# [License](/LICENSE)
[GPL](LICENSE)
