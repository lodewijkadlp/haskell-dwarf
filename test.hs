{-| Renders a pizza-like colour-wheel, with each slice being a unique pre-defined color.
See http://helm-engine.org/guide/colors/ -}
module Main where

import FRP.Helm
import qualified FRP.Helm.Time as Time
import qualified FRP.Helm.Window as Window
import qualified FRP.Helm.Mouse as Mouse

data State = State { dx :: Double }

{-| A list of colors to show on the colour-wheel. Each colour has its own slice. -}
colors :: [Color]
colors = [red, lime, blue, yellow, cyan, magenta, maroon, navy, green, teal, purple]

{-| Calculates the point on the circumference of a specific radius at a certain angle. -}
pointOnCircum :: Double -> Double -> (Double, Double)
pointOnCircum r theta = (r * (cos theta - sin theta), r * (cos theta + sin theta))

{-| Renders a slice, using the nth color in 'colors'. -}
slice :: Double -> Int -> [Form]
slice spacing n = map (\x -> filled color $ polygon x) points
	where
		color = colors !! n
		increment = 2 * pi / realToFrac (length colors)
		r = 150
		res = 4
		t :: Double -> Double
		t i = increment * realToFrac n + (increment / res) * i
		points = map (\i -> [(0,0), pointOnCircum r (t i), pointOnCircum r (t (i + spacing))]) [0 .. res - 1]

step :: Time -> Double -> Double
step dt n = n + Time.inSeconds dt

{-| Renders all the slices together to form a colour-wheel, centering it on the screen. -}
render :: Double -> (Int, Int) -> Int -> Element
render angle (w, h) mouseX = centeredCollage w h $ map (rotate angle) (concat (map (slice $ (-0.01 * realToFrac mouseX)) [0 .. fromIntegral (length colors) - 1]))

{-| Bootstrap the game. -}
main :: IO ()
main = do
		run config $ render <~ stepper ~~ Window.dimensions ~~ Mouse.x
	where
		config = defaultConfig { windowTitle = "Helm - Colors" }
		stepper = foldp step 0 (Time.fps 60)

