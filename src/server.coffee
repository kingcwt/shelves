
_ = require 'lodash'
debuglog = require('debug')("xy:website")

p = require "commander"
fs = require 'fs'
Url = require 'url'
path = require 'path'
express = require('express')




pkg = require "../package.json"
p.version(pkg.version)
  .option('-e, --environment [type]', 'runtime environment of [development, production, testing]', 'development')
  .option('-p, --port [value]')
  .option('-l, --language [value]')
  .parse(process.argv)

rootPath = path.resolve(__dirname, "../")

env = p.environment
debuglog "env:#{env}"
#process.env.NODE_ENV = env

HTTP_PORT = parseInt(p.port) || 6638



startWebServer = ->
#console.dir I18N_ENTRIES
  debuglog "[startWebServer]"

  ######################################
  # create web server instance
  ######################################
  app = express()
  app.use(express.static(path.join(rootPath, "/public"), {maxAge:864000000}))
  #app.use(createLocaleMiddleware())
  app.disable('x-powered-by')
  app.set 'views', path.join(rootPath, '/views')
  app.set 'view engine', 'pug'
  app.set 'view options', {pretty:false}

  app.locals._ = require 'lodash'
  app.locals.VERSION =  pkg.version
  app.locals.REVISION =  pkg.revision
  app.locals.ENV = env

  TIMESTAMP = Date.now().toString(32)
  app.locals.TIMESTAMP = TIMESTAMP


  app.get '/', (req, res)-> res.render "index.pug"


  ######################################
  # start web server
  ######################################
  app.listen(HTTP_PORT)
  console.log "**************************************************************************"
  console.log "***      #{pkg.name} VER:#{pkg.version} REV:#{pkg.revision} PORT:#{HTTP_PORT} ENV:#{env}       ***"
  console.log "**************************************************************************"

  return


startWebServer()


