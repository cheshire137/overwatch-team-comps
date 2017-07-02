import PropTypes from 'prop-types'
import DebounceInput from 'react-debounce-input'

class CompositionNotes extends React.Component {
  onCompositionNotesChange(event) {
    this.props.saveNotes(event.target.value)
  }

  render() {
    const { isRequestOut, notes } = this.props

    return (
      <div className="composition-notes-wrapper">
        <label
          htmlFor="composition_notes"
          className="label notes-label small-fat-header"
        >Notes</label>
        <DebounceInput
          element="textarea"
          forceNotifyByEnter={false}
          debounceTimeout={500}
          id="composition_notes"
          className="textarea"
          disabled={isRequestOut}
          placeholder="Notes for this team composition"
          value={notes || ''}
          onChange={e => this.onCompositionNotesChange(e)}
        />
        <p className="tip">
          <strong>Tip: </strong> include a YouTube video, Streamable video, Gfycat gif, or Twitch clip URL to embed it.
        </p>
        <p>
          <a
            href="https://daringfireball.net/projects/markdown/syntax"
            target="_blank"
            rel="noopener noreferrer"
          >Markdown supported</a>.
        </p>
      </div>
    )
  }
}

CompositionNotes.propTypes = {
  isRequestOut: PropTypes.bool,
  notes: PropTypes.string,
  saveNotes: PropTypes.func.isRequired
}

export default CompositionNotes
