#import "automata.typ"
#import "defs.typ": *

#set par(justify: true)
#set text(size: 12pt, font: "New Computer Modern")
#set page(numbering: "1")

#align(center)[
  #heading(outlined: false)[
    Formal Methods for Cyberphysical Systems \
    Assignment 2
  ]

  #v(1em)

  #text(size: 15pt, "Stevanato Giacomo")

  #text(size: 15pt, "20/01/2024")
]

=== Conventions

In this report the notation $pre{x}post$ will be used to mean the string resulting from the concatenation of the literal string $pre$, the value of the expression $x$ and the literal string $post$. For example if $x$ is $1$ then $pre{x+1}post$ will mean $pre 2 post$.

= Plant definition

== States

The two rovers are independent, so they can be represented with two different sets of plants. The yellow rover will be referred to as rover 1 and the blue rover as rover 2.

For each rover $i$ two plants have been defined: $Position{i}$ and $Battery{i}$, respectively tracking the rover's position and battery level.

=== Position

Each $Position{i}$ plant contains a state for every tile, representing the rover currently being on that tile. The states have been named $X{x}Y{y}$ where $x$ is the $X$ coordinate of the corresponding tile, ranging from 1 to 5, and $y$ is its $Y$ coordinate, ranging from 1 to 3, when viewed in a cartesian plane with the $X$ axis going right and the $Y$ axis going down.
$X1Y1$ is the initial state for rover 1 and $X4Y2$ is the initial state for rover 2. Only the initial states have been marked since those have been considered to be the "stable" states. Other possible choices considered were marking the states representing tiles with charging stations or all the states.

=== Battery

Each $Battery{i}$ plant contains a state for every battery level, representing the rover's battery currently being at that level. The states have been named $L{l}$ where $l$ is the current battery level and ranges from 0 to 6. $L6$ is the initial state since rovers start fully charged. Only $L6$ have been marked since that has been considered to be a "stable" state. Another possible choice considered was marking $L0$ too.

== Events

The following 9 events have been defined for each rover $i$:

- $left{i}$, $right{i}$, $down{i}$ and $up{i}$, the controllable events for the movements in the 4 directions of rover $i$;
- $uleft{i}, uright{i}, udown{i} "and" uup{i}$, the uncontrollable events for the movements in the 4 directions of rover $i$;
- $charge{i}$, the controllable event for charging.

The $charge{i}$ events have been defined as controllable since it is stated that:

#h(1em) _If a Rover sits on any of these tiles, then it *can* get a full charge_

Which has been interpreted to mean that a rover is not required to get the full charge and can choose not to.

== Edges

=== Position

Each $Position{i}$ plant contains an edge between two states if the corresponding tiles are adjacent. In particular they contain the following edges, excluding when the starting state is $X2Y2$:
- for all $2 <= x <= 5, 1 <= y <= 3$, an edge with event $left{i}$ from the state $X{x}Y{y}$ to the state $X{x-1}Y{y}$ of rover $i$;
- for all $1 <= x <= 4, 1 <= y <= 3$, an edge with event $right{i}$ from the state $X{x}Y{y}$ to the state $X{x+1}Y{y}$ of rover $i$;
- for all $1 <= x <= 5, 2 <= y <= 3$, an edge with event $up{i}$ from the state $X{x}Y{y}$ to the state $X{x}Y{y-1}$ of rover $i$;
- for all $1 <= x <= 5, 1 <= y <= 2$, an edge with event $down{i}$ from the state $X{x}Y{y}$ to the state $X{x}Y{y+1}$ of rover $i$.

The $X2Y2$ state represent the rover being on the red tile, where the movements are uncontrollable. Hence the following edges have been defined for that case:
- an edge with event $uleft{i}$ to the state $X1Y2$;
- an edge with event $uright{i}$ to the tile $X3Y2$;
- an edge with event $uup{i}$ to the state $X2Y1$;
- an edge with event $udown{i}$ to the state $X2Y3$.

These edges corresponds to the ones for the other states, except they use the corresponding uncontrollable events to make the movements uncontrollable by the rover.

Self-edges with event $charge{i}$ were also defined to model the charging of the rovers in the states $X1Y1$ and $X4Y2$, limiting the ability to charge the battery only on the corresponding tiles.

=== Battery

