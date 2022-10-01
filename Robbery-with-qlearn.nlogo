globals[tmp num-of-rob num-of-gang-rob total-victims current-criminal
  current-health nearby-person nearby-women nearest-criminal other-criminal
  gang-crime-factor max-gang-wealth max-health max-wealth avg-reward avg-reward-crime
  episode fail win helped]

breed[people person]
breed[criminals criminal]
breed[police officer]
breed[women woman]
breed[ATM Atms]

police-own[current-help current-lady current-police]
turtles-own[init-xcor init-ycor ]
people-own[avg-wealth-people age wealth to-walk? to-be-rob? reward qtable Q Qnew fight crime-table robbed]
women-own[avg-wealth-women wealth to-walk? to-be-rob? reward qtable Q Qnew crime-table work robbed]
criminals-own[avg-wealth-criminals crime-factor gang-mates nearby-criminal
  nearest-neighbor wealth health reward qtable Q Qnew to-walk? to-be-rob?]

to setup
  clear-all
  show date-and-time
  set avg-reward 0
  set avg-reward-crime 0
  set episode 0
  ifelse choose-road = "Road 1"
  [set-road]
  [set-path]

  create-ATM 1
  [
    set shape "building store"
    set size 5
    ; move-to one-of patches with [not any? turtles-on self ]
    setxy 4 8
  ]
  create-people num-of-person
  [
    set Qnew 0
    set Q 0
    set shape "person business"
    set size 2
    set wealth random 5000
    set age random 50
    set to-walk? false
    set to-be-rob? false
    set reward 0
    set qtable [0]
    set crime-table []
    set robbed 0
    set avg-wealth-people mean [wealth] of people
    set init-xcor random-xcor
    set init-ycor random-ycor
    if age > 14
    [
      set fight random 2
      show word "fight " fight
    ]
    put-on-empty-road
  ]

  create-women num-of-women
  [
    set Qnew 0
    set Q 0
    set shape "women"
    set size 2
    set wealth random 5000
    set to-walk? false
    set to-be-rob? false
    set reward 0
    set qtable [0]
    set crime-table []
    set robbed 0
    set avg-wealth-women mean [wealth] of women
    set init-xcor random-xcor
    set init-ycor random-ycor
    put-on-empty-road
  ]

  create-criminals num-of-criminals
  [
    set shape "criminal"
    set size 2
    set wealth 0
    set crime-factor random 6
    show word "crime factor " crime-factor
    set init-xcor random-xcor
    set init-ycor random-ycor
    set health random 6
    show word "Health " health
    set Qnew 0
    set Q 0
    set to-walk? false
    set to-be-rob? false
    set reward 0
    set qtable [0]
    set fail 0
    set win 0
    put-on-empty-road
  ]
  create-police num-of-police
  [
    set shape "person police"
    set size 2
    set helped 0
    set current-help nobody
    set init-xcor random-xcor
    set init-ycor random-ycor
    put-on-empty-road
  ]

  set num-of-rob 0
  set num-of-gang-rob 0
  set total-victims num-of-women + num-of-person
  reset-ticks
end

to set-road
  ask patches
    [
      set pcolor green
      if abs pxcor <= 1 or abs pycor <= 1
        [ set pcolor 9 ]

      if (abs pxcor <= 10 and abs pxcor > 7) or (abs pycor <= 10 and abs pycor > 7)
        [set pcolor 9 ]
    ]
