; Template used for Software Integration
;
;Awara Pirkhdrie
;
;
;

; ************* GLOBAL VARIABLES *****************
globals []

; ******************end global variables ***********

; ************ BREEDS OF TURTLES *****************

breed [Adults adult ]
breed[Polices police]
breed[Building buildnings]

; ********************end breed of turtles ********

; ************* AGENT-SPECIFIC VARIABLES *********

Polices-own [next-task person-to-search search-tick]
adults-own [stopped arrested-time drugs]


to setup-territories

   create-Building 1 [
    set label "Police officer"
    set label-color 8
    set shape "house colonial"
    set size 5
    setxy 14 -3
  ]
end

to setup
  clear-all
  reset-ticks
  setup-territories
   ask patches[
    set pcolor green
    if (pxcor >= -9 and pxcor <= -8) and (pycor < 17 and pycor > -17)
    [set pcolor 7]
    if (pxcor >= -9 and pxcor <= 17) and (pycor < 11 and pycor > 8)
    [set pcolor 7]
    if (pycor >= -1 and pycor < 1) and (pxcor > -17 and pxcor < 17)
    [set pcolor 7]
    if (pycor >= -9 and pycor < -7) and (pxcor > -17 and pxcor < 5)
    [set pcolor 7]
    if (pycor >= -16 and pycor < -9) and (pxcor > 2 and pxcor < 5)
    [set pcolor 7]
    if (pycor >= -9 and pycor < -7) and (pxcor > -17 and pxcor < 5)
    [set pcolor 7]
    if (pycor >= -7 and pycor < -1) and (pxcor > 0 and pxcor < 3)
    [set pcolor 7]
    if (pycor >= -12 and pycor < -10) and (pxcor >= 5 and pxcor <= 16)
    [set pcolor 7]
    if (pycor >= -16 and pycor < -1) and (pxcor > 9 and pxcor < 12)
    [set pcolor 7]
    if (pycor >= 1 and pycor <= 8) and (pxcor > -3 and pxcor < 0)
    [set pcolor 7]
    if (pycor >= 1 and pycor < 4) and (pxcor > 5 and pxcor < 8)
    [set pcolor 7]
    if (pycor >= 11 and pycor <= 16) and (pxcor > 1 and pxcor < 4)
    [set pcolor 7]
    if (pycor >= 11 and pycor <= 16) and (pxcor > 14 and pxcor < 17)
    [set pcolor 7]
    if (pycor > 3 and pycor < 6) and (pxcor > 5 and pxcor < 8)
    [set pcolor 7]
    if (pycor > 3 and pycor < 9) and (pxcor > 7 and pxcor < 10)
    [set pcolor 7]
    if (pycor > 6 and pycor < 9) and (pxcor > -17 and pxcor < -9)
    [set pcolor 7]
    if (pycor > 14 and pycor < 17) and (pxcor > -17 and pxcor < -9)
    [set pcolor 7]
    if (pycor > -17 and pycor < -8) and (pxcor > -4 and pxcor < -1)
    [set pcolor 7]
    if (pycor > -17 and pycor < -14) and (pxcor > -17 and pxcor < 3)
    [set pcolor 7]
    if (pycor > 3 and pycor < 6) and (pxcor > -8 and pxcor < 6)
    [set pcolor 7]
    if (pycor > -7.5 and pycor < -5) and (pxcor > 11 and pxcor < 17)
    [set pcolor 7]
    if (pycor > 3 and pycor < 6) and (pxcor > 9 and pxcor < 15)
    [set pcolor 7]
    if (pycor > 0 and pycor < 4) and (pxcor > 12 and pxcor < 15)
    [set pcolor 7]
    if (pycor > 10 and pycor < 17) and (pxcor > 8 and pxcor < 11)
    [set pcolor 7]
    if (pycor > -9 and pycor < -6) and (pxcor > 4 and pxcor < 7)
    [set pcolor 7]
    if (pycor > -7 and pycor < -4) and (pxcor > 4 and pxcor < 10)
    [set pcolor 7]
    if (pycor > 13 and pycor < 15) and (pxcor > -8 and pxcor < -3)
    [set pcolor 7]
    if (pycor > 10 and pycor < 15) and (pxcor > -4 and pxcor < -1)
    [set pcolor 7]
  ]

  create-Polices 5 [
    set shape  "person police"
    set color blue
    set search-tick 0
    set size 2
    setxy random-xcor random abs 11
    set next-task [ -> move-police ]
  ]

  create-adults 15 [
    set shape  "person"
    set stopped 0
    set arrested-time -1
    set size 2
    setxy random 11 random 11
    set drugs random 2
    ifelse drugs = 1 [ set color red ] [ set color white ]
  ]
