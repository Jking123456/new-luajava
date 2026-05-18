import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.*"
import "android.graphics.drawable.*"
import "android.graphics.*"

local context = activity
local windowManager = context.getSystemService("window")

-- Shape Generator for Professional UI Styling
local function createShape(solidColor, cornerRadius, strokeWidth, strokeColor)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(Color.parseColor(solidColor))
    drawable.setCornerRadius(cornerRadius)
    if strokeWidth and strokeColor then
        drawable.setStroke(strokeWidth, Color.parseColor(strokeColor))
    end
    return drawable
end

local overlayType = 2003
if Build.VERSION.SDK_INT >= 26 then
    overlayType = 2038
end

--------------------------------------------------
-- 1. PREMIUM COMPACT FLOATING LOGO BUTTON
--------------------------------------------------
local iconParams = WindowManager.LayoutParams()
iconParams.type = overlayType
iconParams.format = PixelFormat.RGBA_8888
iconParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
iconParams.width = 95  
iconParams.height = 95 
iconParams.gravity = Gravity.LEFT or Gravity.TOP
iconParams.x = 80
iconParams.y = 450

local logoButton = Button(context)
logoButton.setText("P")
logoButton.setTextColor(Color.parseColor("#00E5FF"))
logoButton.setTextSize(14)
logoButton.setTypeface(Typeface.DEFAULT_BOLD)

local buttonShape = GradientDrawable()
buttonShape.setShape(GradientDrawable.OVAL)
buttonShape.setColor(Color.parseColor("#151821"))
buttonShape.setStroke(3, Color.parseColor("#00E5FF"))
logoButton.setBackground(buttonShape)

-- Floating Touch/Drag Implementation
local initialX, initialY, initialTouchX, initialTouchY
logoButton.setOnTouchListener(luajava.createProxy("android.view.View$OnTouchListener", {
    onTouch = function(view, event)
        local action = event.getAction()
        if action == MotionEvent.ACTION_DOWN then
            initialX = iconParams.x
            initialY = iconParams.y
            initialTouchX = event.getRawX()
            initialTouchY = event.getRawY()
            return true
        elseif action == MotionEvent.ACTION_MOVE then
            iconParams.x = initialX + math.floor(event.getRawX() - initialTouchX)
            iconParams.y = initialY + math.floor(event.getRawY() - initialTouchY)
            windowManager.updateViewLayout(logoButton, iconParams)
            return true
        elseif action == MotionEvent.ACTION_UP then
            local deltaX = math.abs(event.getRawX() - initialTouchX)
            local deltaY = math.abs(event.getRawY() - initialTouchY)
            if deltaX < 15 and deltaY < 15 then
                activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
                    run = function()
                        logoButton.setVisibility(View.GONE)
                        _G.PRINZ_MAIN_CONTAINER.setVisibility(View.VISIBLE)
                    end
                }))
            end
            return true
        end
        return false
    end
}))

--------------------------------------------------
-- 2. HIGH-END ASYMMETRICAL DUAL-PANEL CONSOLE
--------------------------------------------------
local mainParams = WindowManager.LayoutParams()
mainParams.type = overlayType
mainParams.format = PixelFormat.RGBA_8888
mainParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
mainParams.width = 720  -- Explicit strict layout boundary
mainParams.height = 440 -- Forced structured height boundary
mainParams.gravity = Gravity.CENTER

-- Root wrapper to block screen leaks
local rootWrapper = FrameLayout(context)
_G.PRINZ_MAIN_CONTAINER = rootWrapper

-- Outer UI Framework Card Box
local mainCard = LinearLayout(context)
mainCard.setOrientation(LinearLayout.VERTICAL)
mainCard.setBackground(createShape("#111319", 24, 2, "#1F2533"))
mainCard.setPadding(25, 20, 25, 25)
mainCard.setLayoutParams(FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT))
rootWrapper.addView(mainCard)

-- Header Section: Brand Title & Sleek Close Cross Button
local headerBar = LinearLayout(context)
headerBar.setOrientation(LinearLayout.HORIZONTAL)
headerBar.setGravity(Gravity.CENTER_VERTICAL)
headerBar.setPadding(10, 0, 5, 15)

local titleText = TextView(context)
titleText.setText("PRINZVAN SYSTEM CONSOLE V2.0")
titleText.setTextColor(Color.parseColor("#00E5FF"))
titleText.setTextSize(11)
titleText.setTypeface(Typeface.DEFAULT_BOLD)
titleText.setLetterSpacing(0.05)
local titleParams = LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1.0)
titleText.setLayoutParams(titleParams)
headerBar.addView(titleText)

local closeButton = TextView(context)
closeButton.setText("×")
closeButton.setTextColor(Color.parseColor("#9CA3AF"))
closeButton.setTextSize(22)
closeButton.setPadding(15, 0, 5, 5)
closeButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
            run = function()
                _G.PRINZ_MAIN_CONTAINER.setVisibility(View.GONE)
                logoButton.setVisibility(View.VISIBLE)
            end
        }))
    end
}))
headerBar.addView(closeButton)
mainCard.addView(headerBar)

-- Core Content Core: Asymmetrical Left Sidebar & Right View Screen
local splitWorkspace = LinearLayout(context)
splitWorkspace.setOrientation(LinearLayout.HORIZONTAL)
local workspaceParams = LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 0, 1.0)
splitWorkspace.setLayoutParams(workspaceParams)
mainCard.addView(splitWorkspace)