end
to set-path
  clear-all
  ask patches
  [
    set pcolor green
    if (pxcor >= -9 and pxcor <= -8) and (pycor < 17 and pycor > -17)
    [set pcolor 9]
    if (pxcor >= -9 and pxcor <= 17) and (pycor < 11 and pycor > 8)
    [set pcolor 9]
    if (pycor >= -1 and pycor < 1) and (pxcor > -17 and pxcor < 17)
    [set pcolor 9]
    if (pycor >= -9 and pycor < -7) and (pxcor > -17 and pxcor < 5)
    [set pcolor 9]
    if (pycor >= -16 and pycor < -9) and (pxcor > 2 and pxcor < 5)
    [set pcolor 9]
    if (pycor >= -9 and pycor < -7) and (pxcor > -17 and pxcor < 5)
    [set pcolor 9]
    if (pycor >= -7 and pycor < -1) and (pxcor > 0 and pxcor < 3)
    [set pcolor 9]
    if (pycor >= -12 and pycor < -10) and (pxcor >= 5 and pxcor <= 16)
    [set pcolor 9]
    if (pycor >= -16 and pycor < -1) and (pxcor > 9 and pxcor < 12)
    [set pcolor 9]
    if (pycor >= 1 and pycor <= 8) and (pxcor > -3 and pxcor < 0)
    [set pcolor 9]
    if (pycor >= 1 and pycor < 4) and (pxcor > 5 and pxcor < 8)
    [set pcolor 9]
    if (pycor >= 11 and pycor <= 16) and (pxcor > 1 and pxcor < 4)
    [set pcolor 9]
    if (pycor >= 11 and pycor <= 16) and (pxcor > 14 and pxcor < 17)
    [set pcolor 9]
    if (pycor > 3 and pycor < 6) and (pxcor > 5 and pxcor < 8)
    [set pcolor 9]
    if (pycor > 3 and pycor < 9) and (pxcor > 7 and pxcor < 10)
    [set pcolor 9]
    if (pycor > 6 and pycor < 9) and (pxcor > -17 and pxcor < -9)
    [set pcolor 9]
    if (pycor > 14 and pycor < 17) and (pxcor > -17 and pxcor < -9)
    [set pcolor 9]
    if (pycor > -17 and pycor < -8) and (pxcor > -4 and pxcor < -1)
    [set pcolor 9]
    if (pycor > -17 and pycor < -14) and (pxcor > -17 and pxcor < 3)
    [set pcolor 9]
    if (pycor > 3 and pycor < 6) and (pxcor > -8 and pxcor < 6)
    [set pcolor 9]
    if (pycor > -7.5 and pycor < -5) and (pxcor > 11 and pxcor < 17)
    [set pcolor 9]
    if (pycor > 3 and pycor < 6) and (pxcor > 9 and pxcor < 15)
    [set pcolor 9]
    if (pycor > 0 and pycor < 4) and (pxcor > 12 and pxcor < 15)
    [set pcolor 9]
    if (pycor > 10 and pycor < 17) and (pxcor > 8 and pxcor < 11)
    [set pcolor 9]
    if (pycor > -9 and pycor < -6) and (pxcor > 4 and pxcor < 7)
    [set pcolor 9]
    if (pycor > -7 and pycor < -4) and (pxcor > 4 and pxcor < 10)
    [set pcolor 9]
    if (pycor > 13 and pycor < 15) and (pxcor > -8 and pxcor < -3)
    [set pcolor 9]
    if (pycor > 10 and pycor < 15) and (pxcor > -4 and pxcor < -1)
    [set pcolor 9]
  ]
end

to put-on-empty-road  ;; turtle procedure
  move-to one-of patches with [not any? turtles-on self and pcolor = 9]

end

to go

  ask people
  [
    move
    set to-walk? true
    set to-be-rob? false
    learn
    ;show Q
    ; consume
    if any? ATM-on neighbors[go-to-work]
  ]
  ask women
  [
    move
    set to-walk? true
    set to-be-rob? false
    learn
    ;show Q
    ;consume
    if any? ATM-on neighbors[go-to-work]
  ]
  ask criminals with [crime-factor < 6]
  [
    move
    set to-walk? true
    set to-be-rob? false
    make-gang
    consume
    learn-crime

  ]
  ask criminals with [crime-factor >= 6]
  [
    move
    set to-walk? true
    set to-be-rob? false
    check-rob
    consume
    learn-crime

  ]
  ask police[move]
  if police-help?
  [police-help]
  tick
end

to move
  if can-move? 1[
    ifelse  [pcolor] of patch-ahead 1 = green
    [ lt random-float 360 ]
    [ fd speed]
  ]

end

to go-to-work
  ;let count-down 201
  if wealth < 1000
  [
    show "going to work"
    move-to one-of ATM
    show ticks
    set wealth wealth + 500
    show word " wealth after work " wealth

  ]
end

to consume
  if wealth >= 0
  [set wealth wealth / 2 ]
end

to make-gang
  find-gangmates
  if count gang-mates > 1
    [
      find-nearest-neighbor
      ifelse [crime-factor] of nearest-neighbor > 8
        [
          separate
          move
        ]
        [ align
          cohere
          check-rob-gang
        ]
    ]
