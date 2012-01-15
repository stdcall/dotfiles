-- Imports: {{{
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.Loggers(logCmd)
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import XMonad.Layout.NoBorders
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.LayoutHints (layoutHintsWithPlacement,layoutHintsToCenter)
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ResizableTile -- Actions.WindowNavigation is nice too
import XMonad.Layout.Reflect
import XMonad.Util.WindowProperties (getProp32s)
import XMonad.Hooks.EwmhDesktops
-- other
import System.IO
import System.Exit
import Data.List
import Data.Monoid
import Data.Ratio
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import Control.Monad
import System.Environment (getEnv)
import System.IO.Unsafe (unsafePerformIO)
-- }}}
home                   = unsafePerformIO $ getEnv "HOME"
-- Look and Feel: {{{
dzenHeight             = unsafePerformIO $ getEnv "dzenHeight"
dzenWidth              = unsafePerformIO $ getEnv "XmonadDzenWidth"
myFont                 = unsafePerformIO $ getEnv "FONT"                       
dzenFont               = myFont  
dzenFG                 = unsafePerformIO $ getEnv "DZEN_FG"
dzenBG                 = unsafePerformIO $ getEnv "DZEN_BG"
dzenWorkspaceFG        = dzenFG
dzenCurrentWorkspaceBG = unsafePerformIO $ getEnv "SELECTED_BACKGROUND"
dzenCurrentWorkspaceFG = dzenFG

-- color theme: {{{ 
colorBG  = "#303030" 
colorFG  = "#606060"
colorFG2 = "#909090"
colorFG3 = "#C4DF90"
colorUrg = "#FFA500"
-- }}}
-- tab theme {{{
myTabConfig = defaultTheme {
                             activeColor = colorBG
                           , inactiveColor = colorBG
                           , activeBorderColor = colorFG
                           , inactiveTextColor = colorFG
                           , inactiveBorderColor = colorFG2
                           , activeTextColor = colorFG3
                           , fontName = myFont
                           }
--}}} 

--}}}  
myStatusBar = "dzen2 -p -fn '" ++ dzenFont ++ "' -x 0 -y 0 -w " ++ dzenWidth ++ " -h " ++ dzenHeight ++ " -bg '" ++ dzenBG ++ "' -ta 'l'"
myLogHook h = dynamicLogWithPP $ defaultPP {
              ppCurrent         = dzenColor dzenCurrentWorkspaceFG dzenCurrentWorkspaceBG . pad 
            , ppVisible         = dzenColor dzenWorkspaceFG dzenBG 
            , ppHidden          = dzenColor dzenWorkspaceFG dzenBG . wrap "" ("^i(" ++ home ++ "/.icons/dzen_bitmaps/has_win.xbm)")  
            , ppHiddenNoWindows = dzenColor dzenFG          dzenBG . wrap "" ("^i(" ++ home ++ "/.icons/dzen_bitmaps/has_win_nv.xbm)") --dzenColor dzenFG dzenBG 
            , ppUrgent          = dzenColor "#ff0000" "#000000"
            , ppOutput          = hPutStrLn h
            , ppWsSep           = "^p(2)"
            , ppSep             = " : "
            , ppOrder           = \(ws:_:t:_) -> [ws,t]
            , ppTitle           = dzenColor dzenFG dzenBG
            , ppExtras          = [ ]
            --, ppSort = fmap (ppSort xmobarPP) -- hide "NSP" from the workspace list
            } 
            --where 
            --  fill :: String -> Int -> String
            --  fill h i = "^p(" ++ show i ++ ")" ++ h ++ "^p(" ++ show i ++ ")"

myWorkspaces = ["main","web","misc","dev","im","gimp","play"] 
myManageHook = (composeAll . concat $
  [
    [resource  =? r --> doIgnore  |  r    <- myIgnores] -- ignore desktop
  , [className =? "Gimp" --> doShift "gimp"]
  , [title     =? "Warcraft III" --> doShift "play"]
  , [className =? "Gimp" --> unfloat]
  , [title     =? "Downloads" --> doCenterFloat]
  , [title     =? t --> doShift "im" | t <- myChats ] -- move chats to chat
  , [className =? c --> doShift "im" | c <- myIMs ] -- move chats to chat
  , [className =? w --> doShift "web" | w <- myWebs ] -- move browers to web
  , [className =? c --> doFloat | c <- myFloats ] -- float my floats
  , [className =? c --> doCenterFloat | c <- myCFloats] -- float my floats
  , [name =? n --> doFloat | n <- myNames ] -- float my names
  , [isFullscreen --> doFullFloat ]
  ]) <+> manageTypes <+> manageDocks

    where
      unfloat = ask >>= doF . W.sink
      role = stringProperty "WM_WINDOW_ROLE"
      name = stringProperty "WM_NAME"

      -- [ ("class1","role1"), ("class2","role2"), ... ]
      myIMs = ["Gajim.py","roster","Skype", "Pidgin"]

      -- titles
      myChats = ["mcabber","mutt"]
      -- classnames
      myFloats = ["MPlayer","Zenity","VirtualBox","rdesktop"]
      myCFloats = ["Xmessage","Save As...","XFontSel"]

      myWebs = ["Navigator","Shiretoko","Firefox"] ++
               ["Uzbl","uzbl","Uzbl-core","uzbl-core"] ++
               ["Google-chrome","Chromium-browser"]
                
      myText = ["Gvim"]
    
      -- resources
      myIgnores = ["desktop","desktop_window"]

      myNames = ["Google Chrome Options","Chromium Options"]

