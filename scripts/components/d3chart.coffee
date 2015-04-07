d3 = require 'd3'

class d3chart
  constructor: ()->

  create: (el, props, state) ->
    margin = {top: 25, right: 40, bottom: 25, left: 40}
    @width  = props.width  - margin.left - margin.right
    @height = props.height - margin.top  - margin.bottom

    d3.select el
      .append 'svg'
      .attr 'class', 'd3'
      .attr 'width', props.width
      .attr 'height', props.height
      .append 'g'
      .attr 'transform', "translate(#{margin.left},#{margin.top})"

    @.update(el, state)

  update: (el, state) ->
    @.draw(el, state)

  destroy: () ->

  draw: (el, state) ->
    xMin = state.xMin
    xMax = state.xMax
    formula = state.formula
    points = 150

    # set formula
    eval("var xDot = function(x) { return #{formula} }")

    step = (xMax - xMin) / points
    d = d3.range(xMin, xMax + step, step)
      .map (x) ->
        x: x
        y: xDot(x)

    for i in [1..d.length - 1]
      d0 = d[i-1]
      d1 = d[i]

      if d0.y / Math.abs(d0.y) != d1.y / Math.abs(d1.y)
        if Math.abs(d0.y) <= Math.abs(d1.y)
          d0.y = 0
        else
          d1.y = 0

    yMax = d3.max d, (a) -> Math.abs a.y

    x = d3.scale.linear()
      .domain [xMin, xMax]
      .range  [0, @width]

    theta = d3.scale.linear()
      .domain [-yMax, yMax]
      .range  [-45, 45]

    xAxis = d3.svg.axis()
      .scale x
      .orient 'bottom'

    chart = d3.select 'g'

    lines = chart.selectAll 'line.phase'
      .data d

    # update lines
    lines.transition().duration(750)
      .attr 'transform', (d) =>
        "translate(#{ x(d.x) },#{@height})rotate(#{ theta(d.y) })"
      .attr 'stroke', (d) ->
        return switch
          when d.y < 0 then "#007979"
          when d.y > 0 then "#7EBD00"
          else "#CA0000"

    # add lines
    lines.enter()
      .append 'line'
      .classed 'phase', true
      .attr 'transform', (d) =>
        "translate(#{ x(d.x) },#{@height})rotate(#{ theta(d.y) })"
      .attr 'y2', -(@height)
      .attr 'stroke-width', '1.5px'
      .attr 'stroke-linecap', 'round'
      .attr 'stroke', (d) ->
        return switch
          when d.y < 0 then "#007979"
          when d.y > 0 then "#7EBD00"
          else "#CA0000"

    # remove lines
    lines.exit().remove()

    if chart.selectAll('.x.axis').size()
      chart.transition()
        .duration 750
        .select '.x.axis'
        .call xAxis
    else
      chart.append 'g'
        .attr 'class', 'x axis'
        .attr 'transform', "translate(0,#{@height + 5})"
        .call xAxis

    chart.selectAll(".axis line, .axis path")
      .attr("fill", "none")
      .attr("stroke", "#bbbbbb")
      .attr("stroke-width", "2px")
      .attr("shape-rendering", "crispEdges");

    chart.selectAll(".axis text")
      .attr("fill", "#444")
      .attr("font-size", "14");

    chart.selectAll(".axis .tick line")
      .attr("stroke", "#d0d0d0")
      .attr("stroke-width", "1");

module.exports = new d3chart()
