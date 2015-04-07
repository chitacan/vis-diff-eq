React = require 'react'
window.React = React

Chart = require './components/Chart.coffee'
Input = require './components/Input.coffee'

App = React.createClass
  updateFormula: (formula) ->
    @.state.formula = formula
    @.setState @.state

  getInitialState: () ->
    xMin   : -20
    xMax   : 20
    formula: 'x + 1'

  zoomIn: () ->
    extent = @.state.xMax - @.state.xMin
    @.state.xMin += extent / 5
    @.state.xMax -= extent / 5
    @.setState @.state

  zoomOut: () ->
    extent = @.state.xMax - @.state.xMin
    @.state.xMin -= extent / 5
    @.state.xMax += extent / 5
    @.setState @.state

  render: ->
    <div className="app">
      <Chart
        formula={@.state.formula}
        xMin={@.state.xMin}
        xMax={@.state.xMax} />
      <Input
        onZoomIn={@.zoomIn}
        onZoomOut={@.zoomOut}
        onUpdateFormula={@.updateFormula}
        formula={@.state.formula} />
    </div>

React.render <App />, document.getElementById 'content'
