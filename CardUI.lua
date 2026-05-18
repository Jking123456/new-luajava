-- MyCustomCardUI.lua
-- Host this updated file online on GitHub, Pastebin, or Gitee.

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.*"
import "android.graphics.drawable.*"
import "android.graphics.*"

local context = activity
local windowManager = context.getSystemService("window")

local layoutParams = WindowManager.LayoutParams()
if Build.VERSION.SDK_INT >= 26 then
    layoutParams.type = 2038 -- TYPE_APPLICATION_OVERLAY
else
    layoutParams.type = 2003 -- TYPE_PHONE / TYPE_SYSTEM_ALERT
end

layoutParams.format = PixelFormat.RGBA_8888
layoutParams.flags = 8 or 32 
layoutParams.width = WindowManager.LayoutParams.WRAP_CONTENT
layoutParams.height = WindowManager.LayoutParams.WRAP_CONTENT
layoutParams.gravity = Gravity.CENTER

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

local mainLayout = LinearLayout(context)
mainLayout.setOrientation(LinearLayout.VERTICAL)
mainLayout.setBackground(createShape("#1A1A24", 24, 2, "#00E5FF")) 
mainLayout.setPadding(40, 40, 40, 40)

local headerText = TextView(context)
headerText.setText("PRINZVAN SYSTEM CONFIG")
headerText.setTextColor(Color.parseColor("#00E5FF"))
headerText.setTextSize(18)
headerText.setGravity(Gravity.CENTER)
headerText.setPadding(0, 10, 0, 20)
mainLayout.addView(headerText)

local separator = View(context)
local sepParams = LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 2)
separator.setLayoutParams(sepParams)
separator.setBackgroundColor(Color.parseColor("#2A2A3A"))
mainLayout.addView(separator)

-- Native Component Creator: Buttons
local function addButton(text, onClickFunction)
    local btn = Button(context)
    -- FIXED: Use explicit width, height values to avoid instantiation gaps
    local w = LinearLayout.LayoutParams.MATCH_PARENT
    local h = LinearLayout.LayoutParams.WRAP_CONTENT
    local params = luajava.newInstance("android.widget.LinearLayout$LayoutParams", w, h)
    
    -- FIXED: Replaced call style with clear direct table margin assignments 
    params.leftMargin = 0
    params.topMargin = 15
    params.rightMargin = 0
    params.bottomMargin = 15
    
    btn.setLayoutParams(params)
    btn.setText(text)
    btn.setTextColor(Color.parseColor("#FFFFFF"))
    btn.setBackground(createShape("#00E5FF", 12, 0, nil))
    btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(view)
            onClickFunction()
        end
    }))
    mainLayout.addView(btn)
end

-- Native Component Creator: Toggles
local function addSwitch(text, onToggleFunction)
    local row = LinearLayout(context)
    row.setOrientation(LinearLayout.HORIZONTAL)
    row.setGravity(Gravity.CENTER_VERTICAL)
    row.setPadding(0, 15, 0, 15)
    
    local txt = TextView(context)
    txt.setText(text)
    txt.setTextColor(Color.parseColor("#B0BEC5"))
    txt.setTextSize(14)
    
    local w = 0
    local h = LinearLayout.LayoutParams.WRAP_CONTENT
    local txtParams = luajava.newInstance("android.widget.LinearLayout$LayoutParams", w, h, 1.0)
    txt.setLayoutParams(txtParams)
    
    local sw = Switch(context)
    sw.setOnCheckedChangeListener(luajava.createProxy("android.widget.CompoundButton$OnCheckedChangeListener", {
        onCheckedChanged = function(buttonView, isChecked)
            onToggleFunction(isChecked)
        end
    }))
    
    row.addView(txt)
    row.addView(sw)
    mainLayout.addView(row)
end

-- Layout Controls
addSwitch("Configuration Status Layer", function(isChecked)
    gg.toast("Configuration framework changed: " .. tostring(isChecked))
end)

addSwitch("Visual Framework Perception", function(isChecked)
    gg.toast("Visual perception matrix changed: " .. tostring(isChecked))
end)

addButton("EXECUTE CODES", function()
    gg.toast("Executing runtime parameters...")
end)

addButton("CLOSE UI WINDOW", function()
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            windowManager.removeView(mainLayout)
            gg.toast("UI Thread Terminated.")
        end
    }))
end)

-- Render on Main Thread
activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        windowManager.addView(mainLayout, layoutParams)
    end
}))
