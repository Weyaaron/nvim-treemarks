# nvim-treemarks: Marks stored as a tree for efficient code navigation

[![License: GPL](https://img.shields.io/badge/License-GPL-brightgreen.svg)](https://opensource.org/license/gpl-3-0/)

This code implements a Neovim Plugin for moving through code 
based on a tree of marks.

As of 2025-04, this is just an idea, the code is a 1:1  copy of 
one of my other plugins to get started on. 

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

## How to train 
This plugin uses subcommands of `TreeMarks` to activate certain functions.
All of these commands support completion, just use `Tab` and you will be fine.
Currently, these are the available options:

| Name | Syntax | Description |
| --- | -------- | -------- |
| Start | `:Training Start [Scheduler] [Task-Collection A] [Task Collection B] ...`| Starts a session with the choosen scheduler and the choosen task collections. Both arguments are optional. |
| Stop | `:Training Stop`| Stops a session. |
| Analyze | `:Training Analyze`| Prints some statistics about your progress. |

The plugin aims to use scratch-buffers to avoid polluting the disk.


# Philosophy

-TODO


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
Todo
- 

# Non-Goals
TODo


# On Contributions
Contributions are welcome! Any input is appreciated, be it a bug report, a feature request, or a pull request.
Just open a issue and we shall get cooking :)

# [License](/LICENSE)
[GPL](LICENSE)