end

to find-gangmates
  set gang-mates other criminals in-radius vision with[crime-factor <= 5]
end

to find-nearest-neighbor ;; turtle procedure
  set nearest-neighbor min-one-of gang-mates [distance myself]
end

to separate  ;; turtle procedure
  turn-away ([heading] of nearest-neighbor) random-float 360
  print word nearest-neighbor "Got seperated from gang"
  print word "Because crime factor is "  [crime-factor]of nearest-neighbor

end

to align  ;; turtle procedure
  turn-towards average-gang-mate-heading 3
end

to cohere  ;; turtle procedure
  turn-towards average-heading-towards-gang-mates 3
end

to turn-away [new-heading max-turn]  ;; turtle procedure
  turn-at-most (subtract-headings heading new-heading) max-turn
end

to turn-towards [new-heading max-turn]  ;; turtle procedure
  turn-at-most (subtract-headings new-heading heading) max-turn
end

to-report average-gang-mate-heading  ;; turtle procedure
                                     ;; We can't just average the heading variables here.
                                     ;; For example, the average of 1 and 359 should be 0,
                                     ;; not 180.  So we have to use trigonometry.
  let x-component sum [dx] of gang-mates
  let y-component sum [dy] of gang-mates
  ifelse x-component = 0 and y-component = 0
    [ report heading ]
    [ report atan x-component y-component ]
end

to-report average-heading-towards-gang-mates  ;; turtle procedure
                                              ;; "towards myself" gives us the heading from the other turtle
                                              ;; to me, but we want the heading from me to the other turtle,
                                              ;; so we add 180
  let x-component mean [sin (towards myself + 180)] of gang-mates
  let y-component mean [cos (towards myself + 180)] of gang-mates
  ifelse x-component = 0 and y-component = 0
    [ report heading ]
    [ report atan x-component y-component ]
end

to turn-at-most [turn max-turn]  ;; turtle procedure
  ifelse abs turn > max-turn
    [ ifelse turn > 0
      [ rt max-turn ]
      [ lt max-turn ] ]
    [ rt turn ]
end

to check-rob-gang
  set nearest-criminal one-of gang-mates with-max[crime-factor]
  set gang-crime-factor [crime-factor] of nearest-criminal
  set max-gang-wealth [wealth]of nearest-criminal
  set max-health [health]of nearest-criminal
  set max-wealth mean[wealth]of gang-mates
  ;show word "max wealth " max-wealth
  ;set other-criminal[0]
  set other-criminal gang-mates
  ;show word "gang criminals are" other-criminal

  ask nearest-criminal
  [

    if (nearest-criminal != nobody)
    [
      set nearby-person people in-radius 1 ;of nearest-neighbor
      set nearby-women one-of women in-radius 1 ;of nearest-neighbor
      let nearby-police one-of police-on neighbors; of nearest-neighbor

      ifelse( nearby-police = nobody )
        [
          if(  nearby-women != nobody )
          [
            ifelse (gang-crime-factor > 3 and max-wealth < 1000)
            [
              do-gang-low-rob-women
              set to-be-rob? true
              set to-walk? false
              learn-crime
              set win win + 1
            ][set fail fail + 1]
          ]
        ]
        [set helped helped + 1]

      ifelse( nearby-police = nobody  )
        [
          if (nearby-person != nobody )
          [
            ifelse (gang-crime-factor > 1 and max-wealth < 1000)
            [
              do-gang-low-rob-kid
              set to-be-rob? true
              set to-walk? false
              learn-crime
              set win win + 1
            ][ set fail fail + 1 ]
          ]
        ]   [set helped helped + 1]

    ]
  ]

end

