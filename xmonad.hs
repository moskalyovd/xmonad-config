import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.LayoutHints
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Hooks.ManageHelpers
import qualified XMonad.StackSet as W

main = do
    xmproc <- spawnPipe "xmobar"

    xmonad $ docks defaultConfig
        { workspaces = myWorkspaces
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , borderWidth           = 2
        , normalBorderColor  = "black"
        , focusedBorderColor  = "orange"
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , manageHook = manageDocks <+> myManageHook
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        } `additionalKeysP`
        [
        ]

data ExpandEdges a = ExpandEdges Int deriving (Read,Show)

myWorkspaces :: [String]
myWorkspaces = ["1:web","2:dev","3:term","4:debug","5:social","6","7","8","9"]

myManageHook = composeAll
    [className =? "stalonetray"    --> doIgnore
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]
