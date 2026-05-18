import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.*"
import "android.graphics.drawable.*"
import "android.graphics.*"

local context = activity
local windowManager = context.getSystemService("window")

-- Shape Generator for Borders & Backgrounds
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
-- INITIALIZE CONTAINERS
--------------------------------------------------
local iconContainer = LinearLayout(context)
local mainContainer = LinearLayout(context)

--------------------------------------------------
-- 1. FLOATING LOGO SETUP (ZERO-NETWORK SYSTEM)
--------------------------------------------------
local iconParams = WindowManager.LayoutParams()
if Build.VERSION.SDK_INT >= 26 then
    iconParams.type = 2038
else
    iconParams.type = 2003
end
iconParams.format = PixelFormat.RGBA_8888
iconParams.flags = 8 or 32
iconParams.width = 120
iconParams.height = 120
iconParams.gravity = Gravity.LEFT or Gravity.TOP
iconParams.x = 100
iconParams.y = 300

-- Create a clean glowing button design instead of an unstable web image loader
local logoButton = TextView(context)
logoButton.setGravity(Gravity.CENTER)
logoButton.setText("P")
logoButton.setTextColor(Color.parseColor("#00E5FF"))
logoButton.setTextSize(20)
logoButton.setTypeface(Typeface.DEFAULT_BOLD)
logoButton.setBackground(createShape("#1A1A24", 60, 3, "#00E5FF"))

iconContainer.addView(logoButton)

--------------------------------------------------
-- DRAG LOGIC FOR FLOATING ICON
--------------------------------------------------
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
            windowManager.updateViewLayout(iconContainer, iconParams)
            return true
        elseif action == MotionEvent.ACTION_UP then
            local deltaX = math.abs(event.getRawX() - initialTouchX)
            local deltaY = math.abs(event.getRawY() - initialTouchY)
            if deltaX < 10 and deltaY < 10 then
                activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
                    run = function()
                        iconContainer.setVisibility(View.GONE)
                        mainContainer.setVisibility(View.VISIBLE)
                    end
                }))
            end
            return true
        end
        return false
    end
}))

--------------------------------------------------
-- 2. MAIN CARD CANVAS
--------------------------------------------------
local mainParams = WindowManager.LayoutParams()
if Build.VERSION.SDK_INT >= 26 then
    mainParams.type = 2038
else
    mainParams.type = 2003
end
mainParams.format = PixelFormat.RGBA_8888
mainParams.flags = 8 or 32
mainParams.width = WindowManager.LayoutParams.WRAP_CONTENT
mainParams.height = WindowManager.LayoutParams.WRAP_CONTENT
mainParams.gravity = Gravity.CENTER

mainContainer.setOrientation(LinearLayout.VERTICAL)
mainContainer.setBackground(createShape("#1A1A24", 24, 2, "#00E5FF"))
mainContainer.setPadding(35, 25, 35, 35)
mainContainer.setVisibility(View.GONE)

-- Header Bar Layout
local headerBar = LinearLayout(context)
headerBar.setOrientation(LinearLayout.HORIZONTAL)
headerBar.setGravity(Gravity.CENTER_VERTICAL)
headerBar.setPadding(0, 0, 0, 15)

local titleText = TextView(context)
titleText.setText("PRINZVAN SYSTEM CONFIG V2.0")
titleText.setTextColor(Color.parseColor("#00E5FF"))
titleText.setTextSize(15)
titleText.setTypeface(Typeface.DEFAULT_BOLD)
local titleParams = LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1.0)
titleText.setLayoutParams(titleParams)
headerBar.addView(titleText)

-- Minimize Button (×)
local closeButton = TextView(context)
closeButton.setText("×")
closeButton.setTextColor(Color.parseColor("#00E5FF"))
closeButton.setTextSize(26)
closeButton.setPadding(15, 0, 5, 10)
closeButton.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
    onClick = function(v)
        activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
            run = function()
                mainContainer.setVisibility(View.GONE)
                iconContainer.setVisibility(View.VISIBLE)
            end
        }))
    end
}))
headerBar.addView(closeButton)
mainContainer.addView(headerBar)

-- Horizontal Tab Layout Area
local tabBar = LinearLayout(context)
tabBar.setOrientation(LinearLayout.HORIZONTAL)
tabBar.setPadding(0, 0, 0, 20)
mainContainer.addView(tabBar)

-- Dynamic Frame View Canvas
local contentFrame = FrameLayout(context)
mainContainer.addView(contentFrame)

local pages = {}
local tabButtons = {}

local function createPage()
    local page = LinearLayout(context)
    page.setOrientation(LinearLayout.VERTICAL)
    page.setVisibility(View.GONE)
    page.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
    contentFrame.addView(page)
    return page
end

for i = 1, 5 do pages[i] = createPage() end

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
    local params = luajava.newInstance("android.widget.LinearLayout$LayoutParams", 0, LinearLayout.LayoutParams.WRAP_CONTENT, 1.0)
    btn.setLayoutParams(params)
    btn.setText(title)
    btn.setTextSize(10)
    btn.setPadding(0, 15, 0, 15)
    btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v) switchTab(index) end
    }))
    tabBar.addView(btn)
    tabButtons[index] = btn
end

local tabTitles = {"Shield", "Visuals", "Drone", "Prices", "System"}
for i, title in ipairs(tabTitles) do addTab(title, i) end

--------------------------------------------------
-- INTERFACE CONTENT CONSTRUCTORS
--------------------------------------------------
local function addPageText(page, text, color)
    local txt = TextView(context)
    txt.setText(text)
    txt.setTextColor(Color.parseColor(color or "#FFFFFF"))
    txt.setPadding(0, 8, 0, 8)
    page.addView(txt)
end

local function addPageButton(page, text, callback)
    local btn = Button(context)
    btn.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
    btn.setText(text)
    btn.setTextColor(Color.parseColor("#FFFFFF"))
    btn.setBackground(createShape("#2A2A3A", 12, 1, "#00E5FF"))
    btn.setPadding(0, 18, 0, 18)
    btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v) callback() end
    }))
    page.addView(btn)
end

-- Page 1 Setup (Shield)
addPageText(pages[1], "Status: Plan Verified [Free User]", "#00FF00")
addPageText(pages[1], "License Verification", "#00E5FF")
addPageButton(pages[1], "VERIFY ACTIVE CONFIGURATION TOKEN", function()
    print("Verification layer acknowledged.")
end)

-- Page 2 Setup (Visuals)
addPageText(pages[2], "Perception Overlays", "#00E5FF")

-- Page 3 Setup (Drone)
addPageText(pages[3], "Matrix Coordinates Console", "#00E5FF")

-- Page 4 Setup (Prices)
addPageText(pages[4], "Premium Tiers Info", "#00E5FF")
addPageText(pages[4], "• 03 Days Access -> ₱45\n• 07 Days Access -> ₱85\n• Lifetime Pass -> ₱650", "#FFFFFF")

-- Page 5 Setup (System)
addPageText(pages[5], "UI Lifecycle Properties", "#B0BEC5")
addPageButton(pages[5], "EXIT RUNTIME ENVIRONMENT", function()
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            windowManager.removeView(mainContainer)
            windowManager.removeView(iconContainer)
            print("UI Thread Terminated.")
        end
    }))
end)

switchTab(1)

--------------------------------------------------
-- RENDERING LAYER EXECUTION
--------------------------------------------------
activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        windowManager.addView(iconContainer, iconParams)
        windowManager.addView(mainContainer, mainParams)
    end
}))
