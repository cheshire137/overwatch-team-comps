class HeroSelect extends React.Component {
  onChange(event) {
    this.props.onChange(event.target.value)
  }

  render() {
    return (
      <span className="select">
        <select
          onChange={e => this.onChange(e)}
        ><option>Select hero</option></select>
      </span>
    )
  }
}

HeroSelect.propTypes = {
  heroes: React.PropTypes.array.isRequired,
  onChange: React.PropTypes.func.isRequired
}

export default HeroSelect
