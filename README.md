```
  ______     __                                   __  ___       __    ___       __    __     ______                    __            
 /_  __/__  / /__  ______________  ____  ___     / / / (_)___ _/ /_  / (_)___ _/ /_  / /_   /_  __/      _____  ____ _/ /_____  _____
  / / / _ \/ / _ \/ ___/ ___/ __ \/ __ \/ _ \   / /_/ / / __ `/ __ \/ / / __ `/ __ \/ __/    / / | | /| / / _ \/ __ `/ //_/ _ \/ ___/
 / / /  __/ /  __(__  ) /__/ /_/ / /_/ /  __/  / __  / / /_/ / / / / / / /_/ / / / / /_     / /  | |/ |/ /  __/ /_/ / ,< /  __/ /    
/_/  \___/_/\___/____/\___/\____/ .___/\___/  /_/ /_/_/\__, /_/ /_/_/_/\__, /_/ /_/\__/    /_/   |__/|__/\___/\__,_/_/|_|\___/_/     
                               /_/                    /____/          /____/
```

Highlight tweaking using Telescope 🔭

## What is telescope-highlight-tweaker?

`telescope-highlight-tweaker.nvim` is a simple telescope extension that allows you to search highlight groups. It then adds background
highlighting to the selected highlight group to show you what the highlight applied to. Once you select a highlight, you will then be
prompted to tweak the highlight as you wish, applying the changes. No more guessing which highlights apply to what!

## Getting Started

Install `telescope.nvim` and add this to your telescope config

```lua
require('telescope').load_extension('highlight-tweaker')
```

## Usage

```
:Telescope highlight-tweaker list
```

## Configuration

None at this time
