import PropTypes from 'prop-types'
import Textarea from 'react-textarea-autosize'

class CompositionNotes extends React.Component {
  constructor(props) {
    super(props)
    this.state = { notes: props.notes }
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ notes: nextProps.notes })
  }

  onCompositionNotesChange(event) {
    this.setState({ notes: event.target.value })
  }

  saveNotes(event) {
    if (this.state.isRequestOut) {
      return
    }
    if (event) {
      event.target.blur()
    }
    this.props.saveNotes(this.state.notes)
  }

  render() {
    const { isRequestOut } = this.props
    const { notes } = this.state

    return (
      <div className="composition-notes-wrapper">
        <label
          htmlFor="composition_notes"
          className="label notes-label small-fat-header"
        >Notes</label>
        <Textarea
          id="composition_notes"
          className="textarea"
          disabled={isRequestOut}
          placeholder="Notes for this team composition"
          value={notes || ''}
          onChange={e => this.onCompositionNotesChange(e)}
          onBlur={() => this.saveNotes()}
        />
        <p>
          <button
            type="button"
            disabled={isRequestOut}
            className="button save-notes-button"
            onClick={e => this.saveNotes(e)}
          >
            {isRequestOut ? (
              <i className="fa fa-spinner fa-spin" />
            ) : ''}
            Save notes
          </button>
        </p>
        <p className="tip">
          <strong>Tip: </strong> include a YouTube video, Streamable video,
          Gfycat gif, or Twitch clip URL to embed it.
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
