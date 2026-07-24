-- plugins/space.lua

-- This script is called when space events occur for items
-- that reference it.

-- The event details are available in the `env` table
-- For space changes, env.SELECTED tells if the space is selected
-- env.SID gives the space ID

-- Example: Log the event (useful for debugging)
-- sbar.log("Space event: SID=" .. env.SID .. ", SELECTED=" .. env.SELECTED)

-- Placeholder function - does nothing yet
local function handle_space_change(env)
  -- Logic to update icon/label based on env.SELECTED or other properties
  -- will go here.
  -- For example:
  -- if env.SELECTED == "true" then
  --   sbar.set("space." .. env.SID, { label = { drawing = true } })
  -- else
  --   sbar.set("space." .. env.SID, { label = { drawing = false } })
  -- end
end

-- Return the handler function so sketchybar can call it
return handle_space_change 