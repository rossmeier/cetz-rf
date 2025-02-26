#import "./deps.typ": cetz

#let calc-midpoints(ctx, ..args) = {
  let points = args.pos()
  if points.len() < 3 {
    return points
  }

  // before any processing, resolve all coordinates once
  // to keep all relative coordinates working nicely
  let raw_coords = points.enumerate().filter(((i, coord)) => {
    false == (coord in ("-|", "|-", "-|-", "|-|"))
  })
  let update_index = raw_coords.map(((i, coord)) => i)
  let raw_coords = raw_coords.map(((i, coord)) => coord)
  let (ctx, ..coords) = cetz.coordinate.resolve(ctx, ..raw_coords)
  for (i, coord) in update_index.zip(coords) {
    points.at(i) = coord
  }

  // assemble output set of (all absolute) coordinates
  let ret = (points.at(0),)
  let skip_next = false
  for (a, b, c) in points.zip(points.slice(1), points.slice(2)) {
    if skip_next {
      // we have already handled that combination previously
      skip_next = false
      continue
    }
    ret = ret + if type(b) == str {
      if b == "-|" {
        skip_next = true
        ((a, "-|", c), c)
      } else if b == "|-" {
        skip_next = true
        ((a, "|-", c), c)
      } else if b == "|-|" {
        skip_next = true
        ((a, "|-", (a, 50%, c)), ((a, 50%, c), "-|", c), c)
      } else if b == "-|-" {
        skip_next = true
        ((a, "-|", (a, 50%, c)), ((a, 50%, c), "|-", c), c)
      } else {
        // just assume it is a normal coordinate
        (b,)
      }
    } else {
      // nothing special, just append point
      (b,)
    }
  }
  if skip_next == false {
    // last 3 were all points, still need to append last
    ret = ret + (points.at(-1),)
  }
  ret
}

#let rel(..args) = {
  let arg = args.pos()
  if arg.len() == 2 {
    return (rel: arg)
  } else if arg.len() == 3 {
    return (to: arg.at(0), rel: arg.slice(1,3))
  }
}
