#let requirement(text) = [
  #v(0.5em) #h(1em) _ #text _
]

#set text(size: 12pt, font: "New Computer Modern")

#set page(numbering: "1")

#align(center)[
  #heading[
    Formal Methods for Cyberphysical systems \
    Assignment 2
  ]

  #v(1em)

  #text(size: 15pt, "Stevanato Giacomo")

  #text(size: 15pt, "10/01/2024")
]

== Plant definition

// #figure(image("escet/plant/plant.svg", width: 80%))

// #requirement[ The figure above provides a graphical representation of a plant in which 2 Rovers (yellow and blue circles) move on a $(3 times 5)$ grid according to the movements that are possible in each specific tile. ]

I started modelling the movements of the rovers in the grid. The two rovers are independent, so I represented them with two different plants.

In each plant I defined a state for every possible cell, representing the rover currently being in that cell. For better understanding I named the states according to the $X$ and $Y$ coordinates of the corresponding cell.

I then added a transition between two states if there's a move that can move a rover from the cell corresponding to the first state to the one correspoding to the second state. 
// TODO: for each x < 5 and y ...
// TODO: event
The only exception to this are moves from the cell $(2, 2)$, which instead use the uncontrollable events.

== Requirement 1

#requirement[ Both rovers never run our of battery on tiles that do not have a charging station. ]

== Requirement 2

#requirement[ Both rovers must always alternate the use of the charging stations in $(1,1)$ and $(2,4)$ regardless of which is used first. ]

=== Optimized version

== Requirement 3

#requirement[ Rovers don't collide with each other (i.e., they are never simultaneously on a same tile). ]

=== Optimized version
