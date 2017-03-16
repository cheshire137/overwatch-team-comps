class HeroPoolForm extends React.Component {
  render() {
    return (
      <form className="container">
        <p>Hero pool form here</p>
      </form>
    )
  }
}

HeroPoolForm.propTypes = {
  battletag: React.PropTypes.string.isRequired
}

export default HeroPoolForm
