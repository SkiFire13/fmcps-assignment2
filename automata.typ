#import "@preview/cetz:0.1.1"
#import "@preview/finite:0.3.0"
#import "defs.typ": *

// TODO: Set to false
#let no-labels = true

#let position(i) = v(2em) + cetz.canvas({
  import finite.draw: *

  let (xmin, xmax, ymin, ymax) = (1, 5, 1, 3)
  let n(x, y) = "X" + str(x) + "Y" + str(y)
  let transition(s, e, l, curve: 0.2, anchor: top) = finite.draw.transition(
    s, e, label: text(size: 10pt, l), curve: curve, anchor: anchor)

  for x in range(xmin, xmax+1) {
    for y in range(ymin, ymax+1) {
      let initial = false
      if (i, x, y) == (1, 1, 1) { initial = (text: "", anchor: alignment.left) }
      if (i, x, y) == (2, 4, 2) { initial = (text: "", anchor: top + alignment.left) }
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

  loop(n(1, 1), label: $charge #i$, curve: 0.5)
  let label = (text: text(size: 10pt, $charge #i$), angle: 45deg)
  finite.draw.loop(n(4, 2), label: label, curve: 1, anchor: bottom + alignment.left)
})

#let battery(i) = v(2em) + cetz.canvas({
  import finite.draw: *

  state((-2.8 * 2.5, -3), "L6", initial: (text: "", anchor: bottom), final: true)
  for l in range(0, 6) {
    state((-2.8*l, 0), "L" + str(l))
  }

  let label_text = align(center, text(size: 10pt)[
    $left #i$ \ $right #i$ \ $up #i$ \ $down #i$ \
    $uleft #i$ \ $uright #i$ \ $uup #i$ \ $udown #i$
  ])

  for l in range(1, 6) {
    let label = (text: label_text, dist: 2)
    transition("L" + str(l), "L" + str(l - 1), label: label, curve: 0.5)
  }

  let label = (text: label_text, angle: -66deg, dist: 0.6)
  transition("L6", "L5", label: label, curve: 1.05)

  transition("L5", "L6", label: text(size: 10pt, $charge #i$), curve: -0.3)
  transition("L4", "L6", label: text(size: 10pt, $charge #i$), curve: -0.1)
  transition("L3", "L6", label: text(size: 10pt, $charge #i$), curve: -0.1)
  transition("L2", "L6", label: text(size: 10pt, $charge #i$), curve: 0.1)
  transition("L1", "L6", label: text(size: 10pt, $charge #i$), curve: 0.5)
  transition("L0", "L6", label: text(size: 10pt, $charge #i$), curve: 1)
})

#let r2-alternate = v(1em) + cetz.canvas({
  import finite.draw: *

  let mklabel(name) = box(width: 1.6em, align(center, text(size: 10pt, name)))

  let state_style = (radius: 0.7, final: true)
  state((0, 0), "I", label: mklabel($I$), initial: "", ..state_style)
  state((3, 1.5), "N1", label: mklabel($N1$), ..state_style)
  state((3, -1.5), "N2", label: mklabel($N2$), ..state_style)

  let chargei(j) = align(center, text(size: 9pt)[ $charge{i}$ \ at station #j ])
  transition("I", "N1", label: (text: chargei(2), dist: 0.5), curve: 0.85)
  transition("I", "N2", label: (text: chargei(1), dist: -0.5), curve: -0.85)
  transition("N1", "N2", label: (text: chargei(1), dist: 0.5, angle: 90deg))
  transition("N2", "N1", label: (text: chargei(2), dist: 0.5))
})

#let r2(i) = v(1em) + cetz.canvas({
  import finite.draw: *

  let scale = 1.7
  let (xmin, xmax, ymin, ymax) = (1, 5, 1, 3)
  let n(x, y, suf) = "X" + str(x) + "Y" + str(y) + suf
  let transition(s, e, l, curve: 0.2) = {
    let label = (text: text(size: 5pt, l), dist: 0.15)
    if no-labels { label = none }
    finite.draw.transition(s, e, curve: curve, label: label)
  }

  let pos(bx, by, suf) = {
    for x in range(xmin, xmax+1) {
      for y in range(ymin, ymax+1) {
        let initial = false
        if (suf, i, x, y) == ("I", 1, 1, 1) or (suf, i, x, y) == ("I", 2, 4, 2) {
          let anchor = if i == 1 { alignment.left } else { top + alignment.left }
          initial = (text: "", anchor: anchor)
        }
        state(
          (bx + scale * x, by + -scale * y), n(x, y, suf),
          label: box(width: 1em, align(center, text(size: 5.5pt, n(x, y, suf)))),
          radius: 0.5, initial: initial, final: true
        )
      }
    }

    transition(n(2, 2, suf), n(1, 2, suf), $uleft #i$)
    transition(n(2, 2, suf), n(3, 2, suf), $uright #i$)
    transition(n(2, 2, suf), n(2, 1, suf), $uup #i$)
    transition(n(2, 2, suf), n(2, 3, suf), $udown #i$)

    for x in range(xmin, xmax+1) {
      for y in range(ymin, ymax+1) {
        if (x, y) == (2, 2) { continue }
        if x != xmin { transition(n(x, y, suf), n(x - 1, y, suf), $left #i$) }
        if x != xmax { transition(n(x, y, suf), n(x + 1, y, suf), $right #i$) }
        if y != ymin { transition(n(x, y, suf), n(x, y - 1, suf), $up #i$) }
        if y != ymax { transition(n(x, y, suf), n(x, y + 1, suf), $down #i$) }
      }
    }
  }

  pos(0, scale*1.5, "I")
  pos(scale*5, 0, "N1")
  pos(scale*5, scale*3, "N2")

  transition(n(1, 1, "I"), n(1, 1, "N2"), $charge #i$, curve: 1)
  transition(n(4, 2, "I"), n(4, 2, "N1"), $charge #i$, curve: -0.3)
  transition(n(1, 1, "N1"), n(1, 1, "N2"), $charge #i$, curve: 0.6)
  transition(n(4, 2, "N2"), n(4, 2, "N1"), $charge #i$, curve: 0.6)
})

#let r2-alternate-compact(i) = v(1em) + cetz.canvas({
  import finite.draw: *

  let mklabel(name) = box(width: 1.6em, align(center, name))

  for y in range(1, 3+1) {
    let name = "Y" + str(y) + "I"
    let initial = if y == i { "" } else { false }
    state((0, -3 * y), name, label: mklabel(name), initial: initial, final: true)

    for (i, n) in ("N1", "N2").enumerate() {
      let name = "Y" + str(y) + n
      state((4 * (i + 1), -3 * y), name, label: mklabel(name), final: true)
    }
  }

  for n in ("I", "N1", "N2") {
    for y in (1, 2) {
      let label1 = (text: align(center)[ $up #i$ \ $uup #i$ ], dist: 0.6)
      let label2 = (text: align(center)[ $down #i$ \ $udown #i$ ], dist: 0.6)
      transition("Y" + str(y + 1) + n, "Y" + str(y) + n, curve: 0.5, label: label1)
      transition("Y" + str(y) + n, "Y" + str(y + 1) + n, curve: 0.5, label: label2)
    }
  }

  transition("Y1I", "Y1N2", label: $charge #i$, curve: 1)
  transition("Y2I", "Y2N1", label: $charge #i$, curve: 0.01)
  transition("Y1N1", "Y1N2", label: $charge #i$, curve: 0)
  transition("Y2N2", "Y2N1", label: $charge #i$, curve: 0)
})

#let r3 = cetz.canvas({
  import finite.draw: *

  let mklabel(name) = box(width: 1.6em, align(center, text(size: 9.5pt, name)))

  let xstates = ("L4", "L3", "L2", "L1", "SX", "R1", "R2", "R3", "R4")
  let ystates = ("U2", "U1", "SY", "D1", "D2")
  let label(l) = align(center, text(size: 2pt, l))
  let l1 = label[ $right 1$ \ $uright 1$ \ $left 2$ \ $uleft 2$ ]
  let l2 = label[ $left 1$ \ $uleft 1$ \ $right 2$ \ $uright 2$ ]
  let l3 = label[ $down 1$ \ $udown 1$ \ $up 2$ \ $uup 2$ ]
  let l4 = label[ $up 1$ \ $uup 1$ \ $down 2$ \ $udown 2$ ]
  if no-labels { (l1, l2, l3, l4) = ("", "", "", "") }

  for (x, xs) in xstates.enumerate() {
    for (y, ys) in ystates.enumerate() {
      if (xs, ys) == ("SX", "SY") { continue }
      let initial = (label: "", anchor: top + alignment.left)
      let initial = if (xs, ys) == ("L3", "U1") { initial } else { false }
      let style = (label: mklabel(var(xs + ys)), initial: initial, final: true)
      state((1.8 * x, -1.8 * y), xs + ys, ..style)
    }
  }

  for y in ystates {
    for (x1, x2) in xstates.zip(xstates.slice(1)) {
      if y == "SY" and (x1 == "SX" or x2 == "SX") { continue }
      transition(x1 + y, x2 + y, label: l1, curve: 0.1)
      transition(x2 + y, x1 + y, label: l2, curve: 0.1)
    }
  }
  for x in xstates {
    for (y1, y2) in ystates.zip(ystates.slice(1)) {
      if x == "SX" and (y1 == "SY" or y2 == "SY") { continue }
      transition(x + y1, x + y2, label: l3, curve: 0.1)
      transition(x + y2, x + y1, label: l2, curve: 0.1)
    }
  }
})

#let r3-sametile = cetz.canvas({
  import finite.draw: *

  let mklabel(name) = box(width: 1.6em, align(center, text(size: 11pt, name)))
  let valid_style = (initial: "", final: true)
  state((0, 0), "Valid", radius: 0.8, label: mklabel($Valid$), ..valid_style)
  state((4, 0), "Invalid", radius: 0.8, label: mklabel($Invalid$))
  transition("Valid", "Invalid", label: $sametile$, curve: 0.01)
})
#let r3-xy(states, si, sc, l1, l2) = cetz.canvas({
  import finite.draw: *

  for (i, s) in states.enumerate() {
    let initial = if s == si { (label: "", anchor: top) } else { false }
    state((1.8 * i, 0), s, label: var(s), initial: initial, final: true)
  }

  for (s1, s2) in states.zip(states.slice(1)) {
    transition(s1, s2, label: (text: align(center, text(size: 10pt, l1)), dist: 0.9))
    transition(s2, s1, label: (text: align(center, text(size: 10pt, l2)), dist: 0.9))
  }

  loop(sc, label: (text: text(size: 10pt, $sametile$), angle: 90deg, dist: 0.8))
})
#let r3-x = r3-xy(
  ("L4", "L3", "L2", "L1", "SX", "R1", "R2", "R3", "R4"), "L3", "SX",
  [ $right 1$ \ $uright 1$ \ $left 2$ \ $uleft 2$ ],
  [ $left 1$ \ $uleft 1$ \ $right 2$ \ $uright 2$ ],
)
#let r3-y = r3-xy(
  ("U2", "U1", "SY", "D1", "D2"), "U1", "SY",
  [ $down 1$ \ $udown 1$ \ $up 2$ \ $uup 2$ ],
  [ $up 1$ \ $uup 1$ \ $down 2$ \ $udown 2$ ],
)
#let r3-compact = v(1em) + r3-sametile + r3-x + r3-y
