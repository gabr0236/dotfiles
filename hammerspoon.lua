--------------------------------------------------------------
-- Hyper-key app launcher with window cycling (including minimized)
--------------------------------------------------------------

local hyper = {"ctrl", "alt", "cmd", "shift"}

-- 1-letter quick-launch table (extend at will)
local apps = {
    a = "Claude",
    c = "Google Chrome",
    t = "iTerm",
    r = "Rider",
    d = "DataGrip",
    w = "WebStorm",
    g = "ChatGPT",
    n = "Notes",
    s = "Slack",
    l = "Linear",
    p = "Postman 2",
    m = "Spotify",
}

-- Track last focused window per app
local lastFocusedWindow = {}

-- Helper: get all windows for an app, sorted by visibility and focus
local function getWindowsSorted(app)
    local windows = app:allWindows()
    if not windows or #windows == 0 then
        return {}
    end
    
    -- Separate visible and minimized windows
    local visible = {}
    local minimized = {}
    
    for _, win in ipairs(windows) do
        if win:isMinimized() then
            table.insert(minimized, win)
        else
            table.insert(visible, win)
        end
    end
    
    -- Sort visible windows by focus order (most recently focused first)
    table.sort(visible, function(a, b)
        -- The focused window should come first
        if a:id() == app:focusedWindow():id() then return true end
        if b:id() == app:focusedWindow():id() then return false end
        return false
    end)
    
    -- Combine: visible windows first, then minimized
    local sorted = {}
    for _, win in ipairs(visible) do
        table.insert(sorted, win)
    end
    for _, win in ipairs(minimized) do
        table.insert(sorted, win)
    end
    
    return sorted
end

-- Helper: find next window to focus
local function getNextWindow(app)
    local windows = getWindowsSorted(app)
    if #windows == 0 then
        return nil
    end
    
    local focusedWin = app:focusedWindow()
    local lastWin = lastFocusedWindow[app:bundleID()]
    
    -- If we have a focused window, find the next one in cycle
    if focusedWin then
        for i, win in ipairs(windows) do
            if win:id() == focusedWin:id() then
                -- Return next window in list (wrap around)
                local nextIndex = (i % #windows) + 1
                return windows[nextIndex]
            end
        end
    end
    
    -- If we tracked a last window and it still exists, try the next one after it
    if lastWin then
        for i, win in ipairs(windows) do
            if win:id() == lastWin then
                local nextIndex = (i % #windows) + 1
                return windows[nextIndex]
            end
        end
    end
    
    -- Default to first window (prioritize visible over minimized)
    return windows[1]
end

-- Bind every entry in the table
for key, appName in pairs(apps) do
    ----------------------------------------------------------------
    -- Hyper + letter : launch / focus / cycle through all windows
    ----------------------------------------------------------------
    hs.hotkey.bind(hyper, key, function()
        local target = hs.appfinder.appFromName(appName)
        
        -- If not running → launch & bail out
        if not target then
            hs.application.launchOrFocus(appName)
            return
        end
        
        local front = hs.application.frontmostApplication()
        local windows = target:allWindows()
        
        -- No windows? Just activate the app
        if not windows or #windows == 0 then
            target:activate(true)
            return
        end
        
        if front and front:bundleID() == target:bundleID() then
            -- App is already frontmost → cycle to next window
            local nextWin = getNextWindow(target)
            
            if nextWin then
                if nextWin:isMinimized() then
                    nextWin:unminimize()
                end
                nextWin:focus()
                lastFocusedWindow[target:bundleID()] = nextWin:id()
            end
        else
            -- App is not frontmost → focus it
            -- Priority: visible focused window > visible windows > minimized windows
            local focusedWin = target:focusedWindow()
            local visibleWindows = {}
            local minimizedWindows = {}
            
            for _, win in ipairs(windows) do
                if win:isMinimized() then
                    table.insert(minimizedWindows, win)
                else
                    table.insert(visibleWindows, win)
                end
            end
            
            local winToFocus = nil
            
            -- First try: focused window if visible
            if focusedWin and not focusedWin:isMinimized() then
                winToFocus = focusedWin
            -- Second try: any visible window
            elseif #visibleWindows > 0 then
                winToFocus = visibleWindows[1]
            -- Last resort: unminimize first minimized window
            elseif #minimizedWindows > 0 then
                winToFocus = minimizedWindows[1]
                winToFocus:unminimize()
            end
            
            if winToFocus then
                winToFocus:focus()
                lastFocusedWindow[target:bundleID()] = winToFocus:id()
            else
                target:activate(true)
            end
        end
    end)
end
