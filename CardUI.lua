import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.*"
import "android.graphics.drawable.*"
import "android.graphics.*"

local context = activity
local windowManager = context.getSystemService("window")

-- Window Parameters
local layoutParams = WindowManager.LayoutParams()
if Build.VERSION.SDK_INT >= 26 then
    layoutParams.type = 2038 -- TYPE_APPLICATION_OVERLAY
else
    layoutParams.type = 2003 -- TYPE_PHONE
end

layoutParams.format = PixelFormat.RGBA_8888
layoutParams.flags = 8 or 32 
layoutParams.width = WindowManager.LayoutParams.WRAP_CONTENT
layoutParams.height = WindowManager.LayoutParams.WRAP_CONTENT
layoutParams.gravity = Gravity.CENTER

-- UI Helper Functions
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

-- Base Layout Container
local mainContainer = LinearLayout(context)
mainContainer.setOrientation(LinearLayout.VERTICAL)
mainContainer.setBackground(createShape("#1A1A24", 24, 2, "#00E5FF"))
mainContainer.setPadding(30, 30, 30, 30)

-- Header text
local titleText = TextView(context)
titleText.setText("PRINZVAN CONSOLE V2.0")
titleText.setTextColor(Color.parseColor("#00E5FF"))
titleText.setTextSize(16)
titleText.setGravity(Gravity.CENTER)
titleText.setPadding(0, 0, 0, 15)
mainContainer.addView(titleText)

-- Horizontal Tab Layout Bar
local tabBar = LinearLayout(context)
tabBar.setOrientation(LinearLayout.HORIZONTAL)
tabBar.setGravity(Gravity.CENTER)
tabBar.setPadding(0, 0, 0, 20)
mainContainer.addView(tabBar)

-- Content Frame Container
local contentFrame = FrameLayout(context)
mainContainer.addView(contentFrame)

-- Tables to manage pages and tab view states
local pages = {}
local tabButtons = {}

local function createPage()
    local page = LinearLayout(context)
    page.setOrientation(LinearLayout.VERTICAL)
    page.setVisibility(View.GONE) 
    local match = LinearLayout.LayoutParams.MATCH_PARENT
    local wrap = LinearLayout.LayoutParams.WRAP_CONTENT
    page.setLayoutParams(LinearLayout.LayoutParams(match, wrap))
    contentFrame.addView(page)
    return page
end

-- Initialize 5 Pages
for i = 1, 5 do
    pages[i] = createPage()
end

-- Function to handle tab switching
local function switchTab(index)
    for i = 1, #pages do
        if i == index then
            pages[i].setVisibility(View.VISIBLE)
            tabButtons[i].setTextColor(Color.parseColor("#00E5FF"))
            tabButtons[i].setBackground(createShape("#2A2A3A", 8, 1, "#00E5FF"))
        else
            pages[i].setVisibility(View.GONE)
            tabButtons[i].setTextColor(Color.parseColor("#B0BEC5"))
            tabButtons[i].setBackground(createShape("#1A1A24", 8, 0, nil))
        end
    end
end

local function addTab(title, index)
    local btn = Button(context)
    
    -- FIXED: Removed all Margin parameters completely to eliminate layout crashes.
    -- Spacing is handled uniformly via button weight and structural padding.
    local w = 0
    local h = LinearLayout.LayoutParams.WRAP_CONTENT
    local params = luajava.newInstance("android.widget.LinearLayout$LayoutParams", w, h, 1.0)
    
    btn.setLayoutParams(params)
    btn.setText(title)
    btn.setTextSize(10)
    btn.setPadding(2, 12, 2, 12)
    
    btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(view)
            switchTab(index)
        end
    }))
    
    tabBar.addView(btn)
    tabButtons[index] = btn
end

-- Define Tab Titles
local tabTitles = {"Shield", "Visuals", "Drone", "Prices", "System"}
for i, title in ipairs(tabTitles) do
    addTab(title, i)
end

--------------------------------------------------
-- POPULATING THE PAGES WITH UI ELEMENTS
--------------------------------------------------

local function addPageText(page, text, color)
    local txt = TextView(context)
    txt.setText(text)
    txt.setTextColor(Color.parseColor(color or "#FFFFFF"))
    txt.setPadding(0, 10, 0, 10)
    page.addView(txt)
end

local function addPageButton(page, text, callback)
    local btn = Button(context)
    local w = LinearLayout.LayoutParams.MATCH_PARENT
    local h = LinearLayout.LayoutParams.WRAP_CONTENT
    local params = luajava.newInstance("android.widget.LinearLayout$LayoutParams", w, h)
    
    btn.setLayoutParams(params)
    btn.setText(text)
    btn.setTextColor(Color.parseColor("#FFFFFF"))
    btn.setBackground(createShape("#2A2A3A", 12, 1, "#00E5FF"))
    btn.setPadding(0, 20, 0, 20)
    btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v) callback() end
    }))
    page.addView(btn)
end

-- Page 1: Shield Content
addPageText(pages[1], "Authentication Verification Layer", "#00E5FF")
addPageButton(pages[1], "Verify Active Session Token", function()
    print("Verifying structural interface parameters...")
end)

-- Page 2: Visuals Content
addPageText(pages[2], "Visual Interface Overlays", "#B0BEC5")

-- Page 3: Drone Content
addPageText(pages[3], "Matrix Coordinates Console", "#B0BEC5")

-- Page 4: Prices Content
addPageText(pages[4], "Subscription Tiers Info", "#00E5FF")
addPageText(pages[4], "• 03 Days VIP Tier Access\n• 07 Days VIP Tier Access\n• 30 Days VIP Tier Access", "#FFFFFF")

-- Page 5: System Content
addPageText(pages[5], "UI Lifecycle Management", "#B0BEC5")
addPageButton(pages[5], "Minimize UI Overlay", function()
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            windowManager.removeView(mainContainer)
        end
    }))
end)

-- Set initial default active tab view
switchTab(1)

-- Display on Window Layer Safely
activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        windowManager.addView(mainContainer, layoutParams)
    end
}))
