import ErrorStackParser from 'error-stack-parser'


export default processor = (e, cb) ->
  frames = ErrorStackParser.parse(e)

  backtrace = []
  for frame in frames
    backtrace.push({
      function: frame.functionName or '',
      file: frame.fileName,
      line: frame.lineNumber,
      column: frame.columnNumber,
    })

  if e.message?
    msg = String(e.message)
  else
    msg = String(e)

  if e.name? and e.name != ''
    type = e.name
  else
    type = ''

  if type == '' and msg == '' and backtrace.length == 0
    console?.warn?("airbrake: can't process error", e)
    return

  cb('stacktracejs', {
    type: type,
    message: msg,
    backtrace: backtrace,
  })
