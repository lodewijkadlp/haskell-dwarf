module Main where

import FRP.Helm
import qualified FRP.Helm.Time as Time
import qualified FRP.Helm.Window as Window

main :: IO()
main = do
		run config $ render <~ delta ~~ Window.dimensions
	where
		config = defaultConfig { windowTitle = "Dwarfs" }
		stepper = foldp step 0 (Time.fps 60)