#import "automata.typ"
#import "defs.typ": *

#set text(size: 12pt, font: "New Computer Modern")
#set page(numbering: "1")

#align(center)[
  #heading(outlined: false)[
    Formal Methods for Cyberphysical Systems \
    Assignment 2
  ]

  #v(1em)

  #text(size: 15pt, "Stevanato Giacomo")

  #text(size: 15pt, "10/01/2024")
]

=== Conventions

In this report the notation $pre{x}post$ will be used to mean the string resulting from the concatenation of the literal string $pre$, the value of the expression $x$ and the literal string $post$. For example if $x$ is $1$ the string $pre{x+1}post$ will be $pre 2 post$.

= Plant definition

== States

I started by modelling the movements of the rovers in the grid. The two rovers are independent, so I represented them with two different sets of plants. I will refer to the yellow rover as rover 1 and to the blue rover as rover 2.

For each rover $i$ I defined two plants, $Position{i}$ and $Battery{i}$, respectively tracking the rover's position and battery level.

=== Position

In each $Position{i}$ plant I defined a state for every possible tile, representing the rover currently being on that tile. I considered the grid in a cartesian plane with the $X$ axis going right and the $Y$ axis going down and I named the states $X{x}Y{y}$ where $x$ is the $X$ coordinate of the corresponding tile, ranging from 1 to 5, and $y$ is its $Y$ coordinate, ranging from 1 to 3.
I made $X1Y1$ the initial state for rover 1 and $X4Y2$ the initial state for rover 2. I marked only the initial states since I considered those to be the "stable" states. Other possible choices could have been marking the states representing tiles with charging stations or all the states.

=== Battery

In each $Battery{i}$ plant I defined a state for each possible battery level, representing the rover's battery currently being at that level. I named the states $L{l}$ where $l$ is the current battery level and ranges from 0 to 6. I made $L6$ the initial state since rovers start fully charged. I marked only $L6$ since I considered that to be the "stable" state. Other possible choices could have been marking $L0$ too, or all the non-zero level states, or all the states.

== Events

I defined the following 9 events for each rover $i$:

- $left{i}$, $right{i}$, $down{i}$ and $up{i}$, the controllable events for the movements in the 4 directions of rover $i$;
- $uleft{i}, uright{i}, udown{i} "and" uup{i}$, the uncontrollable events for the movements in the 4 directions of rover $i$;
- $charge{i}$, the controllable event for charging.

I decided to make the $charge{i}$ events controllable since it is stated that:

#h(1em) _If a Rover sits on any of these tiles, then it *can* get a full charge_

Which I interpreted to mean that it is not required to get the full charge and choose not to.

== Edges

=== Position

For the $Position{i}$ plants I added an edge between two states if the corresponding tiles are adjacent. In particular I added, excluding for the state $X2Y2$:
- for all $2 <= x <= 5, 1 <= y <= 3$, an edge with event $left{i}$ from the state $X{x}Y{y}$ to the state $X{x-1}Y{y}$ of rover $i$;
- for all $1 <= x <= 4, 1 <= y <= 3$, an edge with event $right{i}$ from the state $X{x}Y{y}$ to the state $X{x+1}Y{y}$ of rover $i$;
- for all $1 <= x <= 5, 2 <= y <= 3$, an edge with event $up{i}$ from the state $X{x}Y{y}$ to the state $X{x}Y{y-1}$ of rover $i$;
- for all $1 <= x <= 5, 1 <= y <= 2$, an edge with event $down{i}$ from the state $X{x}Y{y}$ to the state $X{x}Y{y+1}$ of rover $i$.

The $X2Y2$ states represent the rovers being on the red tile, where the movements are uncontrollable. Hence I added the following edges for them:
- an edge with event $uleft{i}$ to the state $X1Y2$;
- an edge with event $uright{i}$ to the tile $X3Y2$;
- an edge with event $uup{i}$ to the state $X2Y1$;
- an edge with event $udown{i}$ to the state $X2Y3$.

These edges corresponds to the ones I would have added for the other states, except they use the corresponding uncontrollable events to make the movements uncontrollable by the rover.

I also added self-edges with event $charge{i}$ for the charging in the states $X1Y1$ and $X4Y2$, limiting the ability to charge the battery only on the corresponding tiles.

=== Battery

