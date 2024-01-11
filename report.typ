#let var(s) = math.equation(s.clusters().map(s => [#s]).join([ ]))

#let Position = var("Position")
#let Battery = var("Battery")

#let left = var("left")
#let right = var("right")
#let up = var("up")
#let down = var("down")

#let uleft = var("uleft")
#let uright = var("uright")
#let uup = var("uup")
#let udown = var("udown")

#let charge = var("charge")

#let X1Y1 = var("X1Y1")
#let X4Y2 = var("X4Y2")
#let X2Y2 = var("X2Y2")
#let X1Y2 = var("X1Y2")
#let X3Y2 = var("X3Y2")
#let X2Y1 = var("X2Y1")
#let X2Y3 = var("X2Y1")

#let requirement(text) = v(0.2em) + h(1em) + [ _ #text _ ]

#set text(size: 12pt, font: "New Computer Modern")
#set page(numbering: "1")

#align(center)[
  #heading(outlined: false)[
    Formal Methods for Cyberphysical systems \
    Assignment 2
  ]

  #v(1em)

  #text(size: 15pt, "Stevanato Giacomo")

  #text(size: 15pt, "10/01/2024")
]

= Plant definition

== States

I started by modelling the movements of the rovers in the grid. The two rovers are independent, so I represented them with two different sets of plants. I will refer to the yellow rover as rover 1 and to the blue rover as rover 2.

To each rover $i$ are associated two plants: $Position{i}$ and $Battery{i}$, respectively tracking the rover's position and battery charge.

=== Position

In each $Position{i}$ plant I defined a state for every possible tile, representing the rover currently being in that tile. I named the states $X{x}Y{y}$ where ${x}$ is the $X$ coordinate of the corresponding tile, ranging from 1 to 5, and ${y}$ is its $Y$ coordinate, ranging from 1 to 3.
I made $X1Y1$ the initial state for rover 1 and $X4Y2$ the initial state for rover 2. I marked only the initial states since I considered those to be the "stable" states. Other possible choices could have been marking the states representing tiles with charging stations or all the states.

=== Battery

In each $Battery{i}$ plant I defined a state for each possible battery level, representing the rover's battery currently being at that level. I named the states $L{l}$ where ${l}$ is the current battery level and ranges from 0 to 6. I made $L 6$ the initial state since rovers start fully charged. I marked only $L 6$ since I considered that to be the "stable" state. Other possible choices could have been marking all the non-zero level states, or all the states.

== Events

I defined the following 9 events for each rover $i$:

- $left{i}$, $right{i}$, $down{i}$ and $up{i}$, the controllable events for the movements in the 4 directions of rover $i$;
- $uleft{i}, uright{i}, udown{i} "and" uup{i}$, the uncontrollable events for the movements in the 4 directions of rover $i$;
- $charge{i}$, the controllable event for charging.

I decided to make $charge{i}$ controllable events since it is stated that:

#h(1em) _If a Rover sits on any of these tiles, then it *can* get a full charge_

Which I interpreted to mean that it is not required to get the full charge and choose not to.

== Edges

=== Position

For the $Position{i}$ plants I added an edge between two states if the corresponding tiles are adjacent. In particular I added, excluding the state $X2Y2$:
- for all $2 <= x <= 5, 1 <= y <= 3$, an edge with event $left{i}$ from the state $X{x}Y{y}$ to the state $X{x-1}Y{y}$ of rover $i$;
- for all $1 <= x <= 4, 1 <= y <= 3$, an edge with event $right{i}$ from the state $X{x}Y{y}$ to the state $X{x+1}Y{y}$ of rover $i$;
- for all $1 <= x <= 5, 2 <= y <= 3$, an edge with event $up{i}$ from the state $X{x}Y{y}$ to the state $X{x}Y{y-1}$ of rover $i$;
- for all $1 <= x <= 5, 1 <= y <= 2$, an edge with event $down{i}$ from the state $X{x}Y{y}$ to the state $X{x}Y{y+1}$ of rover $i$.

The $X2Y2$ states represent the rovers being on the red tile, where the movements are uncontrollable. Hence added the following edges for them:
- an edge with event $uleft{i}$ to the state $X1Y2$;
- an edge with event $uright{i}$ to the tile $X3Y2$;
- an edge with event $uup{i}$ to the state $X2Y1$;
- an edge with event $udown{i}$ to the state $X2Y3$.

These edges corresponds to the ones I would have added for the other states, except they use the corresponding uncontrollable events to make the movements uncontrollable by the rover.

I also added self-edges with event $charge{i}$ for the charging in the states $X1Y1$ and $X4Y2$, limiting the ability to charge the battery only on the corresponding tiles.

=== Battery

For the $Battery{i}$ plants I added an edge from every level to the next lower one, that is for every $1 <= l <= 6$ I added an edge for every move $left{i}$, $right{i}$, $up{i}$, $down{i}$, $uleft{i}$, $uright{i}$, $uup{i}$ and $udown{i}$ from the state $L{l}$ to the state $L{l-1}$, representing the decrease in battery level after a move. There's no such edge for the state $L 0$, representing the fact that a rover can't move when its battery runs out of energy. I also added edges for the charging, in particular for every $0 <= l <= 5$ I added an edge with event $charge{i}$ from the state $L{l}$ to the state $L 6$. I choose not to add the edge in the state $L 6$ because it doesn't make sense to charge the battery if it's already charged.

= Requirements

== Requirement 1

#requirement[ Both rovers never run our of battery on tiles that do not have a charging station. ]

== Requirement 2

#requirement[ Both rovers must always alternate the use of the charging stations in $(1,1)$ and $(2,4)$ regardless of which is used first. ]

=== Optimized version

== Requirement 3

#requirement[ Rovers don't collide with each other (i.e., they are never simultaneously on a same tile). ]

=== Optimized version
