#import "./deps.typ": cetz
#import "./cetz-utils.typ"

#let mixer(pos, ..args) = {
  import cetz.draw: *
  group(..args, {
    circle(pos, name: "c", radius: .5)
    line("c.north-west", "c.south-east")
    line("c.south-west", "c.north-east")
    anchor("lo", "c.south")
    anchor("west", "c.west")
    anchor("east", "c.east")
  })
}

#let _twoport(pos, inner: (pos) => {}, ..args) = {
  import cetz.draw: *
  group(..args, {
    rect((to: pos, update: false, rel: (-0.5, -0.5)), (to: pos, update: false, rel: (0.5, 0.5)))
    inner(pos)
  })
}

#let twoport(pos, inner: [], ..args) = {
  _twoport(pos, inner: (pos) => {
    import cetz.draw: *
    content(pos, inner)
  }, ..args)
}

#let sanalyzer = _twoport.with(inner: (pos) => {
  import cetz.draw: *
  grid(
    (rel: (-.4, -.4), to: pos, update: false),
    (rel: (.4, .4), to: pos, update: false),
    step: .1,
    stroke: gray,
  )
  rect(
    (rel: (-.4, -.4), to: pos, update: false),
    (rel: (.4, .4), to: pos, update: false),
  )
  line(
    (rel: (0.000 - 0.4,0.135 - 0.4), to: pos, update: false),
    (rel: (0.042 - 0.4,0.108 - 0.4), to: pos, update: false),
    (rel: (0.084 - 0.4,0.120 - 0.4), to: pos, update: false),
    (rel: (0.126 - 0.4,0.145 - 0.4), to: pos, update: false),
    (rel: (0.168 - 0.4,0.137 - 0.4), to: pos, update: false),
    (rel: (0.211 - 0.4,0.080 - 0.4), to: pos, update: false),
    (rel: (0.253 - 0.4,0.800 - 0.4), to: pos, update: false),
    (rel: (0.295 - 0.4,0.097 - 0.4), to: pos, update: false),
    (rel: (0.337 - 0.4,0.098 - 0.4), to: pos, update: false),
    (rel: (0.379 - 0.4,0.108 - 0.4), to: pos, update: false),
    (rel: (0.421 - 0.4,0.103 - 0.4), to: pos, update: false),
    (rel: (0.463 - 0.4,0.129 - 0.4), to: pos, update: false),
    (rel: (0.505 - 0.4,0.115 - 0.4), to: pos, update: false),
    (rel: (0.547 - 0.4,0.102 - 0.4), to: pos, update: false),
    (rel: (0.589 - 0.4,0.109 - 0.4), to: pos, update: false),
    (rel: (0.632 - 0.4,0.107 - 0.4), to: pos, update: false),
    (rel: (0.674 - 0.4,0.400 - 0.4), to: pos, update: false),
    (rel: (0.716 - 0.4,0.096 - 0.4), to: pos, update: false),
    (rel: (0.758 - 0.4,0.106 - 0.4), to: pos, update: false),
    (rel: (0.800 - 0.4,0.083 - 0.4), to: pos, update: false),
  )
})

#let make_bandfilter(strikes) = {
  _twoport.with(inner: (pos) => {
    import cetz.draw: *
    for (y, strike) in (-.2, 0, .2).zip(strikes) {
      hobby(
        (rel: (-.4, y - .05), to: pos, update: false),
        (rel: (-.18, y + .1), to: pos, update: false),
        (rel: (.18, y - .1), to: pos, update: false),
        (rel: (.4, y + .05), to: pos, update: false),
        omega: 0.5
      )
      if strike {
        line(
          (rel: (-.07, y -.09), to: pos, update: false),
          (rel: (.07, y + .09), to: pos, update: false),
        )
      }
    }
  })
}

#let highpass = make_bandfilter((true, false, false))
#let lowpass = make_bandfilter((false, false, true))
#let bandpass = make_bandfilter((true, false, true))
#let allpass = make_bandfilter((false, false, false))
#let bandstop = make_bandfilter((false, true, false))

#let input(pos, text, ..args) = {
  import cetz.draw: *
  group(..args, {
    line(
      (rel: (-.6, -.2), to: pos, update: false),
      (rel: (-.2, -.2), to: pos, update: false),
      pos,
      (rel: (-.2, .2), to: pos, update: false),
      (rel: (-.6, .2), to: pos, update: false),
      close: true,
    )
    content((rel: (-.7, 0), to: pos, update: false), text, anchor: "east")
    anchor("center", pos)
  })
}

#let multiplier(pos, factor, ..args) = {
  twoport(pos, inner: [$times factor$], ..args)
}

#let divider(pos, factor, ..args) = {
  twoport(pos, inner: [$div factor$], ..args)
}

#let phase-shifter = twoport.with(inner: [$phi$])

#let split-twoport(pos, inner1: [], inner2: [], ..args) = {
  import cetz.draw: *
  _twoport(pos, inner: (pos) => {
    line(
      (to: pos, update: false, rel: (-.5,-.5)),
      (to: pos, update: false, rel: (.5,.5)),
    )
    content((to: pos, update: false, rel: (-.25,.25)), inner1)
    content((to: pos, update: false, rel: (.25,-.25)), inner2)
  }, ..args)
}

