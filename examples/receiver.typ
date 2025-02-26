// replace these with normal imports when using the lib
#import "../src/deps.typ": cetz
#import "../src/lib.typ" as cetz-rf

#cetz.canvas({
  import cetz.draw: *
  import cetz-rf: *
  // common RF
  input((), "Rx")
  conn((), rel(.5,0))
  bandpass((), anchor: "west", name: "saw1")
  conn("saw1.east", rel(.5,0))
  amp((), anchor: "west", name: "LNA")
  label("LNA.south", "north", "LNA")
  conn("LNA.east", rel(.5,0))
  bandpass((), anchor: "west", name: "SAW")
  //rf.label("SAW.south", "north", "SAW")
  conn("SAW.east", rel(.5, 0))
  splitter((), anchor: "west", name: "splitter")

  // Q
  conn("splitter.out2", "-|-", rel(.5, -1), rel(1,0))
  mixer((), anchor: "west", name: "mix_q")
  conn("mix_q.east", rel(.5,0))
  lowpass((), anchor: "west", name: "lp_q")
  conn("lp_q.east", rel(.5,0))
  vga((), anchor: "west", name: "vga1_q")
  conn("vga1_q.east", rel(.5,0))
  vga((), anchor: "west", name: "vga2_q")
  conn("vga2_q.east", rel(.5,0))
  ad-converter((), anchor: "west", name: "adc_q")
  conn("adc_q.east", rel(.5,0))
  output((), "Q")

  // I
  conn("splitter.out1", rel(.5, 0))
  mixer((), anchor: "west", name: "mix_i")
  conn("mix_i.east", ("mix_i.east", "-|", "lp_q.west"))
  lowpass((), anchor: "west", name: "lp_i")
  conn("lp_i.east", rel(.5,0))
  vga((), anchor: "west", name: "vga1_i")
  conn("vga1_i.east", rel(.5,0))
  vga((), anchor: "west", name: "vga2_i")
  conn("vga2_i.east", rel(.5,0))
  ad-converter((), anchor: "west", name: "adc_i")
  conn("adc_i.east", rel(.5,0))
  output((), "I")

  // LO_iq
  source-harm(rel("mix_i.lo", -1, -4), name: "lo-gen2")
  label("lo-gen2.south", "north", [$f_"LO"$], dist: .1)
  conn("lo-gen2.east", "-|", "mix_i.lo")
  conn("lo-gen2.east", ("lo-gen2.east", "-|", "mix_q.lo"), rel(0,.8))
  phase-shifter((), anchor: "south", name: "phase-shift")
  label("phase-shift.east", "west", $+90°$)
  conn("phase-shift.north", "mix_q.lo")
}),
