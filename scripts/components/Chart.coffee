React   = require 'react'
d3chart = require './d3chart.coffee'

Chart = React.createClass
  componentDidMount: ->
    el = @.getDOMNode()
    d3chart.create el,
      width: 780
      height: 90
    , @.getChartState()

  componentDidUpdate: ->
    el = @.getDOMNode()
    d3chart.update el, @.getChartState()

  getChartState: ->
    xMin: @.props.xMin
    xMax: @.props.xMax
    formula: @.props.formula

  render: ->
    <div className="chart"></div>

module.exports = Chart
