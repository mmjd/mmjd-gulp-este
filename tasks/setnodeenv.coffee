module.exports = ->
  process.env['NODE_ENV'] = if @production
    'production'
  else
    'development'