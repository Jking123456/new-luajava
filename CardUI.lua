--------------------------------------------------
--- PRINZVAN FREE LUA SCRIPT 2.0 (DE-CLOUDED) ---
--------------------------------------------------

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.*"
import "android.graphics.drawable.*"
import "android.graphics.*"

local context = activity
local windowManager = context.getSystemService("window")

-- Window setup
local layoutParams = WindowManager.LayoutParams()
if Build.VERSION.SDK_INT >= 26 then
    layoutParams.type = 2038 -- TYPE_APPLICATION_OVERLAY
else
    layoutParams.type = 2003 -- TYPE_PHONE / TYPE_SYSTEM_ALERT
end

layoutParams.format = PixelFormat.RGBA_8888
layoutParams.flags = 8 or 32 -- FLAG_NOT_FOCUSABLE or FLAG_NOT_TOUCH_MODAL
layoutParams.width = WindowManager.LayoutParams.WRAP_CONTENT
layoutParams.height = WindowManager.LayoutParams.WRAP_CONTENT
layoutParams.gravity = Gravity.CENTER

-- Core Memory Engine Global Tracking Variables
local scanned = false
local V1, V2, V3, V4, V5 = {}, {}, {}, {}, {}

-- Native UI Styling Helper
local function createShape(solidColor, cornerRadius, strokeWidth, strokeColor)
    local drawable = luajava.newInstance("android.graphics.drawable.GradientDrawable")
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(Color.parseColor(solidColor))
    drawable.setCornerRadius(cornerRadius)
    if strokeWidth and strokeColor then
        drawable.setStroke(strokeWidth, Color.parseColor(strokeColor))
    end
    return drawable
end

--------------------------------------------------
-- [1] GAME ENGINE CORE LOGIC MODULES
--------------------------------------------------

local function BYPASS()
    gg.toast("⏳ Initializing Bypass...")
    local sutax = gg.getRangesList("libcsharp.so")
    local stx = nil

    for i, v in ipairs(sutax) do
        if v.state == "Xa" then stx = v.start; break end
    end

    if stx == nil then 
        gg.alert("❌ Error: libcsharp.so not found!") 
        return 
    end

    local bypass_offsets = {
        {0xB88D7C, "hA77B40B2C0035FD6"}, {0xC7042C, "hA77B40B2C0035FD6"},
        {0xC68918, "hA77B40B2C0035FD6"}, {0xC70240, "hA77B40B2C0035FD6"},
        {0x211E9CC, "hA77B40B2C0035FD6"}, {0x211E9C4, "hA77B40B2C0035FD6"},
        {0x211E214, "hA77B40B2C0035FD6"}, {0x211E2D0, "hA77B40B2C0035FD6"},
        {0x211E59C, "hA77B40B2C0035FD6"}, {0x211E3F0, "hA77B40B2C0035FD6"},
        {0x211E4A0, "hA77B40B2C0035FD6"}, {0xA24D2C, "hA77B40B2C0035FD6"},
        {0xA24D40, "hA77B40B2C0035FD6"}, {0xA372C0, "hA77B40B2C0035FD6"},
        {0x203DB60, "hA77B40B2C0035FD6"}, {0x707EE8, "hA77B40B2C0035FD6"},
        {0x6F6020, "hA77B40B2C0035FD6"}, {0x506870, "hA77B40B2C0035FD6"},
        {0x4D1970, "hA77B40B2C0035FD6"}, {0x4FF95C, "hA77B40B2C0035FD6"},
        {0x121F0B8, "hA77B40B2C0035FD6"}, {0x7352BC, "hA77B40B2C0035FD6"},
        {0x155C820, "hA77B40B2C0035FD6"}
    }

    local values = {}
    for i, v in ipairs(bypass_offsets) do
        table.insert(values, {address = stx + v[1], flags = gg.TYPE_QWORD, value = v[2]})
    end
    gg.setValues(values)
    gg.toast("🛡️ BYPASS ACTIVATED")
