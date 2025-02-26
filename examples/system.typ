// replace these with normal imports when using the lib
#import "../src/deps.typ": cetz
#import "../src/lib.typ" as cetz-rf

#cetz.canvas({
  import cetz.draw: *
  import cetz-rf: *
  input((), "Antenna", name: "ant")
  conn("ant", rel(1,0))
  switch_spdt((), name: "switch", anchor: "west")
  conn("switch.on", "-|-", rel(2,0.5))
  output((), "Rx")
  output(rel("switch.off", 2, -.5), "Tx", name: "tx")
  conn("tx", "-|-", "switch.off")
}),
