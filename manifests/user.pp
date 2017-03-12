define htpasswd::user (

  $user       = $name,
  $password   = undef,
  $file       = hiera('htpasswd_file', '/etc/apache2/htpasswd'),
  $ensure     = present,
  $encryption = md5

) {

  if ! $password {
    fail('htpasswd::user needs password parameter.')
  }

  include apache2::utils

  Exec {
    path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  htpasswd::file{$name:
    file => $file
  }

  case $encryption {
    md5:        { $enctype = '-m' }
    sha:        { $enctype = '-s' }
    crypt:      { $enctype = '-d' }
    plain:      { $enctype = '-p' }
    default:    { $enctype = '-m' }
  }

  case $ensure {
    absent:     { $cmd = "htpasswd -b -D $file ${user}" }
    present:    { $cmd = "htpasswd -b ${enctype} $file ${user} ${password}" }
    default:    { $cmd = "htpasswd -b ${enctype} $file ${user} ${password}" }
  }

  exec {"manage_user_${name}":
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    command => $cmd,
    require => Htpasswd::File[$name],
  }
}
