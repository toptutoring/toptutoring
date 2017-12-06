import React from 'react'

class Button extends React.Component {
  render() {
    return (
      <button>
        { this.props.buttonText }
      </button>
    )
  }
}

export default Button
