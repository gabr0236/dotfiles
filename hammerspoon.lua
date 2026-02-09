--------------------------------------------------------------
--  Hyper-key app launcher with window cycling
--------------------------------------------------------------
local hyper = {"ctrl", "alt", "cmd", "shift"}

-- 1-letter quick-launch table  (extend at will)
local apps = {
  a = "Claude",
  c = "Google Chrome",
  t = "Terminal",
  r = "Rider",
  d = "DataGrip",
  w = "WebStorm",
  g = "ChatGPT",
  n = "Notes",
  s = "Slack",
  l = "Linear",
  p = "Postman 2",
  m = "Spotify",
  j = "Journal",
}

local function cycleAppWindows()
  local app = hs.application.frontmostApplication()
  if not app then return end

  local allWins = app:allWindows()
  local windows = {}
  for _, w in ipairs(allWins) do
    if not w:isMinimized() then
      windows[#windows + 1] = w
    end
  end
  if #windows < 2 then return end

  table.sort(windows, function(a, b) return a:id() < b:id() end)

  local focused = hs.window.focusedWindow()
  local current = 1
  for i, w in ipairs(windows) do
    if w:id() == focused:id() then
      current = i
      break
    end
  end

  windows[(current % #windows) + 1]:focus()
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
      cycleAppWindows()
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