Each $Battery{i}$ plant contains an edge from every level to the previous one for every move, that is for every $1 <= l <= 6$ they contain an edge with events $left{i}$, $right{i}$, $up{i}$, $down{i}$, $uleft{i}$, $uright{i}$, $uup{i}$ and $udown{i}$ from the state $L{l}$ to the state $L{l-1}$, representing the decrease in battery level after a move. There's no such edge for the state $L0$, representing the fact that a rover can't move when its battery runs out of energy. They also contain edges for the charging, in particular for every $0 <= l <= 5$ they contain an edge with event $charge{i}$ from the state $L{l}$ to the state $L6$. It has been chosen not to add an edge with event $charge{i}$ in the state $L6$ because it doesn't make sense to charge the battery if it's already charged.

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

The requirement can be defined by copying the $Battery{i}$ plants and updating their marking so that the state $L0$ is not marked. This way any rover that runs out of energy on a non-charging station tile will be stuck on the state $L0$ due to not being able to move or charge, which is a blocking state and will thus be prevented from happening by the supervisor synthesis.

In the case of the chosen marking $L0$ is already not marked, so this requirement is redundant.

== Requirement 2

#requirement[ Both rovers must always alternate the use of the charging stations in $(1,1)$ and $(2,4)$ regardless of which is used first. ]

Let the station in position $(1,1)$ be station 1 and the one in position $(4,2)$ be station 2. The given requirement could be translated using the following automata, once for each rover, where $I$ represent the initial state when no charging station has been used by rover $i$, and $N1$ and $N2$ represent the states where the next charging station that has to be used is respectively station 1 and 2.

#figure(automata.r2-alternate, caption: "Automaton for alternating two events.")

There's however no way to directly express the "$charge{i}$ at station $j$" edges since it's not possible to distinguish at which station the $charge{i}$ event was performed. It's thus necessary to also track in which position the rover is currently at, which can be done by creating 3 copies of the $Position{i}$ plant states, one for every state in the automaton in the figure.

More formally, for every state $S$ in $Position{i}$ three states have been defined: ${S}I$, ${S}N1$ and ${S}N2$. Given $S_i$ the initial state in $Position{i}$, ${S_i}I$ will be the new initial state. All states will be marked, since marking is not relevant for this requirement. For every edge with event different than $charge{i}$ between states ${S 1}$ and ${S 2}$ it has been defined an edge between states ${S 1}{M}$ and ${S 2}{M}$ for all $M in {I, N1, N2}$. The edges with event $charge{i}$ have been replaced with the following ones:
- an edge with event $charge{i}$ from $X1Y1 I$ to $X1Y1 N2$, representing the topmost edge in the automata above;
- an edge with event $charge{i}$ from $X4Y2 I$ to $X4Y2 N1$, representing the bottommost edge in the automata above;
- an edge with event $charge{i}$ from $X1Y1 N1$ to $X1Y1 N2$, representing the center edge in the automata above;
- an edge with event $charge{i}$ from $X4Y2 N2$ to $X4Y2 N1$, representing the rightmost edge in the automata above.

This way the $charge{i}$ edges represent exactly all the edges in the automata shown in the figure before, while all the other edges correspond to the existing movement edges.

#for i in (1, 2) {
  figure(
    automata.r2(i),
    caption: [ Rover #i's automaton for requirement $R 2$ ]
  )
}

=== Compact version

The structure of the problem can be exploited to reduce the number of states that have to be manually declared. Since there are only 2 stations, they must differ in either their $X$ or $Y$ coordinate. The requirement automata can then only track that coordinate instead of both of them, and that will be enough to distinguish at which charging station the $charge{i}$ is being performed, since there exist at most one charging station for every value of that coordinate. In this case the charging stations positions differ by both coordinates, so the one with fewer states to track has been chosen, which is Y. The automata can hence be reduced to 9 states, $Y{y}{M}$ for all $1 <= y <= 3$ and $M in { I, N1, N2 }$, and the following edges:
- for $y in {2, 3}, M in {I, N1, N2}$ an edge with events $up{i}$ and $uup{i}$ from $Y{y}M$ to $Y{y-1}M$;
- for $y in {1, 2}, M in {I, N1, N2}$ an edge with events $down{i}$ and $udown{i}$ from $Y{y}M$ to $Y{y+1}M$;
- an edge with event $charge{i}$ from $Y 1 I$ to $Y 1 N2$;
- an edge with event $charge{i}$ from $Y 2 I$ to $Y 2 N1$;
- an edge with event $charge{i}$ from $Y 1 N1$ to $Y 1 N2$;
- an edge with event $charge{i}$ from $Y 2 N2$ to $Y 2 N1$.

