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

  _equal: (obj1, obj2) ->
    if ({}).toString.call(obj1) is '[object Object]' and ({}).toString.call(obj2) is '[object Object]'
      for k,v of obj1
        return false if obj2[k] isnt v
      for k,v of obj2
        return false if obj1[k] isnt v
      return true
    else
      return obj1 is obj2
