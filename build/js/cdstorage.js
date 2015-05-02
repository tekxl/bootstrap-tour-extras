'use strict';
window.CDStorage = {
  setItem: function(name, value, erase) {
    var domain, domainParts, expires, host, valueString;
    if (erase == null) {
      erase = false;
    }
    domain = null;
    domainParts = null;
    expires = erase ? '; expires=Thu, 01 Jan 1970 00:00:01 GMT' : '';
    host = null;
    valueString = JSON.stringify(value);
    host = document.location.hostname;
    if (host.split('.').length === 1) {
      return document.cookie = "" + name + "=" + valueString + expires + "; path=/";
    } else {
      domainParts = host.split('.');
      domainParts.shift();
      domain = '.' + domainParts.join('.');
      document.cookie = "" + name + "=" + valueString + expires + "; path=/; domain=" + domain;
      if (this.getItem(name) === null || this.getItem(name) !== value) {
        domain = '.' + host;
        return document.cookie = "" + name + "=" + valueString + expires + "; path=/; domain=" + domain;
      }
    }
  },
  getItem: function(name) {
    var c, ca, nameEQ, value, _i, _len;
    nameEQ = "" + name + "=";
    ca = document.cookie.split(';');
    for (_i = 0, _len = ca.length; _i < _len; _i++) {
      c = ca[_i];
      while (c.charAt(0) === ' ') {
        c = c.substring(1, c.length);
      }
      if (c.indexOf(nameEQ) === 0) {
        value = c.substring(nameEQ.length, c.length);
      }
      if (value) {
        return JSON.parse(value);
      }
    }
    return null;
  },
  removeItem: function(name) {
    return this.setItem(name, '', true);
  }
};