For the $Battery{i}$ plants I added an edge from every level to the previous one for every move, that is for every $1 <= l <= 6$ I added an edge with events $left{i}$, $right{i}$, $up{i}$, $down{i}$, $uleft{i}$, $uright{i}$, $uup{i}$ and $udown{i}$ from the state $L{l}$ to the state $L{l-1}$, representing the decrease in battery level after a move. There's no such edge for the state $L0$, representing the fact that a rover can't move when its battery runs out of energy. I also added edges for the charging, in particular for every $0 <= l <= 5$ I added an edge with event $charge{i}$ from the state $L{l}$ to the state $L6$. I choose not to add the edge in the state $L6$ because it doesn't make sense to charge the battery if it's already charged.

== Automata

Here are the final automata for the plants:

#figure(automata.position(1), caption: [ Plant $Position 1$ ])
#figure(automata.battery(1), caption: [ Plant $Battery 1$ ])
#figure(automata.position(2), caption: [ Plant $Position 2$ ])
#figure(automata.battery(2), caption: [ Plant $Battery 2$ ])

= Requirements

#let requirement(text) = v(0.2em) + h(1em) + [ _ #text _ ]

== Requirement 1

#requirement[ Both rovers never run our of battery on tiles that do not have a charging station. ]

The requirement can be defined by copying the $Battery{i}$ plants and updating their marking so that the state $L0$ is not marked. This way any rover that runs out of energy on a non-charging station tile will be stuck on state $L0$ due to not being able to charge or move. This means such state is a blocking state and will be pruned by the supervisor synthesis.

In the case of our chosen marking, $L0$ is already not marked, so this requirement is redundant.

== Requirement 2

#requirement[ Both rovers must always alternate the use of the charging stations in $(1,1)$ and $(2,4)$ regardless of which is used first. ]

Let the station in position $(1,1)$ be station 1 and the one in position $(4,2)$ be station 2. The given requirement could be translated using the following automata, once for each rover, where $I$ represent the initial state when no charging station has been used by rover $i$, and $N1$ and $N2$ represent the states where the next charging station that has to be used are respectively station 1 and 2.

#figure(automata.r2-alternate, caption: "Automaton for alternating two events.")

There's however no way to directly express the "at station $j$" edges since we cannot distinguish at which station the $charge{i}$ event was performed. We thus have to also track in which position the rover is currently at, which can be done by creating 3 copies of the $Position{i}$ plant states, one for every state in the automaton in the figure. Given $S_i$ the initial state in $Position{i}$, ${S_i}I$ will be the new initial state. All states will be marked, since this automata is irrelevant for marking.

More formally, for every state ${S}$ in $Position{i}$ we add three states: ${S}I$, ${S}N1$ and ${S}N2$. For every edge between states ${S 1}$ and ${S 2}$ we add an edge between states ${S 1}{M}$ and ${S 2}{M}$ for all $M in {I, N1, N2}$, except for the following edges with $charge{i}$ events:
- the self-edge in $X1Y1 I$, which is replaced with an edge to $X1Y1 N2$, representing the topmost edge;
- the self-edge in $X4Y2 I$, which is replaced with an edge to $X4Y2 N1$, representing the bottommost edge;
- the self-edge in $X1Y1 N1$, which is replaced with an edge to $X1Y1 N2$, representing the rightmost edge;
- the self-edge in $X4Y2 N1$, which is removed;
- the self-edge in $X1Y1 N2$, which is removed;
- the self-edge in $X4Y2 N2$, which is replaced with an edge to $X4Y2 N1$, representing the center edge.

This way all the $charge{i}$ edges represent one of the edges in the automata shown in the figure before.

#for i in (1, 2) {
  figure(
    automata.r2(i),
    caption: [ Rover #i's automaton for requirement $R 2$ ]
  )
}

=== Compact version