end

local function fullsight()
    gg.setVisible(false)
    gg.toast("SEARCHING LIBCSHARP.SO...")
    local sutax = gg.getRangesList("libcsharp.so")
    local stx = nil

    for i, v in ipairs(sutax) do
        if v.state == "Xa" then stx = v.start; break end
    end

    if stx == nil then
        gg.alert("❌ Error: libcsharp.so not found!")
        return
    end

    local offsets = {
        {0xB88D7C, "hA77B40B2C0035FD6"}, {0xC7042C, "hA77B40B2C0035FD6"},
        {0xC68918, "hA77B40B2C0035FD6"}, {0xC70240, "hA77B40B2C0035FD6"},
        {0x211E9CC, "hA77B40B2C0035FD6"}, {0x211E9C4, "hA77B40B2C0035FD6"},
        {0x211E214, "hA77B40B2C0035FD6"}, {0x211E2D0, "hA77B40B2C0035FD6"},
        {0x211E59C, "hA77B40B2C0035FD6"}, {0x211E3F0, "hA77B40B2C0035FD6"},
        {0x211E4A0, "hA77B40B2C0035FD6"}, {0xA24D2C, "hA77B40B2C0035FD6"},
        {0xA24D40, "hA77B40B2C0035FD6"}, {0xA372C0, "hA77B40B2C0035FD6"},
        {0x203DB60, "hA77B40B2C0035FD6"}, {0x707EE8, "hA77B40B2C0035FD6"},
        {0x6F6020, "hA77B40B2C0035FD6"}, {0x506870, "hA77B40B2C0035FD6"},
        {0x4D1970, "hA77B40B2C0035FD6"}, {0x4FF95C, "hA77B40B2C0035FD6"},
        {0x121F0B8, "hA77B40B2C0035FD6"}, {0x7352BC, "hA77B40B2C0035FD6"},
        {0x155C820, "hA77B40B2C0035FD6"}, {0x96A4CC, "hA07B40B2C0035FD6"},
        {0x992EA8, "hA07B40B2C0035FD6"}
    }

    local values = {}
    for i, v in ipairs(offsets) do
        table.insert(values, {address = stx + v[1], flags = gg.TYPE_QWORD, value = v[2]})
    end
    gg.setValues(values)
    gg.toast("✅ FULLSIGHT ACTIVATED")
end

local function scanDrone()
    gg.toast("🔍 Scanning matrix coordinates...")
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    local function doScan(num)
        gg.searchNumber(num, gg.TYPE_FLOAT)
        local r = gg.getResults(500)
        gg.clearResults()
        return r
    end
    V1, V2, V3, V4, V5 = doScan("7.65999984741"), doScan("-10.97999954224"), doScan("7.61999988556"), doScan("-7.65999984741"), doScan("-7.61999988556")
    if #V1 > 0 then scanned = true; gg.toast("✅ Drone Ready") else gg.alert("❌ Scan Failed") end
end

