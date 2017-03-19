const About = function() {
  return (
    <div className="container about-page">
      <h1>About</h1>
      <p>
        Thanks to Blizzard for Overwatch. <i
          className="fa fa-heart"
          aria-hidden="true"
        /> This app was built with <a
          href="https://facebook.github.io/react/"
          target="_blank"
          rel="noopener noreferrer"
        >React</a> and <a
          href="http://rubyonrails.org/"
          target="_blank"
          rel="noopener noreferrer"
        >Ruby on Rails</a>.
      </p>
    </div>
  )
}

export default About
