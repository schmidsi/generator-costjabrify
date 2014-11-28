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
            type: "input"
            name: "frontendDir"
            message: "Directory to hold the frontend code?
                Generator webapp uses 'app', we use 'fronted'"
            default: 'frontend'
        ]

        # @prompt prompts, (answers) =>
        #     @frontendDir = answers.frontendDir
        #     done()
        @frontendDir = 'frontend'
        done()


    writing:
        frontend: ->
            @dest.mkdir @frontendDir
            @dest.mkdir @frontendDir + "/templates"
            @dest.mkdir @frontendDir + "/images"
            @dest.mkdir @frontendDir + "/scripts"
            @dest.mkdir @frontendDir + "/styles"
            @src.copy "logo.svg", @frontendDir + "/images/logo.svg"
            @src.copy "main.coffee", @frontendDir + "/scripts/main.coffee"
            @src.copy "main.styl", @frontendDir + "/styles/main.styl"
            @src.copy "index.jade", @frontendDir + "/templates/index.jade"

        projectfiles: ->
            @src.copy "editorconfig", ".editorconfig"
            @src.copy "gitignore", ".gitignore"
            @src.copy "_package.json", "package.json"
            @src.copy "_bower.json", "bower.json"
            @src.copy "server.coffee", "server.coffee"

            # TODO: make templating work
            @src.copy "gulpfile.coffee", "gulpfile.coffee"
            #@template "gulpfile.coffee", "gulpfile.coffee"

    end: ->
        @installDependencies()

module.exports = CostjabrifyGenerator
