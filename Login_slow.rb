#!/usr/bin/env ruby
require 'watir-webdriver'
browser = Watir::Browser.new
browser.goto 'http://testphp.acunetix.com/login.php'
form = browser.form( id: 'loginform' )
form.text_field( name: 'uname' ).set 'test'
form.text_field( name: 'pass' ).set 'test'
form.submit
framework.options.session.check_url     = browser.url
framework.options.session.check_pattern = /Logout|Sign out|Cerrar Sesion/