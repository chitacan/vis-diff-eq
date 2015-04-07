React = require 'react'

Input = React.createClass
  handleUpdate: (e) ->
    if e.keyCode is 13
      formula = this.refs.formula.getDOMNode().value.trim()
      this.props.onUpdateFormula(formula, 'hello')

  handleZoomIn: (e) ->
    this.props.onZoomIn()

  handleZoomOut: (e) ->
    this.props.onZoomOut()

  render: () ->
    <div className="input">
      <input
        type="text"
        placeholder="formula"
        ref="formula"
        onKeyDown={@.handleUpdate}
        defaultValue={@.props.formula} />
      <button onClick={@.handleZoomIn} >+</button>
      <button onClick={@.handleZoomOut}>-</button>
    </div>

module.exports = Input