end


; ******************* TO GO/ STARTING PART ********
to go
  ask Polices [ run next-task ]
  move-adults
  tick
end



; ************** MOVE-POLICE **************
to move-police
  set color blue

    ifelse abs xcor > 15 or abs ycor >= 9 [
      set heading towards patch 0 0
    ]
    [
      right random 60
      left random 60
    ]
    forward 0.5

  if any? (adults-here with [ stopped = 0 ]) [
    let target one-of adults-here
    ask target [ set stopped 1 ]
    set person-to-search target
    set next-task [ -> search-person ]
  ]
end
; ************** SEARCH-PERSON **************
to search-person
  set color yellow
  set search-tick search-tick + 1
  if search-tick = 10[
    ask person-to-search [
      ifelse drugs > 0 [
        set color black
        set drugs 0
        set arrested-time ticks
      ]
      [
        set stopped 0
      ]
    ]
    ifelse [ color ] of person-to-search = grey [
      set next-task [ -> go-to-prison ]
    ]
    [ set next-task [ -> move-police ] ]
    set search-tick 0
  ]
end

; ************** GO-TO-PRISON **************
to go-to-prison
  set color green
  ifelse distancexy 0 -13 > 1 [
    set heading towards-nowrap patch 0 -13
    forward 0.5
  ]
  [ set next-task [ -> move-police ] ]
end

; ************** MOVE-ADULTS **************
to move-adults
  ask adults [
    ifelse stopped = 0 [
      ifelse abs xcor > 50 or abs ycor >= 50 [
        set heading towards patch 0 0
      ]
      [
        right random 45
        left random 45
      ]
      if random 2000 = 1 [
        set drugs drugs + 1
        set color red
      ]
      forward 0.5
    ]
    [if arrested-time != -1
      [
        ifelse distancexy 14 -6 > 1 [
          set heading towards-nowrap patch 14 -6
          forward 0.5
        ]
        [ if ticks - arrested-time = 5000 [ set arrested-time -1 set color white set stopped 0]]
      ]
    ]
  ]

end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
699
500
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-18
18
-18
18
1
1
1
ticks
30.0

BUTTON
57
56
120
89
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
125
57
188
90
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
9
126
181
159
num-of-police
num-of-police
0
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
8
166
180
199
num-of-adults
num-of-adults
0
10
3.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

house colonial
false
0
Rectangle -2674135 true false 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -2674135 true false 15 120 150 15 285 120
Line -16777216 false 30 120 270 120
Rectangle -7500403 true true 92 162 93 162
Rectangle -16777216 true false 48 142 109 184
Rectangle -16777216 true false 128 144 180 185
Rectangle -16777216 true false 197 144 250 184
Rectangle -16777216 true false 53 205 108 277
Rectangle -16777216 true false 188 204 243 276
Rectangle -955883 true false 141 211 147 283

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person police
false
0
Circle -7500403 true true 110 5 80
Polygon -6459832 true false 106 90 121 195 91 285 106 300 136 300 151 225 166 300 196 300 211 285 181 195 196 90
Rectangle -7500403 true true 127 79 172 94
Polygon -6459832 true false 195 90 240 150 225 180 165 105
Polygon -6459832 true false 105 90 60 150 75 180 135 105
Polygon -6459832 true false 181 19 214 37 182 40 158 40 115 35 115 20 143 2 178 3 187 22
Polygon -7500403 true true 124 90 141 107 145 156 111 92
Polygon -7500403 true true 172 92 186 92 157 155 160 113
Circle -7500403 true true 145 153 10
Circle -7500403 true true 145 170 8
Rectangle -16777216 true false 119 185 183 198

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
