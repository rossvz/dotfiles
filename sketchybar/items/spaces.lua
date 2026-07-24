-- items/spaces.lua

local colors = require("colors") -- Assuming colors are defined in colors.lua

-- Settings for individual space items
local space_settings = {
  icon = {
    font = "Hack Nerd Font:Regular:16.0",
    padding_left = 8,
    padding_right = 8,
    color = colors.fg1, -- Default icon color
  },
  label = {
    font = "Hack Nerd Font:Bold:11.0",
    padding_right = 8,
    color = colors.fg1, -- Default label color
    drawing = false, -- Initially hide labels, maybe show for active space?
  },
  background = {
    color = colors.bg1, -- Default background
    height = 24,
    corner_radius = 5,
    border_width = 1,
    border_color = colors.bg3,
  },
  padding_left = 4,
  padding_right = 4,
  updates = true, -- Update when space changes
  script = "$CONFIG_DIR/plugins/space.lua", -- Link to our Lua plugin
}

-- Settings for the selected space
local selected_settings = {
  background = {
    color = colors.blue, -- Highlight color for selected space
    border_color = colors.cyan,
  },
  icon = {
    color = colors.bg1, -- Icon color on selected background
  },
  label = {
    color = colors.bg1, -- Label color on selected background
  },
}

-- Function to create space items
local function create_spaces()
  local spaces = {}
  -- You might need to adjust the number of spaces (e.g., 10 here)
  for i = 1, 10 do
    local sid = tostring(i)
    local space_item = {
      label = sid, -- Use number as label for now
      icon = sid, -- Use number as icon for now
      space = sid,
      click_script = "sketchybar --trigger space_click ".. sid, -- Trigger a custom event on click
    }
    -- Apply default settings
    for k, v in pairs(space_settings) do
      space_item[k] = v
    end

    -- Define the item in sketchybar
    sbar.add("item", "space." .. sid, space_item)
    -- Apply selected appearance when the space is selected
    sbar.add("subscribe", "space." .. sid, "space_change", {
      handler = function(env)
        if env.SELECTED == "true" then
          sbar.set("space." .. sid, selected_settings)
        else
          -- Reset to default appearance (inverse of selected_settings)
          -- This requires knowing the original values; might need refinement
          -- For simplicity now, just resetting background color
          sbar.set("space." .. sid, {
             background = { color = space_settings.background.color, border_color = space_settings.background.border_color },
             icon = { color = space_settings.icon.color },
             label = { color = space_settings.label.color }
          })
        end
      end
    })
  end
end

-- Run the function to create the spaces
create_spaces()

-- Add a log message to confirm execution (check /tmp/sketchybar_$USER.out.log)
sbar.log("Simplified items/spaces.lua executed.") 