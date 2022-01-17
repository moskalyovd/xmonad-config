import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.LayoutHints
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig
import XMonad.Util.Run


main = do
    xmproc <- spawnPipe "xmobar"

    xmonad $ defaultConfig
        { workspaces = myWorkspaces
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , borderWidth           = 2
        , normalBorderColor  = "black"
        , focusedBorderColor  = "orange"
        , layoutHook = myLayout
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
myLayout = avoidStruts $ layoutHints $ smartBorders (tiled ||| Mirror tiled ||| Full)
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1      -- Default number of windows in the master pane
    ratio   = 1/2    -- Default proportion of screen occupied by master pane
    delta   = 3/100  -- Percent of screen to increment by when resizing panes
