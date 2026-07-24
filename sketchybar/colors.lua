-- ~/.config/sketchybar/colors.lua

-- Define a color palette
-- You can find more colors using a color picker tool or exploring themes.
-- Example: https://coolors.co/

local colors = {}

-- Basic grayscale
colors.black = 0xff000000 -- Pure black
colors.white = 0xffffffff -- Pure white
colors.bg0 = 0xff1e1e2e   -- Dark background
colors.bg1 = 0xff313244   -- Slightly lighter background / Surface
colors.bg2 = 0xff45475a   -- Lighter background / Overlay
colors.bg3 = 0xff585b70   -- Even lighter background / Muted text
colors.fg0 = 0xffcdd6f4   -- Default foreground / Text
colors.fg1 = 0xffbac2de   -- Lighter foreground / Subdued text
colors.grey = 0xff6c7086   -- Grey

-- Accent Colors (using Catppuccin Macchiato palette as an example)
colors.red = 0xffed8796
colors.orange = 0xfff5a97f
colors.yellow = 0xffeed49f
colors.green = 0xffa6da95
colors.teal = 0xff8bd5ca
colors.sky = 0xff91d7e3
colors.blue = 0xff8aadf4
colors.lavender = 0xffb7bdf8
colors.pink = 0xfff5bde6
colors.mauve = 0xffc6a0f6
colors.cyan = 0xff74c7ec -- Added cyan as it was used in spaces.lua

return colors 