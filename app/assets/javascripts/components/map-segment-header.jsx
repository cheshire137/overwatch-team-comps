class MapSegmentHeader extends React.Component {
  className() {
    const { mapSegment, index } = this.props
    const columnClass = index % 2 === 0 ? 'even-column' : 'odd-column'
    const classes = [columnClass]

    if (mapSegment.toLowerCase().indexOf('attack') > -1) {
      classes.push('text-attack')
    } else {
      classes.push('text-defend')
    }

    return classes.join(' ')
  }

  render() {
    return <th className={this.className()}>{this.props.mapSegment}</th>
  }
}

MapSegmentHeader.propTypes = {
  mapSegment: React.PropTypes.string.isRequired,
  index: React.PropTypes.number.isRequired
}

export default MapSegmentHeader
