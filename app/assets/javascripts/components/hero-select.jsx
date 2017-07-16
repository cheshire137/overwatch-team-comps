import PropTypes from 'prop-types'

import SelectMenu from './select-menu.jsx'

class HeroSelect extends React.Component {
  containerClass() {
    const classes = ['hero-select-container']
    if (typeof this.props.selectedHeroID !== 'number') {
      classes.push('not-filled')
    }
    if (this.props.isDuplicate) {
      classes.push('is-duplicate')
    }
    return classes.join(' ')
  }

  render() {
    const { heroes, selectedHeroID, disabled, onChange } = this.props
    const isFilled = typeof selectedHeroID === 'number'
    let selectedHeroName = 'Hero'
    let heroPortrait = <span className="hero-portrait-placeholder" />
    if (isFilled) {
      const selectedHero = heroes.filter(h => h.id === selectedHeroID)[0]
      selectedHeroName = selectedHero.name
      heroPortrait = (
        <img
          src={selectedHero.image}
          alt={selectedHeroName}
          className="hero-portrait"
        />
      )
    }

    return (
      <SelectMenu
        items={heroes}
        disabled={disabled}
        selectedItemID={selectedHeroID}
        onChange={val => onChange(val)}
        containerClass={() => this.containerClass()}
        menuToggleContents={() => <span>{heroPortrait} {selectedHeroName}</span>}
        menuItemClass={hero => `hero-${hero.slug}`}
        menuItemContent={(hero, isSelected) => (
          <span className={isSelected ? 'with-selected' : ''}>
            <img
              src={hero.image}
              alt={hero.name}
              className="hero-portrait"
            />
            <span className="css-truncate">{hero.name}</span>
          </span>
        )}
      />
    )
  }
}

HeroSelect.propTypes = {
  heroes: PropTypes.array.isRequired,
  onChange: PropTypes.func.isRequired,
  selectedHeroID: PropTypes.number,
  disabled: PropTypes.bool.isRequired,
  isDuplicate: PropTypes.bool
}

export default HeroSelect
