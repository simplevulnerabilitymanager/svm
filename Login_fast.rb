#!/usr/bin/env ruby
response = http.post( 'http://testphp.acunetix.com/userinfo.php',
    parameters:     {
        'FormNameHTMLUsername'   => 'Administrador',
        'FormNameHTMLPassword' => 'Password123'
    },
    mode:           :sync,
    update_cookies: true
)
framework.options.session.check_url     = to_absolute( response.headers.location, response.url )
framework.options.session.check_pattern = /Logout|Sign out|Cerrar Sesion/
