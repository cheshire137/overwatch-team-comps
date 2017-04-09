import PropTypes from 'prop-types'

class MapSegmentHeader extends React.Component {
  className() {
    const { index, isAttack } = this.props
    const columnClass = index % 2 === 0 ? 'even-column' : 'odd-column'
    const classes = [columnClass, 'small-fat-header']

    if (isAttack) {
      classes.push('text-attack')
    } else {
      classes.push('text-defend')
    }

    return classes.join(' ')
  }

  filledStatusBar() {
    const { filled, isFirstOfKind, isAttack, isLastOfKind } = this.props
    const classes = ['map-segment-filled-status']
    if (isFirstOfKind) {
      classes.push('is-first')
    }
    if (isLastOfKind) {
      classes.push('is-last')
    }
    if (filled) {
      classes.push('is-filled')
    } else {
      classes.push('is-not-filled')
    }
    if (isAttack) {
      classes.push('attacking')
    } else {
      classes.push('defending')
    }
    return <div className={classes.join(' ')} />
  }

  render() {
    return (
      <th className={this.className()}>
        {this.props.name}
        {this.filledStatusBar()}
      </th>
    )
  }
}

MapSegmentHeader.propTypes = {
  name: PropTypes.string.isRequired,
  filled: PropTypes.bool.isRequired,
  isAttack: PropTypes.bool.isRequired,
  isFirstOfKind: PropTypes.bool.isRequired,
  isLastOfKind: PropTypes.bool.isRequired,
  index: PropTypes.number.isRequired
}

export default MapSegmentHeader
