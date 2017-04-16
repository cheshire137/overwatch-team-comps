import PropTypes from 'prop-types'

class AllowDuplicatesCheckbox extends React.Component {
  onChange(event) {
    this.props.onChange(event.target.checked)
  }

  render() {
    return (
      <label
        htmlFor="allow-duplicates"
        className="checkbox allow-duplicates-label"
      >
        <input
          type="checkbox"
          id="allow-duplicates"
          onChange={e => this.onChange(e)}
          checked={this.props.checked}
        />
        Allow duplicate picks
      </label>
    )
  }
}

AllowDuplicatesCheckbox.propTypes = {
  onChange: PropTypes.func.isRequired,
  checked: PropTypes.bool.isRequired
}

export default AllowDuplicatesCheckbox
