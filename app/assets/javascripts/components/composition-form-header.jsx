import PropTypes from 'prop-types'

import OverwatchTeamCompsApi from '../models/overwatch-team-comps-api'

import MapSelect from './map-select.jsx'

class CompositionHeader extends React.Component {
  static onMapsError(error) {
    console.error('failed to load maps', error)
  }

  constructor(props) {
    super(props)
    this.state = {
      compositionName: props.compositionName,
      editingName: false,
      creatingNewComposition: false
    }
  }

  componentDidMount() {
    this.loadMaps()
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      compositionName: nextProps.compositionName,
      editingName: false,
      creatingNewComposition: false
    }, () => {
      const currentMap = (this.state.maps || []).filter(map => map.id === nextProps.mapID)[0]
      if (currentMap) {
        const knownSlugs = currentMap.compositions.map(comp => comp.slug)
        if (knownSlugs.indexOf(nextProps.compositionSlug) < 0) {
          this.loadMaps()
        }
      }
    })
  }

  onCompositionNameChange(event) {
    this.setState({ compositionName: event.target.value })
  }

  onCompositionNameKeyDown(event) {
    if (event.keyCode === 27) { // Esc
      event.target.blur() // defocus input field
      this.setState({ editingName: false })
    } else if (event.keyCode === 13) { // Enter
      this.saveCompositionName(event)
    }
  }

  onCompositionSelected(event) {
    const value = event.target.value

    if (value === 'new') {
      this.setState({
        compositionName: '',
        editingName: true,
        creatingNewComposition: true
      })
    } else {
      this.setState({ creatingNewComposition: false })
      this.props.onCompositionLoad(value)
    }
  }

  onMapsFetched(maps) {
    this.setState({ maps })
  }

  getCompositionsForSelectedMap() {
    const { mapID } = this.props
    const { maps } = this.state

    for (let i = 0; i < maps.length; i++) {
      const map = maps[i]

      if (map.id === mapID) {
        return map.compositions
      }
    }

    return []
  }

  loadMaps() {
    const api = new OverwatchTeamCompsApi()

    api.getMaps().
      then(maps => this.onMapsFetched(maps)).
      catch(err => CompositionHeader.onMapsError(err))
  }

  compositionSelect() {
    const { disabled, compositionSlug } = this.props
    const compositions = this.getCompositionsForSelectedMap()

    return (
      <span className="select composition-select">
        <select
          disabled={disabled}
          value={compositionSlug || ''}
          onChange={e => this.onCompositionSelected(e)}
        >
          {compositions.map(composition => (
            <option
              key={composition.id}
              value={composition.slug}
            >{composition.name}</option>
          ))}
          <option value="new">New composition</option>
        </select>
      </span>
    )
  }

  compositionNameEditor() {
    const { compositionName } = this.state
    const { disabled } = this.props

    return (
      <div className="composition-name-container editing">
        <input
          type="text"
          className="input composition-name-input"
          placeholder="Composition name"
          id="composition_name"
          value={compositionName || ''}
          disabled={disabled}
          autoFocus
          onKeyDown={e => this.onCompositionNameKeyDown(e)}
          onChange={e => this.onCompositionNameChange(e)}
          onFocus={() => this.setState({ editingName: true })}
          aria-label="Name of this team composition"
        />
        <button
          disabled={disabled}
          type="button"
          className="button save-composition-name-button"
          onClick={e => this.saveCompositionName(e)}
        ><i className="fa fa-check" aria-hidden="true" /></button>
      </div>
    )
  }

  saveCompositionName(event) {
    event.preventDefault()

    const button = event.target.closest('button')
    if (button) { // maybe user hit Enter to save, didn't click button
      button.blur() // defocus the button
    }

    const { compositionName, creatingNewComposition } = this.state
    if (compositionName.trim().length < 1) {
      return
    }

    this.props.onCompositionNameChange(compositionName, creatingNewComposition)
  }

  shareLink() {
    const { compositionSlug } = this.props
    if (typeof compositionSlug !== 'string' || compositionSlug.length < 1) {
      return null
    }

    return (
      <div className="composition-link-container">
        <a
          href={`/comp/${compositionSlug}`}
          className="composition-link"
        >
          <i
            className="fa fa-link"
            aria-hidden="true"
          />
          Share this composition
        </a>
      </div>
    )
  }

  mapPhotoContainer() {
    const { mapSlug, mapImage } = this.props

    return (
      <div className={`map-photo-container background-${mapSlug}`}>
        {mapImage ? (
          <img
            src={mapImage}
            alt={mapSlug}
            className="map-photo"
          />
        ) : ''}
      </div>
    )
  }

  toggleCompositionNameEditor(event) {
    event.currentTarget.blur() // defocus the button
    this.setState({ editingName: !this.state.editingName })
  }

  compositionSelectAndEdit() {
    const { editingName } = this.state
    return (
      <div className="composition-select-container">
        {editingName ? this.compositionNameEditor() : this.compositionSelect()}
        {editingName ? '' : (
          <button
            type="button"
            title="Edit team composition name"
            className="button-link edit-composition-name-button"
            onClick={e => this.toggleCompositionNameEditor(e)}
          ><i className="fa fa-pencil" aria-hidden="true" /></button>
        )}
      </div>
    )
  }

  render() {
    const { maps } = this.state
    if (typeof maps === 'undefined') {
      return null
    }

    const { mapSlug, mapID, disabled } = this.props
    return (
      <header className={`composition-header gradient-${mapSlug}`}>
        <div className="container">
          {this.mapPhotoContainer()}
          <div className="composition-meta">
            <MapSelect
              selectedMapID={mapID}
              maps={maps}
              disabled={disabled}
              onChange={id => this.props.onMapChange(id)}
            />
            {this.compositionSelectAndEdit()}
            {this.shareLink()}
          </div>
        </div>
      </header>
    )
  }
}

CompositionHeader.propTypes = {
  compositionName: PropTypes.string,
  compositionSlug: PropTypes.string,
  mapID: PropTypes.number.isRequired,
  mapSlug: PropTypes.string.isRequired,
  mapImage: PropTypes.string,
  onMapChange: PropTypes.func.isRequired,
  onCompositionNameChange: PropTypes.func.isRequired,
  onCompositionLoad: PropTypes.func.isRequired,
  disabled: PropTypes.bool.isRequired
}

export default CompositionHeader