We can exploit the structure of the problem to reduce the number of states we have to manually declare. There are in fact only 2 stations, so they must differ in either their X or Y coordinate. We can then only track that coordinate instead of both of them, and that will be enough to distinguish the two $charge{i}$ cases because at most one charging station exists for a given coordinate value. In our case the charging stations positions differ by both coordinates, so we can pick the one with fewer cases to track, which is Y. We thus have 9 states: $Y{y}{M}$ for $1 <= y <= 3$ and $M in { I, N1, N2 }$ and the following edges:
- for $y in {1, 2}, M in {I, N1, N2}$ an edge with events $up{i}$ and $uup{i}$ from $Y{y}M$ to $Y{y+1}M$;
- for $y in {2, 3}, M in {I, N1, N2}$ an edge with events $down{i}$ and $udown{i}$ from $Y{y}M$ to $Y{y-1}M$;
- an edge with event $charge{i}$ from $Y 1 I$ to $Y 1 N2$;
- an edge with event $charge{i}$ from $Y 2 I$ to $Y 2 N1$;
- an edge with event $charge{i}$ from $Y 1 N1$ to $Y 1 N2$;
- an edge with event $charge{i}$ from $Y 2 N2$ to $Y 2 N1$.

#for i in (1, 2) {
  figure(
    automata.r2-alternate-compact(i),
    caption: [ Rover #i's compact automaton for requirement $R 2$ ]
  )
}

== Requirement 3

#requirement[ Rovers don't collide with each other (i.e., they are never simultaneously on a same tile). ]

The given requirement could be translated by computing the synchronous product of $Position 1$ and $Position 2$ and removing all the nodes where the state from $Position 1$ and the one from $Position 2$ have the same name, that is when Rover 1 is on the same tile as Rover 2. Unfortunately this doesn't scale well, it produces 210 states which I considered too many for a human to quickly verify their correctness.

Another, more compact, approach is to track the relative position of the two rovers. There are 9 possible relative positions $x_1 - x_2$ on the $X$ axis, from $-4$ to $4$ and 5 possible relative positions $y_1 - y_2$ on the $Y$ axis, from $-2$ to $2$. These will be the states of 2 automatas, while their edges will be:
- for all $-3 <= d x <= 4$, an edge with events $left 1$, $uleft 1$, $right 2$ and $uright 2$ from $d x$ to $d x - 1$;
- for all $-4 <= d x <= 3$, an edge with events $right 1$, $uright 1$, $left 2$ and $uleft 2$ from $d x$ to $d x + 1$;
- for all $-1 <= d y <= 2$, an edge with events $up 1$, $uup 1$, $down 2$ and $udown 2$ from $d y$ to $d y - 1$;
- for all $-1 <= d y <= 2$, an edge with events $down 1$, $udown 1$, $up 2$ and $uup 2$ from $d y$ to $d y + 1$.

The initial states are $-3$ and $-1$, because those are differences of the initial coordinates of the rovers. All states have been marked, since these automata are irrelevant to marking. To satisfy the requirement it's then sufficient to compute the synchronous product of the two automata, remove the state corresponding to the relative position on both axes being 0, which represents the two rovers being on the same tile.
This ends up requiring the user to specify only 44 states, which scales a bit better.

Due to the inability of using the dash character (`-`) in CIF identifiers, I mapped the relative $X$ positions to the names $L 4$, $L 3$, $L 2$, $L 1$, $S X$, $R 1$, $R 2$, $R 3$ and $R 4$, representing rover 1 being on the left ($L{l}$), on the same $X$ ($S X$) or on the right ($R{r}$) of rover 2, and the relative $Y$ positions to the names $U 2$, $U 1$, $S Y$, $D 1$ and $D 2$, representing rover 1 being up ($U{u}$), on the same $Y$ ($S Y$) or down ($D{d}$) relative to rover 2.

// TODO: over/under vs up/down?
#figure(automata.r3, caption: [ Automaton for requirement 3 ])

=== Compact version

If we allow the introduction of a new uncontrollable event $sametile$ we can create an even more compact requirement automaton. This event will never happen, in fact it will be used to have the supervisor remove any state that can perform this event. The way this is done is by creating an automaton with two states, an initial marked state $Valid$ and another unmarked state $Invalid$, with a single edge with event $sametile$ from $Valid$ to $Invalid$. This way if the $sametile$ event ever happens it will lead to a blocking state and thus the supervisor will have to trim it; moreover since it is uncontrollable it will have to trim any state that can execute it or can reach it with uncontrollable events.

Then we can keep the two automata for the relative $X$ and $Y$ positions separate, and add a self-loop with event $sametile$ on the states $S X$ and $S Y$. This way if the rovers are in the same position, that is the two automata are in the states $S X$ and $S Y$, they will be able to perform the event $sametile$ and reach a blocking state, hence the supervisor will remove this state for us.

#figure(automata.r3-compact, caption: [ Compact automata for requirement 3 ])
