import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.DynamicBars as Bars
import XMonad.Hooks.ManageDocks
import XMonad.Layout.LayoutHints
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Hooks.ManageHelpers
import qualified XMonad.StackSet as W
import XMonad.Actions.OnScreen
import XMonad.Util.SpawnOnce
import XMonad.Util.WorkspaceCompare

myStartupHook :: X()
myStartupHook = do
    Bars.dynStatusBarStartup xmobarCreator xmobarDestroyer
    -- spawnOnce "autorandr default"
    spawnOnce "yandex-disk start"
    spawnOnce "stalonetray"

xmobarCreator :: Bars.DynamicStatusBar
xmobarCreator (S sid) = spawnPipe $ "xmobar -x " ++ show sid

xmobarDestroyer :: Bars.DynamicStatusBarCleanup
xmobarDestroyer = return ()

xmobarPP' = xmobarPP {
  ppSort = mkWsSort $ getXineramaPhysicalWsCompare def
}
  where dropIx wsId = if ':' `elem` wsId then drop 2 wsId else wsId

main = do
    xmonad $ docks defaultConfig
        { workspaces = myWorkspaces
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , focusFollowsMouse = True
        , borderWidth           = 2
        , normalBorderColor  = "black"
        , focusedBorderColor  = "orange"
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , manageHook = manageDocks <+> myManageHook
        , startupHook = myStartupHook
        -- , logHook = dynamicLogWithPP xmobarPP
        --                 { ppOutput = hPutStrLn xmproc
        --                 , ppTitle = xmobarColor "green" "" . shorten 50
        --                 }
        , logHook     = Bars.multiPP xmobarPP' xmobarPP'
        } `additionalKeys` myKeys

-- TODO: Нужно будет выбирать текущее активное устройство и с ним работать pactl list sinks
-- pactl list short | grep RUNNING | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,'
myKeys = [
      ((0 , 0x1008FF11), spawn "pactl set-sink-volume 1 -2%"),
      ((0 , 0x1008FF13), spawn "pactl set-sink-volume 1 +2%"),
      ((0 , 0x1008FF12), spawn "pactl set-sink-mute 1 toggle")]

data ExpandEdges a = ExpandEdges Int deriving (Read,Show)

myWorkspaces :: [String]
myWorkspaces = ["1:web","2:dev","3:term","4:debug","5:social","6:other","7:vpn"]

myManageHook = composeAll
    [className =? "stalonetray"    --> doIgnore
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]
