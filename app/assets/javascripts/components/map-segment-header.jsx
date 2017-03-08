class MapSegmentHeader extends React.Component {
  className() {
    if (this.props.mapSegment.toLowerCase().indexOf('attack') > -1) {
      return 'text-attack'
    }

    return 'text-defend'
  }

  render() {
    return <th className={this.className()}>{this.props.mapSegment}</th>
  }
}

MapSegmentHeader.propTypes = {
  mapSegment: React.PropTypes.string.isRequired
}

export default MapSegmentHeader
