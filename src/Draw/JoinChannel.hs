{-# LANGUAGE OverloadedStrings #-}
module Draw.JoinChannel
    ( drawJoinChannel
    )
where

import Brick
import Brick.Widgets.List
import Brick.Widgets.Center
import Brick.Widgets.Border
import Data.Monoid ((<>))
import Lens.Micro.Platform ((^.))

import Network.Mattermost (Channel)
import Network.Mattermost.Lenses (channelDisplayNameL, channelNameL)

import Types
import Themes
import Draw.Main

drawJoinChannel :: ChatState -> [Widget Name]
drawJoinChannel st = joinChannelBox st : (forceAttr "invalid" <$> drawMain st)

joinChannelBox :: ChatState -> Widget Name
joinChannelBox st =
    let chList = case st^.csJoinChannelList of
          Nothing -> center $ withDefAttr dialogEmphAttr $ txt "[Loading channel list]"
          Just chanList -> renderList renderJoinListItem True chanList
        highlight = withDefAttr dialogEmphAttr
    in centerLayer $
       vLimit 20 $
       hLimit 60 $
       withDefAttr dialogAttr $
       borderWithLabel (txt "Join Channel") $
       vBox [ chList
            , padTop (Pad 1) $
              hCenter $ txt "Use " <+> (highlight $ txt "arrow keys") <+> txt " and " <+>
                        (highlight $ txt "Enter") <+> txt " to select a team"
            , hCenter $ txt "to join or press " <+> (highlight $ txt "Esc") <+> txt " to cancel."
            ]

renderJoinListItem :: Bool -> Channel -> Widget Name
renderJoinListItem _ chan =
    padRight Max $ txt $ chan^.channelNameL <> " (" <> chan^.channelDisplayNameL <> ")"