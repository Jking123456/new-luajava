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
-- 1. FLOATING LOGO BUTTON (90x90 COMPACT)
--------------------------------------------------
local iconParams = WindowManager.LayoutParams()
iconParams.type = overlayType
iconParams.format = PixelFormat.RGBA_8888
iconParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
iconParams.width = 90  
iconParams.height = 90 
iconParams.gravity = Gravity.LEFT or Gravity.TOP
iconParams.x = 100
iconParams.y = 400

local logoButton = Button(context)
logoButton.setText("P")
logoButton.setTextColor(Color.parseColor("#00E5FF"))
logoButton.setTextSize(14)
logoButton.setTypeface(Typeface.DEFAULT_BOLD)

local buttonShape = GradientDrawable()
buttonShape.setShape(GradientDrawable.OVAL)
buttonShape.setColor(Color.parseColor("#11141A"))
buttonShape.setStroke(3, Color.parseColor("#00E5FF"))
logoButton.setBackground(buttonShape)

--------------------------------------------------
-- FLOATING BUTTON DRAG LOGIC
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
-- 2. RESIZED PREMIUM COMPACT UI CARD
--------------------------------------------------
local mainParams = WindowManager.LayoutParams()
mainParams.type = overlayType
mainParams.format = PixelFormat.RGBA_8888
mainParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
mainParams.width = 650 -- Maintained clean card bounding layout
mainParams.height = WindowManager.LayoutParams.WRAP_CONTENT
mainParams.gravity = Gravity.CENTER

local mainContainer = LinearLayout(context)
_G.PRINZ_MAIN_CONTAINER = mainContainer
mainContainer.setOrientation(LinearLayout.VERTICAL)
mainContainer.setBackground(createShape("#11141A", 28, 2, "#1F2937")) 
mainContainer.setPadding(30, 25, 30, 30) -- Tightened paddings to stop the layout ballooning

-- Header Bar Layout
local headerBar = LinearLayout(context)
headerBar.setOrientation(LinearLayout.HORIZONTAL)
headerBar.setGravity(Gravity.CENTER_VERTICAL)

local titleText = TextView(context)
titleText.setText("PRINZVAN CONSOLE V2.0")
titleText.setTextColor(Color.parseColor("#00E5FF"))
titleText.setTextSize(13)
titleText.setTypeface(Typeface.DEFAULT_BOLD)
local titleParams = LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1.0)
titleText.setLayoutParams(titleParams)
headerBar.addView(titleText)

-- Minimize Button Restructured (× Style)
local closeButton = TextView(context)
closeButton.setText("×")
closeButton.setTextColor(Color.parseColor("#9CA3AF"))
closeButton.setTextSize(22) -- Normalized sizing properties
closeButton.setGravity(Gravity.CENTER)
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
mainContainer.addView(headerBar)

-- Compact Tab Menu Area
local tabBar = LinearLayout(context)
tabBar.setOrientation(LinearLayout.HORIZONTAL)
tabBar.setPadding(0, 20, 0, 20)
mainContainer.addView(tabBar)

-- Dynamic Content Canvas Window
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
            tabButtons[i].setBackground(createShape("#1F2937", 10, 1, "#00E5FF"))
        else
            pages[i].setVisibility(View.GONE)
            tabButtons[i].setTextColor(Color.parseColor("#6B7280"))
            tabButtons[i].setBackground(createShape("#11141A", 10, 0, nil))
        end
    end
end

local function addTab(title, index)
    local btn = Button(context)
    local params = luajava.newInstance("android.widget.LinearLayout$LayoutParams", 0, 75, 1.0) -- Enforced tight static button height
    btn.setLayoutParams(params)
    btn.setText(title)
    btn.setTextSize(8.5)
    btn.setPadding(0, 0, 0, 0)
    btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v) switchTab(index) end
    }))
    tabBar.addView(btn)
    tabButtons[index] = btn
end

local tabTitles = {"Shield", "Visuals", "Drone", "Prices", "System"}
for i, title in ipairs(tabTitles) do addTab(title, i) end

--------------------------------------------------
-- RENDER ELEMENTS GENERATOR
--------------------------------------------------
local function addPageText(page, text, color)
    local txt = TextView(context)
    txt.setText(text)
    txt.setTextColor(Color.parseColor(color or "#E5E7EB"))
    txt.setPadding(0, 5, 0, 15)
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
    btn.setTextSize(12)
    btn.setBackground(createShape("#00E5FF", 12, 0, nil)) 
    btn.setPadding(0, 15, 0, 15)
    btn.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v) callback() end
    }))
    
    spaceContainer.addView(btn, LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT))
    page.addView(spaceContainer)
end

-- App Interfaces Data Mount
addPageText(pages[1], "Authentication Verification Layer", "#9CA3AF")
addPageButton(pages[1], "VERIFY ACTIVE SESSION TOKEN", function()
    print("Session active.")
end)

addPageText(pages[2], "Visual Framework Perception System", "#9CA3AF")
addPageText(pages[3], "Matrix Coordinates Console Configuration", "#9CA3AF")

addPageText(pages[4], "Premium Access Tiers", "#00E5FF")
addPageText(pages[4], "• 03 Days Access VIP -> ₱45\n• 07 Days Access VIP -> ₱85\n• Lifetime Pass Base -> ₱650", "#E5E7EB")

addPageText(pages[5], "UI Lifecycle Termination Matrix", "#9CA3AF")
addPageButton(pages[5], "CLOSE UI WINDOW", function()
    activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
        run = function()
            windowManager.removeView(_G.PRINZ_MAIN_CONTAINER)
            windowManager.removeView(logoButton)
        end
    }))
end)

switchTab(1)

--------------------------------------------------
-- WINDOW INITIALIZATION DISPLAY
--------------------------------------------------
activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
    run = function()
        windowManager.addView(logoButton, iconParams)
        logoButton.setVisibility(View.GONE) 
        
        windowManager.addView(_G.PRINZ_MAIN_CONTAINER, mainParams)
    end
}))

-- KEEP-ALIVE DAEMON LOOP
while true do
    gg.sleep(100)
end