to check-rob
  ask criminals
  [
    set nearby-criminal criminals in-radius 1
    set current-criminal one-of nearby-criminal
    set current-health [health]of current-criminal
    ;set current-wealth [wealth]of current-criminal
    if (current-criminal != nobody )
    [
      let nearby-police [police-on neighbors] of current-criminal
      set nearby-person [people in-radius 1 ] of current-criminal
      set nearby-women [women in-radius 1] of current-criminal
      ifelse( count nearby-police = 0  )
      [
        ifelse (count nearby-person = 1 )[
          ask current-criminal[
            if (crime-factor > 8 and wealth < 500)
            [
              do-high-rob
              set to-be-rob? true
              set to-walk? false
              learn-crime
              set win win + 1
            ]
            set crime-factor crime-factor

          ]
        ][set fail fail + 1 ]
      ]
      [ set helped helped + 1]
      ifelse( count nearby-police = 0 )
      [
        ifelse(count nearby-women >= 1)[
          ask current-criminal[
            if (crime-factor >= 6 and wealth < 500)
            [
              do-low-rob-women
              set to-be-rob? true
              set to-walk? false
              learn-crime
              set win win + 1
            ]
            set crime-factor crime-factor
          ]
        ][set fail fail + 1]
      ]
      [set helped helped + 1]
      ifelse( count nearby-police = 0  )
      [
        ifelse(count nearby-person >= 1 )[
          ask current-criminal[
            if (crime-factor > 8 and wealth < 1000)
            [
              do-low-rob-kid
              set to-be-rob? true
              set to-walk? false
              learn-crime
            ]
            set crime-factor crime-factor

          ]
        ][set win win + 1]
      ]
      [set helped helped + 1]
    ]
    set avg-wealth-criminals mean [wealth] of criminals

  ]

end

to do-high-rob

  ask nearby-person
    [
      if (wealth > 0 and age > 14 and fight = 1)
        [
          if current-health >= 8
          [
            set tmp 0
            output-print "Found a person to rob"
            output-print  nearby-person
            set tmp wealth / 2
            set wealth wealth / 2
            output-print  word "High robbery on tick" ticks
            output-print word " By " current-criminal
            set num-of-rob num-of-rob + 1
            set pcolor red
            set to-be-rob? true
            set to-walk? false
            set robbed robbed + 1
            output-show word "no: of repeated robbery " robbed
            set crime-table lput current-criminal crime-table
            ;show word "crime-table " crime-table
            learn
            add-wealth-to-criminal

          ]

          set avg-wealth-people mean [wealth] of people
        ]
    ]
end

to do-low-rob-women
  ask nearby-women
  [
    if (wealth > 0)
      [
        set tmp 0
        output-print "Found a woman to rob"
        output-show  nearby-women
        set tmp wealth; / 2
        set wealth 0; wealth / 2
        output-print  word "Low robbery on tick" ticks
        output-print word "By " current-criminal
        set num-of-rob num-of-rob + 1
        set pcolor red
        set to-be-rob? true
        set to-walk? false
        set robbed robbed + 1
        output-show word "no: of repeated robbery " robbed
        set crime-table lput current-criminal crime-table
        ;show word "crime-table " crime-table
        learn
        add-wealth-to-criminal

      ]

    set avg-wealth-women mean [wealth] of women

  ]

end

to do-low-rob-kid
  ask nearby-person
    [
      ifelse (wealth > 0 and age <= 14)
        [
          set tmp 0
          output-print "Found a kid to rob"
          output-show  nearby-person
          set tmp wealth ;/ 2
          set wealth 0; wealth / 2
          output-print  word "Low robbery on tick" ticks
          output-print word "By " current-criminal
          set num-of-rob num-of-rob + 1
          set pcolor red
          set to-be-rob? true
          set to-walk? false
          set robbed robbed + 1
          output-show word "no: of repeated robbery " robbed
          set crime-table lput current-criminal crime-table
          ;show word "crime-table " crime-table
          learn
          add-wealth-to-criminal

        ]
        [
          if ( fight = 0 and age > 14 and wealth  > 0)
          [
            if (current-health <  4)
            [
              set tmp 0
              output-print "Found a scared person to rob"
              output-show  nearby-person
              set tmp wealth; / 2
              set wealth 0; wealth / 2
              output-print  word "Low robbery on tick" ticks
              output-print word "By " current-criminal
              set num-of-rob num-of-rob + 1
              set pcolor red
              set to-be-rob? true
              set to-walk? false
              set robbed robbed + 1
              output-show word "no: of repeated robbery " robbed
              set crime-table lput current-criminal crime-table
              learn
              add-wealth-to-criminal

            ]
          ]

        ]

      set avg-wealth-people mean [wealth] of people
    ]
end
to add-wealth-to-criminal
  ask current-criminal
    [
      output-print word " Crime factor of " current-criminal
      output-print word " is " crime-factor
      set crime-factor crime-factor + 1
      output-print word "Crime factor updated to " crime-factor
      set wealth wealth + tmp
      output-print word "Wealth updated to " wealth

      wait pause
    ]
