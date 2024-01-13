#import "@preview/cetz:0.1.1"
#import "@preview/finite:0.3.0"
#import "defs.typ": *

#let position(i) = v(2em) + cetz.canvas({
  import finite.draw: *

  let (xmin, xmax, ymin, ymax) = (1, 5, 1, 3)
  let n(x, y) = "X" + str(x) + "Y" + str(y)
  let transition(s, e, l, curve: 0.2, anchor: top) = finite.draw.transition(
    s, e, label: text(size: 10pt, l), curve: curve, anchor: anchor)

  for x in range(xmin, xmax+1) {
    for y in range(ymin, ymax+1) {
      let initial = false
      if i == 1 and (x, y) == (1, 1) { initial = alignment.left }
      if i == 2 and (x, y) == (4, 2) { initial = top + alignment.left }
      state(
        (3.5 * x, -3.5 * y), n(x, y),
        label: box(width: 1.6em, align(center, n(x, y))),
        radius: 0.7, initial: initial, final: initial != false
      )
    }
  }

  transition(n(2, 2), n(1, 2), $uleft #i$)
  transition(n(2, 2), n(3, 2), $uright #i$)
  transition(n(2, 2), n(2, 1), $uup #i$)
  transition(n(2, 2), n(2, 3), $udown #i$)

  for x in range(xmin, xmax+1) {
    for y in range(ymin, ymax+1) {
      if (x, y) == (2, 2) { continue }
      if x != xmin { transition(n(x, y), n(x - 1, y), $left #i$) }
      if x != xmax { transition(n(x, y), n(x + 1, y), $right #i$) }
      if y != ymin { transition(n(x, y), n(x, y - 1), $up #i$) }
      if y != ymax { transition(n(x, y), n(x, y + 1), $down #i$) }
    }
  }

  transition(n(1, 1), n(1, 1), $charge #i$, curve: 0.5)
  finite.draw.loop(
    n(4, 2),
    label: (text: text(size: 10pt, $charge #i$), angle: 45deg),
    curve: 1,
    anchor: bottom + alignment.left)
})

#let battery(i) = v(2em) + cetz.canvas({
  import finite.draw: *

  for l in range(0, 6) {
    state((-2.8*l, 0), "L" + str(l))
  }
  state((-2.8 * 2.5, -3), "L6", initial: bottom, final: true)

  let label_text = text(size: 10pt)[
    $left #i$ \ $right #i$ \ $up #i$ \ $down #i$ \
    $uleft #i$ \ $uright #i$ \ $uup #i$ \ $udown #i$
  ]
  for l in range(1, 6) {
    transition(
      "L" + str(l), "L" + str(l - 1),
      label: (text: label_text, dist: 2), curve: 0.5,
    )
  }
  transition("L6", "L5", label: (text: label_text, angle: -66deg, dist: 0.6), curve: 1.05)

  transition("L5", "L6", label: text(size: 10pt, $charge #i$), curve: -0.3)
  transition("L4", "L6", label: text(size: 10pt, $charge #i$), curve: -0.1)
  transition("L3", "L6", label: text(size: 10pt, $charge #i$), curve: -0.1)
  transition("L2", "L6", label: text(size: 10pt, $charge #i$), curve: 0.1)
  transition("L1", "L6", label: text(size: 10pt, $charge #i$), curve: 0.5)
  transition("L0", "L6", label: text(size: 10pt, $charge #i$), curve: 1)
})

#let alternate = v(1em) + cetz.canvas({
  import finite.draw: *

  let state_style = (radius: 1, final: true)
  state((0, 0), "I", label: [ #h(8pt) $I$ #h(8pt) ], initial: "", ..state_style)
  state((4.5, 2), "N1", label: $N1$, ..state_style)
  state((4.5, -2), "N2", label: $N2$, ..state_style)

  let chargei(j) = align(center)[ $charge{i}$ \ at station #j #v(1.2em) ]
  transition("I", "N1", label: chargei(2), curve: 1.2)
  transition("I", "N2", label: v(5.6em) + chargei(1), curve: -1.2)
  transition("N1", "N2", label: chargei(1))
  transition("N2", "N1", label: chargei(2))
})

#let alternate-compact(i) = v(1em) + cetz.canvas({
  import finite.draw: *

  let mklabel(name) = box(width: 1.6em, align(center, name))

  for y in range(1, 3+1) {
    let name = "Y" + str(y) + "I"
    state((0, 6 - 3 * y), name, label: mklabel(name), initial: y == i, final: true)

    for (i, n) in ("N1", "N2").enumerate() {
      let name = "Y" + str(y) + n
      state((3 * y + 2, 4 * i - 2), name, label: mklabel(name), final: true)
    }
  }

  for n in ("I", "N1", "N2") {
    for y in (1, 2) {
      transition(
        "Y" + str(y + 1) + n, "Y" + str(y) + n, curve: 0.5,
        label: (text: [ $down #i$ \ $udown #i$ ], dist: 0.6)
      )
      transition(
        "Y" + str(y) + n, "Y" + str(y + 1) + n, curve: 0.5,
        label: (text: [ $up #i$ \ $uup #i$ ], dist: 0.6)
      )
    }
  }

  transition("Y1I", "Y1N2", label: $charge #i$)
  transition("Y2I", "Y2N1", label: $charge #i$ + h(4em), curve: 0)
  transition("Y1N1", "Y1N2", label: $charge #i$, curve: 0)
  transition("Y2N2", "Y2N1", label: $charge #i$, curve: 0)

  // let state_style = (radius: 1, final: true)
  // state((0, 0), "I", label: [ #h(8pt) $I$ #h(8pt) ], initial: "", ..state_style)
  // state((4.5, 2), "N1", label: $N1$, ..state_style)
  // state((4.5, -2), "N2", label: $N2$, ..state_style)

  // let chargei(j) = align(center)[ $charge{i}$ \ at station #j #v(1.2em) ]
  // transition("I", "N1", label: chargei(2), curve: 1.2)
  // transition("I", "N2", label: v(5.6em) + chargei(1), curve: -1.2)
  // transition("N1", "N2", label: chargei(1))
  // transition("N2", "N1", label: chargei(2))
})
