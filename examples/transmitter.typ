// replace these with normal imports when using the lib
#import "../src/deps.typ": cetz
#import "../src/lib.typ" as cetz-rf

#cetz.canvas({
  import cetz.draw: *
  import cetz-rf: *
  input((), "I", name: "in_i")
  input(rel("in_i", 0,-1.5), "Q", name: "in_q")
  // I path
  conn("in_i", rel(.5,0))
  da-converter((), anchor: "west", name: "da_i")
  conn("da_i.east", rel(.5, 0))
  lowpass((), anchor: "west", name: "lp_i")
  conn("lp_i.east", rel(.5, 0))
  mixer((), name: "mix_i", anchor: "west")
  // Q path
  conn("in_q", rel(.5,0))
  da-converter((), anchor: "west", name: "da_q")
  conn("da_q.east", rel(.5, 0))
  lowpass((), anchor: "west", name: "lp_q")
  conn("lp_q.east", rel(1.5, 0))
  mixer((), name: "mix_q", anchor: "west")

  // LO_iq
  source-harm(rel("mix_i.lo", -1, -4), name: "lo-gen2")
  label("lo-gen2.south", "north", [$f_"LO,IQ"$], dist: .1)
  conn("lo-gen2.east", "-|", "mix_i.lo")
  conn("lo-gen2.east", ("lo-gen2.east", "-|", "mix_q.lo"), rel(0,.8))
  phase-shifter((), anchor: "south", name: "phase-shift")
  label("phase-shift.east", "west", $+90°$)
  conn("phase-shift.north", "mix_q.lo")

  // combiner
  combiner(rel("mix_i.east", -2, 0), name: "comb", anchor: "in1")
  conn("mix_i.east", "comb.in1")
  conn("mix_q.east", "-|-", "comb.in2")

  // output path
  conn("comb.east", rel(.5,0))
  amp((), anchor: "west", name: "if-amp")
  label("if-amp.south", "north", [IF-Amp.])
  conn("if-amp.east", rel(.5, 0))
  mixer((), anchor: "west", name: "mix_rf")
  conn("mix_rf.east", rel(.5,0))
  highpass((), anchor: "west", name: "hp_rf")
  conn("hp_rf.east", rel(.5,0))
  amp((), anchor: "west", name: "pa")
  label("pa.south", "north", [Power\ Amp.])
  conn("pa.east", rel(.5, 0))
  output((), "Tx")

  // LO RF
  source-harm(rel("mix_rf.lo", -1, -2), name: "lo-rf", anchor: "east")
  conn("lo-rf.east", "-|", "mix_rf.lo")
  label("lo-rf.south", "north", $f_"LO,RF"$)
}),
