util = require("util")
path = require("path")
yeoman = require("yeoman-generator")
yosay = require("yosay")

CostjabrifyGenerator = yeoman.generators.Base.extend
  initializing: ->
    @pkg = require("../package.json")

  prompting: ->
    done = @async()

    # Have Yeoman greet the user.
    @log yosay("Welcome to the supreme Costjabrify generator!")

    prompts = [
      type: "confirm"
      name: "someOption"
      message: "Are you ready?"
      default: true
    ]

    @prompt prompts, ((props) ->
      @someOption = props.someOption
      done()

    ).bind(this)

  writing:
    app: ->
      @dest.mkdir "app"
      @dest.mkdir "app/views"
      @dest.mkdir "app/images"
      @dest.mkdir "app/scripts"
      @dest.mkdir "app/styles"
      @src.copy "logo.svg", "app/images/logo.svg"
      @src.copy "main.coffee", "app/scripts/main.coffee"
      @src.copy "main.styl", "app/styles/main.styl"
      @src.copy "index.jade", "app/views/index.jade"

    projectfiles: ->
      @src.copy "editorconfig", ".editorconfig"
      @src.copy "gitignore", ".gitignore"
      @src.copy "_package.json", "package.json"
      @src.copy "_bower.json", "bower.json"
      @src.copy "gulpfile.coffee", "gulpfile.coffee"
      @src.copy "server.coffee", "server.coffee"

  end: ->
    @installDependencies()

module.exports = CostjabrifyGenerator
