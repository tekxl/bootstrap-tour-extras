'use strict'

window.CDStorage =
  setItem: (name, value, erase = false) ->
    domain = null
    domainParts = null
    expires = if erase then "; expires=Thu, 01 Jan 1970 00:00:01 GMT" else ""
    host = null
    valueString = JSON.stringify value # transform data to string

    host = document.location.hostname
    if host.split('.').length is 1
      # no "." in a domain - it's localhost or something similar
      document.cookie = "#{name}=#{valueString}#{expires}; path=/"
    else
      # Remember the cookie on all subdomains.
      #
      # Start with trying to set cookie to the top domain.
      # (example: if user is on foo.com, try to set
      # cookie to domain ".com")
      #
      # If the cookie will not be set, it means ".com"
      # is a top level domain and we need to
      # set the cookie to ".foo.com"
      domainParts = host.split('.')
      domainParts.shift()
      domain = '.' + domainParts.join('.')

      document.cookie = "#{name}=#{valueString}#{expires}; path=/; domain=#{domain}"

      # check if cookie was successfuly set to the given domain
      # (otherwise it was a Top-Level Domain)
      savedValue = @getItem(name)
      if savedValue is null or not @_equal(savedValue, value)
        # append "." to current domain
        domain = '.' + host
        document.cookie = "#{name}=#{valueString}#{expires}; path=/; domain=#{domain}"

  getItem: (name) ->
    nameEQ = "#{name}="
    ca = document.cookie.split(';')

    for c in ca
      while c.charAt(0) is ' '
        c = c.substring(1, c.length)

      value = c.substring(nameEQ.length, c.length) if c.indexOf(nameEQ) is 0
      return JSON.parse(value) if value

    null

  removeItem: (name) ->
    @setItem name, '', true

  _equal: (v1, v2) ->
    if ({}).toString.call(v1) is '[object Object]' and ({}).toString.call(v2) is '[object Object]'
      for k in v1
        if v1[k] isnt v2[k]
          return false
      return true
    else
      return v1 is v2