-- modified version of manageDocks
manageTypes :: ManageHook
manageTypes = checkType --> doCenterFloat

checkType :: Query Bool
checkType = ask >>= \w -> liftX $ do
  m <- getAtom "_NET_WM_WINDOW_TYPE_MENU"
  d <- getAtom "_NET_WM_WINDOW_TYPE_DIALOG"
  u <- getAtom "_NET_WM_WINDOW_TYPE_UTILITY"
  mbr <- getProp32s "_NET_WM_WINDOW_TYPE" w

  case mbr of
    Just [r] -> return $ elem (fromIntegral r) [m,d,u]
    _ -> return False


myLayoutHook = smartBorders $ avoidStruts $
    onWorkspace "gimp" gimpLayout $
    onWorkspace "im" imLayout     $
    onWorkspace "play" full       $ 
    standardLayouts 
  where
    standardLayouts = tiled ||| Mirror tiled ||| full ||| tabs
    tiled = hinted $ ResizableTall nmaster delta ratio []
    full = hinted $ noBorders Full
    
    --like hintedTile but for any layout
    --layoutHintsWithPlacement (1,0)
    hinted l = layoutHintsWithPlacement (0.5, 0.5) l
    nmaster = 1
    delta = 3/100
    ratio = toRational $ 2/(1 + sqrt 5 :: Double) -- golden ratio
    tabs = hinted (tabbedBottom shrinkText myTabConfig) 

    gimpLayout = withIM (0.11) (Role "gimp-toolbox") $ reflectHoriz $ withIM (0.15) (Role "gimp-dock") Full
    imLayout = avoidStruts $ reflectHoriz $ withIM ratio rosters chatLayout where
      chatLayout      = Grid
      ratio           = 1%6
      rosters         = skypeRoster `Or` gajimRoster `Or` pidginRoster
      gajimRoster     = Role "roster"
      pidginRoster    = And (ClassName "Pidgin") (Role "buddy_list")
      --skypeRoster     = (ClassName "Skype") `And` (Not (Title "Options")) `And` (Not (Role "Chats")) `And` (Not (Role "CallWindowForm"))
      skypeRoster     = Title "nickolayho - Skype™ (Beta)"


main = do
    wbar        <-  spawnPipe   myStatusBar
    --spawn  "~/.scripts/date.sh"
    --spawn "~/.scripts/topstatusbar.sh"
    --spawn  "~/.scripts/tray.sh"
        
    spawn "xcompmgr -cCfF -o .35 -r 3.2 -t-2 -l-1 -D 3 -O-.03 -I-.015"
    xmonad $ ewmh defaultConfig 
                           { layoutHook         = myLayoutHook
                           , terminal           = "urxvtc"
                           , workspaces         = myWorkspaces
                           , modMask            = mod4Mask
                           , manageHook         = myManageHook 
                           , startupHook        = setWMName "LG3D"
                           , logHook            = do 
                                                  myLogHook wbar
                                                  fadeInactiveLogHook 0.9
                           , borderWidth        = 1
                           , normalBorderColor  = "#1d313b"
                           , focusedBorderColor = "#516650"
                           , focusFollowsMouse  = True
                           } `additionalKeysP` myKeys

myKeys = [ 
    ("M-p", spawn "xrun")
  , ("M-c", spawn "composite -t")
  , ("M-r", spawn "xrdb load ~/.Xdefaults")
  , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 2%+")            
  , ("<XF86AudioLowerVolume>", spawn "amixer set Master 2%-")
  , ("<XF86AudioNext>", spawn "ncmpcpp next")
  , ("<XF86AudioPrev>", spawn "ncmpcpp prev")
  , ("<XF86AudioPlay>", spawn "ncmpcpp toggle")
  , ("M-C-k", sendMessage $ MirrorExpand)
  , ("M-C-j", sendMessage $ MirrorShrink)
  , ("M-C-h", sendMessage $ Shrink)
  , ("M-C-l", sendMessage $ Expand)
  , ("M-b", sendMessage ToggleStruts)
  , ("M-S-q", io (exitWith ExitSuccess))
  --, ("M-q", spawn "xmonad --recompile && xmonad --restart")
  --, ("M-o", setWMName "LG3D")
  ]