end

to add-wealth-to-gangmates
  ask other-criminal
    [
      set wealth wealth + tmp
      set crime-factor crime-factor + 1
      output-show word "WEALTH OF GANG MATES IS " wealth
      output-show word "CRIME FACTOR OF GANG MATES IS " crime-factor

      wait pause
    ]

end
to do-gang-low-rob-women
  ask nearby-women
  [
    if (wealth > 0)
      [
        set tmp 0
        output-print "Found a woman to rob by gang"
        output-show   nearby-women
        set tmp wealth / 2
        set wealth wealth / 2
        output-print  word "Gang low robbery on tick" ticks
        set num-of-gang-rob num-of-gang-rob + 1
        set pcolor red
        set to-be-rob? true
        set to-walk? false
        set robbed robbed + 1
        output-show word "no: of repeated robbery " robbed
        set crime-table lput nearest-criminal crime-table
        ;show word "crime-table " crime-table
        learn
        add-wealth-to-gangmates

      ]
    set avg-wealth-women mean [wealth] of women
  ]

end
to do-gang-low-rob-kid
  ask nearby-person
    [
      ifelse (wealth > 0 and age <= 14)
        [

          output-print nearest-criminal
          set tmp 0
          output-print "Found a kid to rob by gang"
          output-show nearby-person
          set tmp wealth / 2
          set wealth wealth / 2
          output-print  word "Low robbery on tick" ticks
          set num-of-gang-rob num-of-gang-rob + 1
          set pcolor red
          set to-be-rob? true
          set to-walk? false
          set robbed robbed + 1
          output-show word "no: of repeated robbery " robbed
          set crime-table lput nearest-criminal crime-table
          ;show word "crime-table " crime-table
          learn
          add-wealth-to-gangmates

        ]
        [
          if (wealth > 0 and age > 14 and  fight = 0)
            [
              if max-health < 3
              [
                output-print nearest-criminal
                set tmp 0
                output-print "Found a scared person to rob by gang"
                output-show nearby-person
                set tmp wealth / 2
                set wealth wealth / 2
                output-print  word "Low robbery on tick" ticks
                set num-of-gang-rob num-of-gang-rob + 1
                set pcolor red
                set to-be-rob? true
                set to-walk? false
                set robbed robbed + 1
                output-show word "no: of repeated robbery " robbed
                set crime-table lput nearest-criminal crime-table
                ;show word "crime-table " crime-table
                learn
                add-wealth-to-gangmates

              ]
            ]
        ]

      set avg-wealth-people mean [wealth] of people
    ]

end

to police-help
  ask police
  [
    set current-help one-of people-on neighbors ;with [wealth > 0 or robbed > 0]
    set current-lady one-of women-on neighbors ;with [wealth > 0 or robbed > 0]
    ;set current-police one-of police-on neighbors
    ifelse (current-help != nobody); and current-police = nobody)
    [
     ; fd speed + 0.05
      move-to current-help
    ]
    [
    if (current-lady != nobody); and current-police = nobody)
    [
   ;  fd speed + 0.05
      move-to current-lady
    ]
    ]
  ]
end

to learn
  if  to-walk? = true
  [
    set reward reward + 1
    set episode episode + 1
  ]
  ; show word "reward is " reward
  if to-be-rob? = true
  [
    set reward reward - 100
    set episode episode + 1
  ]
  let dir  min qtable
  let dirp position  dir qtable
  set Qnew Qnew + learning-rate * (reward + Q - Qnew) ;--perform Q-Learning
  set qtable lput Qnew qtable
  set Q max qtable
  ;show word "Q is "Q
  ;show qtable
  let lng length qtable
  set avg-reward (avg-reward + reward) / lng
  ;show avg-reward
  if Q > 10000
  [avoid]
end

to learn-crime
  if  to-walk? = true
  [
    set reward reward - 0.01
    set episode episode + 1
  ]
  ; show word "reward is " reward
  if to-be-rob? = true
  [
    set reward reward + 1
    set episode episode + 1
  ]
  let dir  min qtable
  let dirp position  dir qtable
  set Qnew Qnew + learning-rate * (reward + Q - Qnew) ;--perform Q-Learning
                                                      ;set qtable replace-item dirp  qtable Qnew

                                                      ;if Qnew > Q
                                                      ;[ ]
  set qtable lput Qnew qtable
  set Q max qtable
  let lng length qtable
  set avg-reward-crime (avg-reward-crime + reward) / lng

