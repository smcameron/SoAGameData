ButtonStyle1 = require "Data/UI/button_style_1"
SliderStyle = require "Data/UI/slider_style"
CheckBoxStyle = require "Data/UI/check_box_style"
ComboBoxStyle = require "Data/UI/combo_box_style"
LabelStyle = require "Data/UI/label_style"

-- Controls objects -- Is this optional????
gammaSlider = {}
gammaLabel = {}
fullscreenCheckBox = {}
borderlessCheckBox = {}
widgetList = {}

function onGameOptionsClick()
  changeForm("GameOptionsForm")
end
Vorb.register("onGameOptionsClick", onGameOptionsClick)

function onBackClick()
  changeForm("main")
end
Vorb.register("onBackClick", onBackClick)

function onRestoreClick()
  Options.restoreDefault()
  setValues()
end
Vorb.register("onRestoreClick", onRestoreClick)

-- Options Changes
function onGammaChange(i)
  gamma = i / 1000.0
  Options.setFloat("Gamma", gamma)
  Label.setText(gammaLabel, "Gamma: " .. round(gamma, 2))
  Options.save()
end
Vorb.register("onGammaChange", onGammaChange)

function onFullscreenChange(b)
  Options.setBool("Fullscreen", b)
  CheckBox.setChecked(fullscreenCheckBox, b)
  Options.save()
end
Vorb.register("onFullscreenChange", onFullscreenChange)

function onBorderlessChange(b)
  Options.setBool("Borderless Window", b)
  CheckBox.setChecked(borderlessCheckBox, b)
  Options.save()
end
Vorb.register("onBorderlessChange", onBorderlessChange)

function onResolutionChange(s)
  x, y = string.match(s, "(%d+) x (%d+)")
  Options.setInt("Screen Width", x)
  Options.setInt("Screen Height", y)
  Options.save()
end
Vorb.register("onResolutionChange", onResolutionChange)

-- Rounds to a given number of decimal places
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function setValues()
  -- Gamma
  gamma = Options.getFloat("Gamma")
  Slider.setValue(gammaSlider, gamma * 1000.0)
  CheckBox.setChecked(fullscreenCheckBox, Options.getBool("Fullscreen"))
  CheckBox.setChecked(borderlessCheckBox, Options.getBool("Borderless Window"))
  -- Resolution
  x, y = Window.getCurrentResolution()
  ComboBox.setText(resComboBox, x .. " x " .. y)
end

function addWidgetToList(w)
  WidgetList.addItem(widgetList, w)
end

panelCounter = 0
function getNewListPanel()
  p = Form.makePanel(this, "Panel" .. panelCounter, 0, 0, 10, 10)
  panelCounter = panelCounter + 1
  Panel.setDimensionsPercentage(p, 1.0, 0.1)
  addWidgetToList(p)
  return p
end

function alignSlider(s, p)
  Slider.setWidthPercentage(s, 0.49)
  Slider.setPositionPercentage(s, 0.5, 0.5)
  Slider.setWidgetAlign(s, WidgetAlign.LEFT)
  Slider.setParent(s, p)
end

function init()
  Options.beginContext();
  
  -- Top buttons
  tbyp = 0.02 --Top button y percentage
  graphicsButton = ButtonStyle1.make("graphicsButton", "Graphics Options", "")
  Button.setTextHoverColor(graphicsButton, 255, 255, 255, 255)
  Button.setTextScale(graphicsButton, 0.9, 0.9)
  Button.setBackHoverColorGrad(graphicsButton, 16, 190, 239, 166, 0, 0, 0, 0, GradientType.HORIZONTAL);
  Button.setPositionPercentage(graphicsButton, 0.2, tbyp)
 
  gameButton = ButtonStyle1.make("gameButton", "Game Options", "onGameOptionsClick")
  Button.setBackColorGrad(gameButton, 255, 255, 255, 166, 0, 0, 0, 0, GradientType.HORIZONTAL);
  Button.setPositionPercentage(gameButton, 0.5, tbyp)
  
  -- Widget list
  widgetList = Form.makeWidgetList(this, "WidgetList", 0, 0, 1000, 1000)
  WidgetList.setBackColor(widgetList, 128, 128, 128, 128)
  WidgetList.setPositionPercentage(widgetList, 0.1, 0.1)
  WidgetList.setDimensionsPercentage(widgetList, 0.5, 0.85)
  
  -- Gamma
  gammaPanel = getNewListPanel()
  gammaSlider = SliderStyle.make("gammaSlider", 100, 2500, "onGammaChange")
  alignSlider(gammaSlider, gammaPanel)

  gammaLabel = LabelStyle.make("GammaLabel", "Gamma: " .. round(Options.getFloat("Gamma"), 2))
  Label.setPositionPercentage(gammaLabel, 0.1, 0.5) 
  Label.setParent(gammaLabel, gammaPanel)
  
  -- Borderless
  borderlessCheckBox = CheckBoxStyle.make("BorderlessCheckBox", "Borderless Window", "onBorderlessChange")

  -- Fullscreen
  fullscreenCheckBox = CheckBoxStyle.make("FullscreenCheckBox", "Fullscreen", "onFullscreenChange")

  -- Resolution
  resComboBox = ComboBoxStyle.make("ResComboBox", "", "onResolutionChange")
  ComboBox.setMaxDropHeight(resComboBox, 200.0)
  numRes = Window.getNumSupportedResolutions()
  i = 0
  while i < numRes do
    x,y = Window.getSupportedResolution(i)
    ComboBox.addItem(resComboBox, x .. " x " .. y)
    i = i + 1
  end
 
   -- Bottom buttons
  backButton = ButtonStyle1.make("backButton", "Back", "onBackClick")
  
  restoreButton = ButtonStyle1.make("restoreButton", "Restore Defaults", "onRestoreClick")
 
  setValues()
end

Vorb.register("init", init)