-- LEFT SIDEBAR NAVIGATION PANEL
local leftNavMenu = LinearLayout(context)
leftNavMenu.setOrientation(LinearLayout.VERTICAL)
leftNavMenu.setBackground(createShape("#0A0C10", 16, 1, "#151922"))
leftNavMenu.setPadding(12, 12, 12, 12)
local leftParams = LinearLayout.LayoutParams(180, LinearLayout.LayoutParams.MATCH_PARENT)
leftParams.rightMargin = 20
leftNavMenu.setLayoutParams(leftParams)
splitWorkspace.addView(leftNavMenu)

-- RIGHT DISPLAY VIEW CANVAS SCREEN
local rightContentScreen = FrameLayout(context)
rightContentScreen.setBackground(createShape("#0E1117", 16, 1, "#1F2533"))
rightContentScreen.setPadding(25, 25, 25, 25)
local rightParams = LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.MATCH_PARENT, 1.0)
rightContentScreen.setLayoutParams(rightParams)
splitWorkspace.addView(rightContentScreen)

local pages = {}
local tabButtons = {}

local function createPage()
    local page = LinearLayout(context)
    page.setOrientation(LinearLayout.VERTICAL)
    page.setVisibility(View.GONE)
    page.setLayoutParams(FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT))
    rightContentScreen.addView(page)
    return page
end

-- Generate isolated multi-tab viewport layers
for i = 1, 5 do pages[i] = createPage() end

-- Tab Switching State Matrix Engine
local function switchTab(index)
    for i = 1, #pages do
        if i == index then
            pages[i].setVisibility(View.VISIBLE)
            tabButtons[i].setTextColor(Color.parseColor("#00E5FF"))
            tabButtons[i].setBackground(createShape("#14212D", 10, 1, "#00E5FF"))
        else
            pages[i].setVisibility(View.GONE)
            tabButtons[i].setTextColor(Color.parseColor("#6B7280"))
            tabButtons[i].setBackground(createShape("#0A0C10", 10, 0, nil))
        end
    end
end

-- Left Sidebar Navigation Tab Button Constructor
local function addVerticalTab(title, index)
    local tabBtn = Button(context)
    local params = LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 68) -- Static tight text button frames
    if index > 1 then params.topMargin = 10 end
    tabBtn.setLayoutParams(params)
    tabBtn.setText(title)
    tabBtn.setTextSize(9)
    tabBtn.setTransformationMethod(nil) -- Stop capitalization bypass bugs
    tabBtn.setPadding(0, 0, 0, 0)
    tabBtn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v) switchTab(index) end
    }))
    leftNavMenu.addView(tabBtn)
    tabButtons[index] = tabBtn
end

local tabTitles = {"Shield", "Visuals", "Drone", "Prices", "System"}
for i, title in ipairs(tabTitles) do addVerticalTab(title, i) end

--------------------------------------------------
-- RENDER ELEMENTS INTERFACE FACTORY
--------------------------------------------------
local function addPageText(page, text, color)
    local txt = TextView(context)
    txt.setText(text)
    txt.setTextColor(Color.parseColor(color or "#E5E7EB"))
    txt.setPadding(0, 2, 0, 10)
    txt.setTextSize(11)
    page.addView(txt)
end

local function addPageButton(page, text, callback)
    local spaceContainer = LinearLayout(context)
    spaceContainer.setPadding(0, 5, 0, 0)
    
    local btn = Button(context)
    btn.setText(text)
    btn.setTextColor(Color.parseColor("#11141A"))
    btn.setTypeface(Typeface.DEFAULT_BOLD)
    btn.setTextSize(10.5)
    btn.setBackground(createShape("#00E5FF", 10, 0, nil)) 
    btn.setPadding(0, 12, 0, 12)
    btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v) callback() end
    }))
    
    spaceContainer.addView(btn, LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
    page.addView(spaceContainer)
end

-- Populate Custom Tab Contents
addPageText(pages[1], "Authentication Verification Layer", "#00E5FF")
addPageText(pages[1], "Status: Active Session Node Secure", "#9CA3AF")
addPageButton(pages[1], "VERIFY ACTIVE SESSION TOKEN", function()
    gg.toast("Session verification check completed.")
end)

addPageText(pages[2], "Visual Mapping Engine", "#00E5FF")
addPageText(pages[2], "• Perceptual Map Environment Frame\n• High-Fidelity Geometry ESP", "#9CA3AF")

addPageText(pages[3], "Matrix drone Configurations", "#00E5FF")
addPageText(pages[3], "Current Height Aspect: 15 meters", "#9CA3AF")

addPageText(pages[4], "Premium Store Tier Profiles", "#00E5FF")
addPageText(pages[4], "• 03 Days Premium VIP Pass -> ₱45\n• 07 Days Premium VIP Pass -> ₱85\n• Lifetime Engine Pass Access -> ₱650", "#E5E7EB")

addPageText(pages[5], "UI Window Lifecycle Matrix", "#9CA3AF")
addPageButton(pages[5], "CLOSE UI WINDOW", function()
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            windowManager.removeView(_G.PRINZ_MAIN_CONTAINER)
            windowManager.removeView(logoButton)
        end
    }))
end)

-- Default to first screen layer
switchTab(1)

--------------------------------------------------
-- RENDER MOUNT INITIALIZATION RUNNER
--------------------------------------------------
activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        windowManager.addView(logoButton, iconParams)
        logoButton.setVisibility(View.GONE) 
        
        windowManager.addView(_G.PRINZ_MAIN_CONTAINER, mainParams)
    end
}))

while true do
    gg.sleep(100)
end