end

to rest-of-people
  let rest people with [wealth > 0]
  ask  rest[
    output-show word "rest of people are " count rest
    output-show word "wealth " wealth
    output-show word "age " age
    output-show word "fight " fight
  ]
end

to avoid
  let nearone one-of criminals-on neighbors
  let nearhelp one-of people-on neighbors
  let ok? false
  if member? nearone crime-table
    [
      if nearhelp != nobody
      [ask nearhelp [if fight = 1[ set ok? true]]]
      ifelse ok? = true
        [
          move-to nearhelp
          show word "moving to " nearhelp
        ]
        [
          ifelse [pcolor] of patch-ahead 1 = green
          [ lt random-float 360 ]
          [back speed]
        ]
      ;show crime-table
      ;print Q
      show word "avoiding" nearone
    ]

end


to watch-women
  let lady one-of women
  follow lady
  ask lady
  [
    set label who
    set label-color black
    show lady
    show word "wealth "wealth
  ]
end

to watch-kids
  let kid one-of people with [age <= 14]
  follow kid
  ask kid
  [
    set label who
    set label-color black
    show kid
    show word "wealth "wealth
    show word "age "age
  ]
end

to watch-men
  let man one-of people with [age > 14]
  follow man
  ask man
  [
    set label who
    set label-color black
    show man
    show word "wealth "wealth
    show word "age "age
    show word "fight "fight
  ]
end

