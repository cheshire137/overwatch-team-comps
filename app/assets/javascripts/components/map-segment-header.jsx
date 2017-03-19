class MapSegmentHeader extends React.Component {
  className() {
    const { index, isAttack } = this.props
    const columnClass = index % 2 === 0 ? 'even-column' : 'odd-column'
    const classes = [columnClass]

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
  name: React.PropTypes.string.isRequired,
  filled: React.PropTypes.bool.isRequired,
  isAttack: React.PropTypes.bool.isRequired,
  isFirstOfKind: React.PropTypes.bool.isRequired,
  isLastOfKind: React.PropTypes.bool.isRequired,
  index: React.PropTypes.number.isRequired
}

export default MapSegmentHeader