#let ad-converter = split-twoport.with(inner1: [A], inner2: [D])
#let da-converter = split-twoport.with(inner1: [D], inner2: [A])

#let output(pos, text, ..args) = {
  import cetz.draw: *
  group(..args, {
    line(
      (rel: (.6, -.2), to: pos, update: false),
      (rel: (.2, -.2), to: pos, update: false),
      pos,
      (rel: (.2, .2), to: pos, update: false),
      (rel: (.6, .2), to: pos, update: false),
      close: true,
    )
    content((rel: (.7, 0), to: pos, update: false), text, anchor: "west")
    anchor("center", pos)
  })
}

#let source-harm(pos, ..args) = {
  import cetz.draw: *
  group(..args, {
    circle(pos, name: "c", radius: .5)
    hobby(
      (rel: (-.35, 0), to: pos, update: false),
      (rel: (-.14, .2), to: pos, update: false),
      (rel: (.14, -.2), to: pos, update: false),
      (rel: (.35, 0), to: pos, update: false),
      omega: 0
    )
    anchor("lo", "c.south")
    anchor("west", "c.west")
    anchor("east", "c.east")
  })
}

#let label(pos, anchor, text, dist: 0.1, ..args) = {
  import cetz.draw: content
  let anchor-angles = (
    east: 0deg,
    north-east: 45deg,
    north: 90deg,
    north-west: 135deg,
    west: 180deg,
    south-west: 225deg,
    south: 270deg,
    south-east: 315deg,
  )
  content((to: pos, update: false, rel: (anchor-angles.at(anchor) + 180deg, dist)), anchor: anchor, text, ..args)
}

#let _amp(pos, ..args) = {
  import cetz.draw: *
  group(..args, {
    line(
      (to: pos, update: false, rel: (-0.5, -0.5)),
      (to: pos, update: false, rel: (.5, 0)),
      (to: pos, update: false, rel: (-0.5, .5)),
      close: true,
    )
    if args.named().at("vga") {
      line(
        (to: pos, update: false, rel: (-0.2, -0.5)),
        (to: pos, update: false, rel: (.4, .5)),
        mark: (end: ">", fill: black),
      )
    }
    anchor("in", (to: pos, update: false, rel: (-0.5, 0)))
    anchor("out", (to: pos, update: false, rel: (0.5, 0)))
    anchor("center", pos)
  })
}

#let amp = _amp.with(vga: false)
#let vga = _amp.with(vga: true)

#let _splitter(pos) = {
  import cetz.draw: *
  rect(
    (to: pos, update: false, rel: (-0.5, -0.5)),
    (to: pos, update: false, rel: (0.5, 0.5))
  )
  line(
    (to: pos, update: false, rel: (-0.5, 0)),
    (to: pos, update: false, rel: (-0.2, 0)),
    (to: pos, update: false, rel: (0.2, 0.25)),
    (to: pos, update: false, rel: (0.5, 0.25)),
    name: "path1",
  )
  line(
    (to: pos, update: false, rel: (-0.2, 0)),
    (to: pos, update: false, rel: (0.2, -0.25)),
    (to: pos, update: false, rel: (0.5, -0.25)),
    name: "path2",
  )
}

#let splitter(pos, ..args) = {
  import cetz.draw: *
  group(..args, {
    _splitter(pos)
    anchor("in", "path1.start")
    anchor("out1", "path1.end")
    anchor("out2", "path2.end")
  })
}

#let _switch_spdt(pos) = {
  import cetz.draw: *
  rect(
    (to: pos, update: false, rel: (-0.5, -0.5)),
    (to: pos, update: false, rel: (0.5, 0.5))
  )
  line(
    (to: pos, update: false, rel: (-0.5, 0)),
    (to: pos, update: false, rel: (-0.2-.075, 0)),
    name: "path_comm",
  )
  circle((to: pos, update: false, rel: (-0.2, 0)), radius: .075, name: "com")
  circle((to: pos, update: false, rel: (0.2, .25)), radius: .075, name: "on")
  circle((to: pos, update: false, rel: (0.2, -.25)), radius: .075)
  line(
    (to: pos, update: false, rel: (0.2+.075, 0.25)),
    (to: pos, update: false, rel: (0.5, 0.25)),
    name: "path_on",
  )
  line(
    (to: pos, update: false, rel: (0.2+.075, -0.25)),
    (to: pos, update: false, rel: (0.5, -0.25)),
    name: "path_off",
  )
  line(
    (a: "com", number: .075, b:"on"),
    (a:"on", number: .075, b:"com"),
    name: "pathmid",
  )
}

#let switch_spdt(pos, ..args) = {
  import cetz.draw: *
  group(..args, {
    _switch_spdt(pos)
    anchor("comm", "path_comm.start")
    anchor("on", "path_on.end")
    anchor("off", "path_off.end")
  })
}

#let combiner(pos, ..args) = {
  import cetz.draw: *
  group(..args, {
    rotate(180deg, origin: pos)
    _splitter(pos)
    // use as combiner
    anchor("out", "path1.start")
    anchor("in2", "path1.end")
    anchor("in1", "path2.end")
  })
}