to watch-robbers
  let robber one-of criminals
  follow robber
  ask robber
  [
    set label who
    set label-color black
    show robber
    show word "wealth "wealth
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
256
10
726
481
-1
-1
14.0
1
15
1
1
1
0
1
1
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
821
182
890
215
Setup
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

SLIDER
7
12
131
45
num-of-person
num-of-person
0
20
1.0
1
1
NIL
HORIZONTAL

SLIDER
7
51
136
84
num-of-criminals
num-of-criminals
0
20
4.0
1
1
NIL
HORIZONTAL

SLIDER
5
91
127
124
num-of-police
num-of-police
0
20
20.0
1
1
NIL
HORIZONTAL

BUTTON
895
182
983
215
Simulate
go\nif(mean [wealth] of women + mean [wealth] of people = 0)\n[stop]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

MONITOR
6
220
118
265
Avg wealth of people
mean [wealth] of people
1
1
11

MONITOR
4
271
118
316
Avg wealth of criminal
mean [wealth] of criminals
1
1
11

PLOT
993
164
1247
300
Avg wealth
time
wealth
0.0
1.0
0.0
1.0
true
true
"set-plot-y-range  0 5000" ""
PENS
"people" 1.0 0 -2674135 true "" "plot mean [wealth] of people"
"criminal" 1.0 0 -13345367 true "" "plot mean [wealth] of criminals"
"women" 1.0 0 -10899396 true "" "plot mean [wealth] of women"

PLOT
992
10
1246
164
Robbery rate
time
No: of robbery
0.0
10.0
0.0
10.0
true
true
"set-plot-y-range  0 20" ""
PENS
"No:of  rob" 1.0 0 -6459832 true "" "plot num-of-rob"
"No:of gang rob" 1.0 0 -1184463 true "" "plot num-of-gang-rob"

BUTTON
12
331
117
364
watch criminal
watch-robbers
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

MONITOR
1152
79
1235
128
Total robbery
num-of-rob + num-of-gang-rob
1
1
12

BUTTON
133
332
240
365
watch people
watch-men
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
144
127
236
160
vision
vision
1
5
5.0
0.5
1
NIL
HORIZONTAL

SLIDER
145
72
237
105
pause
pause
0
10
0.0
1
1
NIL
HORIZONTAL

CHOOSER
127
268
237
313
choose-road
choose-road
"Road 1" "Road 2"
1

SLIDER
4
129
129
162
num-of-women
num-of-women
0
50
20.0
1
1
NIL
HORIZONTAL

MONITOR
6
170
118
215
Avg wealth of women
mean [wealth] of women
1
1
11

OUTPUT
758
307
1253
537
15

SWITCH
127
176
242
209
police-help?
police-help?
0
1
-1000

MONITOR
752
165
809
214
Kids
count people with[age <= 14]
1
1
12

SLIDER
145
15
237
48
speed
speed
0.05
1
0.15
0.05
1
NIL
HORIZONTAL

SLIDER
127
223
235
256
learning-rate
learning-rate
0
1
0.9
0.1
1
NIL
HORIZONTAL

PLOT
751
10
981
160
performance of crime
episode
avg-reward
0.0
1.0
0.0
1.0
true
true
"set-plot-y-range  0 1" ""
PENS
"win rate" 1.0 0 -10899396 true "" "plot win"
"fail rate" 1.0 0 -2674135 true "" "plot fail"
"help" 1.0 0 -13345367 true "" "plot helped"

BUTTON
831
231
901
264
movie
make-movie
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
16
388
110
421
watch women
watch-women
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
134
388
232
421
watch kids
watch-kids
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
150
433
213
466
rest
rest-of-people
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
4
475
204
625
reward of people
time
reward
0.0
1.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -2674135 true "" "plot avg-reward"

@#$#@#$#@
## WHAT IS IT?

Simulation of street robbery
## HOW IT WORKS

Criminals are divided into light and heavy criminals according to crime factor. Light criminals forms gang and do gang robbery. When they achieve crime factor greater than 5, they do heavy robbery. Light robbery gains half the wealth of victims. Victims are - people, women and kids. Women and kids are easy to rob. The presence of police avoids robbery

## HOW TO USE IT

Click on the SETUP button to set up the scene. Set the NUMBER slider to change the number of agents on the road. Click on Simulate to start the agents moving.  Note that they wrap around the world as they move, so the road is like a continuous loop. Pause slider controls the ticks to wait after robbery. Vision slider adjusts the vision of light criminals to form gang.
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

building institution
false
0
Rectangle -7500403 true true 0 60 300 270
Rectangle -16777216 true false 130 196 168 256
Rectangle -16777216 false false 0 255 300 270
Polygon -7500403 true true 0 60 150 15 300 60
Polygon -955883 false false 0 75 150 30 300 75
Circle -1 true false 135 26 30
Circle -16777216 false false 135 25 30
Rectangle -16777216 false false 0 60 300 75
Rectangle -16777216 false false 218 75 255 90
Rectangle -16777216 false false 218 240 255 255
Rectangle -16777216 false false 224 90 249 240
Rectangle -16777216 false false 45 75 82 90
Rectangle -16777216 false false 45 240 82 255
Rectangle -16777216 false false 51 90 76 240
Rectangle -16777216 false false 90 240 127 255
Rectangle -16777216 false false 90 75 127 90
Rectangle -16777216 false false 96 90 121 240
Rectangle -16777216 false false 179 90 204 240
Rectangle -16777216 false false 173 75 210 90
Rectangle -16777216 false false 173 240 210 255
Rectangle -16777216 false false 269 90 294 240
Rectangle -16777216 false false 263 75 300 90
Rectangle -16777216 false false 263 240 300 255
Rectangle -16777216 false false 0 240 37 255
Rectangle -16777216 false false 6 90 31 240
Rectangle -16777216 false false 0 75 37 90
Line -16777216 false 112 260 184 260
Line -16777216 false 105 265 196 265

building store
false
5
Rectangle -10899396 true true 30 45 45 240
Rectangle -10899396 true true 15 165 285 255
Rectangle -16777216 true false 30 180 105 240
Rectangle -16777216 true false 195 180 270 240
Line -16777216 false 0 165 300 165
Polygon -10899396 true true 0 165 45 135 60 90 240 90 255 135 300 165

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

criminal
false
6
Polygon -7500403 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -16777216 true false 60 196 90 211 114 155 120 196 180 196 187 158 210 211 240 196 195 91 165 91 150 106 150 135 135 91 105 91
Circle -7500403 true false 110 5 80
Rectangle -7500403 true false 127 79 172 94
Polygon -8630108 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285

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
14
Circle -16777216 true true 110 5 80
Polygon -16777216 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -16777216 true true 127 79 172 94
Polygon -16777216 true true 195 90 240 150 225 180 165 105
Polygon -16777216 true true 105 90 60 150 75 180 135 105
Circle -16777216 true true 133 43 2

person 
false
0
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -2674135 true false 120 90 105 90 60 195 90 210 120 150 120 195 180 195 180 150 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Polygon -1 true false 123 90 149 141 177 90
Rectangle -2674135 true false 123 76 176 92
Circle -2674135 true false 110 5 80
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -2674135 true false 180 90 195 90 183 160 180 195 150 195 150 135 180 90
Polygon -2674135 true false 120 90 105 90 114 161 120 195 150 195 150 135 120 90
Rectangle -16777216 true false 118 129 141 140

person business
false
4
Rectangle -1 true false 120 90 180 180
Polygon -13345367 true false 135 90 150 105 135 180 150 195 165 180 150 105 165 90
Polygon -13345367 true false 120 90 105 90 60 195 90 210 116 154 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 183 153 210 210 240 195 195 90 180 90 150 165
Circle -7500403 true false 110 5 80
Rectangle -7500403 true false 127 76 172 91
Line -16777216 false 172 90 161 94
Line -16777216 false 128 90 139 94
Line -16777216 false 180 90 150 165
Line -16777216 false 120 90 150 165

person graduate
false
0
Circle -16777216 false false 39 183 20
Polygon -1 true false 50 203 85 213 118 227 119 207 89 204 52 185
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -8630108 true false 90 19 150 37 210 19 195 4 105 4
Polygon -8630108 true false 120 90 105 90 60 195 90 210 120 165 90 285 105 300 195 300 210 285 180 165 210 210 240 195 195 90
Polygon -1184463 true false 135 90 120 90 150 135 180 90 165 90 150 105
Line -2674135 false 195 90 150 135
Line -2674135 false 105 90 150 135
Polygon -1 true false 135 90 150 105 165 90
Circle -1 true false 104 205 20
Circle -1 true false 41 184 20
Circle -16777216 false false 106 206 18
Line -2674135 false 208 22 208 57

person police
false
6
Polygon -1 true false 124 91 150 165 178 91
Polygon -6459832 true false 134 91 149 106 134 181 149 196 164 181 149 106 164 91
Polygon -6459832 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -6459832 true false 120 90 105 90 60 195 90 210 116 158 120 195 180 195 184 158 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Rectangle -7500403 true false 123 76 176 92
Circle -7500403 true false 110 5 80
Polygon -6459832 true false 150 26 110 41 97 29 137 -1 158 6 185 0 201 6 196 23 204 34 180 33
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Rectangle -16777216 true false 109 183 124 227
Rectangle -16777216 true false 176 183 195 205
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Polygon -1184463 true false 172 112 191 112 185 133 179 133
Polygon -1184463 true false 175 6 194 6 189 21 180 21
Line -1184463 false 149 24 197 24
Rectangle -16777216 true false 101 177 122 187
Rectangle -16777216 true false 179 164 183 186

person student
false
0
Polygon -13791810 true false 135 90 150 105 135 165 150 180 165 165 150 105 165 90
Polygon -7500403 true true 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 100 210 130 225 145 165 85 135 63 189
Polygon -13791810 true false 90 210 120 225 135 165 67 130 53 189
Polygon -1 true false 120 224 131 225 124 210
Line -16777216 false 139 168 126 225
Line -16777216 false 140 167 76 136
Polygon -7500403 true true 105 90 60 195 90 210 135 105

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
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

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

women
false
5
Circle -7500403 true false 110 5 80
Rectangle -7500403 true false 127 79 172 94
Polygon -2064490 true false 120 90 105 90 60 195 90 210 120 165 90 285 105 300 195 300 210 285 180 165 210 210 240 195 195 90
Rectangle -11221820 true false 45 225 105 255
Line -13791810 false 105 225 90 210
Line -13791810 false 45 225 60 195
Rectangle -11221820 true false 120 150 180 180

workshop
false
1
Rectangle -1 true false 15 165 285 255
Rectangle -16777216 true false 120 195 180 255
Line -7500403 false 150 195 150 255
Rectangle -16777216 true false 30 180 105 240
Rectangle -16777216 true false 195 180 270 240
Line -16777216 false 0 165 300 165
Polygon -955883 true false 0 165 45 135 60 90 240 90 255 135 300 165
Rectangle -16777216 false false -15 15 60 30

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
