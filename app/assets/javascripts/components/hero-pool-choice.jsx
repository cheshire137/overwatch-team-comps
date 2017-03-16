class HeroPoolChoice extends React.Component {
  render() {
    const { hero } = this.props

    return (
      <div key={hero.id}>
        {hero.name}
      </div>
    )
  }
}

HeroPoolChoice.propTypes = {
  hero: React.PropTypes.object.isRequired
}

export default HeroPoolChoice
