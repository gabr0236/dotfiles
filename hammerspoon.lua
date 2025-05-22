--------------------------------------------------------------
--  Hyper-key app launcher with window cycling
--------------------------------------------------------------
local hyper = {"ctrl", "alt", "cmd", "shift"}

-- 1-letter quick-launch table  (extend at will)
local apps = {
  c = "Google Chrome",
  t = "iTerm",           -- or "Terminal"
  r = "Rider",
  d = "DataGrip",
  w = "WebStorm",
  g = "ChatGPT",
  n = "Notes",
}

-- Helper: cycle windows in the given direction
local function cycleWindows(forward)
  local mods = forward and {"cmd"} or {"cmd", "shift", "alt"}
  hs.eventtap.keyStroke(mods, "`", 0)   -- 0 = no delay
end

-- Bind every entry in the table
for key, appName in pairs(apps) do
  ----------------------------------------------------------------
  -- Hyper + letter : launch / focus / cycle forward
  ----------------------------------------------------------------
  hs.hotkey.bind(hyper, key, function()
    local target = hs.appfinder.appFromName(appName)

    -- If not running → launch & bail out
    if not target then
      hs.application.launchOrFocus(appName)
      return
    end

    local front = hs.application.frontmostApplication()

    if front and front:bundleID() == target:bundleID() then
      -- App already front-most → cycle its windows forward
      cycleWindows(true)
    else
	-- App is running but in background or minimized

    	-- Unminimize at least one window
    	local win = target:mainWindow() or target:allWindows()[1]
    	if win and win:isMinimized() then
	  win:unminimize()
    	end

	target:activate(true)
    end
  end)
end
