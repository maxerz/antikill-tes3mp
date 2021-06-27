# AntiKill TES3MP
AntiKill script for TES3MP. Its goal is to prevent killing essential or important NPCs (or creatures).

This script requires [DataManager by urm](https://github.com/tes3mp-scripts/DataManager)!

Use `mainalt.lua` if you want to use unique indexes or need a better performance.
Otherwise, use `main.lua`.
### Installation:
1. Download this repository and extract it into <SERVER ROOT DIRECTORY>/server/scripts/
2. Add this in `customScripts.lua` after DataManager:
  ```lua
  require("custom.AntiKill.main")
  ```
  OR
  ```lua
  require("custom.AntiKill.mainalt")
  ```
3. Configure script.
### Commands:
  `/antikill <exclude/include/save/list> [NPC ID]`
  
  *Note: `[NPC ID]` is required only when you exclude or include NPC.*