#for i in (1, 2) {
  figure(
    automata.r2-compact(i),
    caption: [ Rover #i's compact automaton for requirement $R 2$ ]
  )
}

== Requirement 3

#requirement[ Rovers don't collide with each other (i.e., they are never simultaneously on a same tile). ]

The given requirement could be translated by computing the synchronous product of $Position 1$ and $Position 2$ and removing all the nodes where the state from $Position 1$ and the one from $Position 2$ have the same name, that is when Rover 1 is on the same tile as Rover 2. Unfortunately this doesn't scale well, requiring the user to specify 210 states ($15 times 15 = 225$ for the syncronous product, minus $15$ for the removed ones) which are arguably too many for a human to quickly verify their correctness.

Another, more compact, approach is to track the relative position of the two rovers. There are 9 possible relative positions $x_1 - x_2$ on the $X$ axis, ranging from $-4$ to $4$ and 5 possible relative positions $y_1 - y_2$ on the $Y$ axis, ranging from $-2$ to $2$. These will be the states of 2 automata, while their edges have been defined as the following:
- for all $-3 <= d x <= 4$, an edge with events $left 1$, $uleft 1$, $right 2$ and $uright 2$ from $d x$ to $d x - 1$;
- for all $-4 <= d x <= 3$, an edge with events $right 1$, $uright 1$, $left 2$ and $uleft 2$ from $d x$ to $d x + 1$;
- for all $-1 <= d y <= 2$, an edge with events $up 1$, $uup 1$, $down 2$ and $udown 2$ from $d y$ to $d y - 1$;
- for all $-1 <= d y <= 2$, an edge with events $down 1$, $udown 1$, $up 2$ and $uup 2$ from $d y$ to $d y + 1$.

The initial states are $-3$ and $-1$, because those are differences of the initial coordinates of the rovers. All states have been marked, since marking is irrelevant for this requirement. To satisfy the requirement it's then sufficient to compute the synchronous product of the two automata and remove the state $(0, 0)$, representing the two rovers having the same $X$ and $Y$ position, hence being on the same tile.
This ends up requiring the user to specify only 44 states ($9 times 5 = 45$ for the synchronous product, minus $1$ for the removed state).

Due to the inability to use the dash character (`-`) in CIF identifiers, the relative $X$ positions have been mapped to the names $L 4$, $L 3$, $L 2$, $L 1$, $S X$, $R 1$, $R 2$, $R 3$ and $R 4$, representing rover 1 being on the left ($L{l}$), on the same $X$ ($S X$) or on the right ($R{r}$) of rover 2, and the relative $Y$ positions have been mapped to the names $U 2$, $U 1$, $S Y$, $D 1$ and $D 2$, representing rover 1 being up ($U{u}$), on the same $Y$ ($S Y$) or down ($D{d}$) compared to rover 2.

#figure(automata.r3, caption: [ Automaton for requirement 3 ])

=== Compact version

If the introduction of a new uncontrollable event $sametile$ is allowed, an even more compact requirement automaton can be created. This event will never happen, in fact it will be used to have the supervisor remove any state that can perform this event, so it won't create any new execution of the system but only remove existing ones. The way this is done is by creating an automaton with two states, an initial marked state $Valid$ and another unmarked state $Invalid$, with a single edge with event $sametile$ from $Valid$ to $Invalid$. This way if the $sametile$ event ever happens it will lead to a blocking state and thus the supervisor will have to prevent it; moreover since it is uncontrollable the supervisor won't be able to remove the edge itself but will have to remove any state that can perform it or reach it with uncontrollable events.

Then the two automata for the relative $X$ and $Y$ positions can be kept separate, and only two self-loops with event $sametile$ have to be added to the states $S X$ and $S Y$. This way if the rovers are in the same position, that is the two automata are in the states $S X$ and $S Y$, they will be able to perform the event $sametile$ and reach a blocking state, hence the supervisor will be forced to remove this state.

#figure(automata.r3-compact, caption: [ Compact automata for requirement 3 ])
