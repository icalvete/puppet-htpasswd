define htpasswd::file($file)
{

  exec{"auth_file_${name}":
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    command => "touch ${file}",
    onlyif  => "test ! -f ${file}",
  }
}
