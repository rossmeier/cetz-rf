#import "./cetz-utils.typ"
#import "./components.typ": *

// re-export
#import cetz-utils: rel

#let conn(..args) = {
  import cetz.draw: *
  get-ctx(ctx => {
    let points = cetz-utils.calc-midpoints(ctx, ..args.pos())
    line(..points, ..args.named(), mark: (end: ">", fill: black))
  })
}
