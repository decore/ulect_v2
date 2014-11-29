define [], ->

  if typeof console?.log is 'function'
    (args...) -> console.log args...
  else () -> # no-op