local function applyDrone(csv)
    if not scanned then gg.toast("⚠️ Scan Drone First!"); return end
    local vals = {}
    for v in string.gmatch(csv, '([^,]+)') do table.insert(vals, v) end
    local lists = {V1, V2, V3, V4, V5}
    for i, list in ipairs(lists) do
        if list and #list > 0 then
            gg.loadResults(list)
            local r = gg.getResults(#list)
            for j, v in ipairs(r) do v.value = vals[i] end
            gg.setValues(r)
            gg.clearResults()
        end
    end
    gg.toast("Camera Updated Successfully")
end

--------------------------------------------------
-- [2] PREMIUM INTERFACE BUILDER (NATIVE JAVA)
--------------------------------------------------

-- Layout Canvas setup
local mainLayout = LinearLayout(context)
mainLayout.setOrientation(LinearLayout.VERTICAL)
mainLayout.setBackground(createShape("#1A1A24", 24, 2, "#00E5FF")) -- Deep Canvas, Neon Border
mainLayout.setPadding(40, 40, 40, 40)

local headerText = TextView(context)
headerText.setText("PRINZVAN SYSTEM CONFIG V2.0")
headerText.setTextColor(Color.parseColor("#00E5FF"))
headerText.setTextSize(16)
headerText.setGravity(Gravity.CENTER)
headerText.setPadding(0, 5, 0, 15)
mainLayout.addView(headerText)

local function addLabel(text, hexColor, size)
    local txt = TextView(context)
    txt.setText(text)
    txt.setTextColor(Color.parseColor(hexColor))
    txt.setTextSize(size or 12)
    txt.setPadding(0, 5, 0, 5)
    mainLayout.addView(txt)
end

local function addButton(text, onClickFunction)
    local btn = Button(context)
    local w = LinearLayout.LayoutParams.MATCH_PARENT
    local h = LinearLayout.LayoutParams.WRAP_CONTENT
    local params = luajava.newInstance("android.widget.LinearLayout$LayoutParams", w, h)
    params.leftMargin = 0; params.topMargin = 10; params.rightMargin = 0; params.bottomMargin = 10
    
    btn.setLayoutParams(params)
    btn.setText(text)
    btn.setTextColor(Color.parseColor("#FFFFFF"))
    btn.setBackground(createShape("#00E5FF", 12, 0, nil))
    btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(view) onClickFunction() end
    }))
    mainLayout.addView(btn)
end

local function addSwitch(text, onToggleFunction, offToggleFunction)
    local row = LinearLayout(context)
    row.setOrientation(LinearLayout.HORIZONTAL)
    row.setGravity(Gravity.CENTER_VERTICAL)
    row.setPadding(0, 10, 0, 10)
    
    local txt = TextView(context)
    txt.setText(text)
    txt.setTextColor(Color.parseColor("#B0BEC5"))
    txt.setTextSize(13)
    
    local txtParams = luajava.newInstance("android.widget.LinearLayout$LayoutParams", 0, LinearLayout.LayoutParams.WRAP_CONTENT, 1.0)
    txt.setLayoutParams(txtParams)
    
    local sw = Switch(context)
    sw.setOnCheckedChangeListener(luajava.createProxy("android.widget.CompoundButton$OnCheckedChangeListener", {
        onCheckedChanged = function(buttonView, isChecked)
            if isChecked then onToggleFunction() else if offToggleFunction then offToggleFunction() end end
        end
    }))
    
    row.addView(txt)
    row.addView(sw)
    mainLayout.addView(row)
end

--------------------------------------------------
-- [3] COMPONENT INJECTION (POPULATING VIEWS)
--------------------------------------------------

addLabel("PLAN Status: FREE USER MODULE ACTIVE", "#00FF00", 12)

addSwitch("Configuration Bypass Protection", function() BYPASS() end)
addSwitch("Visual Perception (Fullsight)", function() fullsight() end)

addButton("SCAN CAMERA ENGINE", function() scanDrone() end)
addButton("SET DRONE VIEW X1 (10m)", function() applyDrone("10,-15,10,-10,-10") end)
addButton("SET DRONE VIEW X2 (15m)", function() applyDrone("15,-20,15,-15,-15") end)
addButton("RESET CAMERA CORE MATRIX", function() applyDrone("7.66,-10.98,7.62,-7.66,-7.62") end)

addButton("FLUSH RESIDUAL MEMORY CACHE", function() 
    gg.clearResults() 
    gg.toast("Memory Cache Flushed Clean") 
end)

addButton("CLOSE UI CONSOLE WINDOW", function()
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            windowManager.removeView(mainLayout)
            gg.toast("Console Interface Hidden.")
        end
    }))
end)

--------------------------------------------------
-- [4] RENDER LAYER
--------------------------------------------------
activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        windowManager.addView(mainLayout, layoutParams)
    end
}))
