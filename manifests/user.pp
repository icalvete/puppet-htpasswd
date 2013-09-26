define htpasswd::user($password, $file, $ensure = present, $encryption = md5)
{

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
    absent:     { $cmd = "htpasswd -b -D $file ${name}" }
    present:    { $cmd = "htpasswd -b ${enctype} $file ${name} ${password}" }
    default:    { $cmd = "htpasswd -b ${enctype} $file ${name} ${password}" }
  }

  exec {"manage_user_${name}":
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    command => $cmd,
    require => Htpasswd::File[$name],
  }
}
