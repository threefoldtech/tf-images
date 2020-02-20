<?php return array (
  'components' => 
  array (
    'db' => 
    array (
      'class' => 'yii\\db\\Connection',
      'dsn' => 'mysql:host=localhost;dbname=humhub',
      'username' => getenv('DB_USER'),
      'password' => getenv('DB_PASS'),
    ),
    'formatter' => 
    array (
      'defaultTimeZone' => 'Europe/Brussels',
    ),
    'formatterApp' => 
    array (
      'defaultTimeZone' => 'Europe/Brussels',
      'timeZone' => 'Europe/Brussels',
    ),
    'cache' => 
    array (
      'class' => 'yii\\redis\\Cache',
      'keyPrefix' => 'humhub',
    ),
    'user' => 
    array (
    ),
    'mailer' => 
    array (
      'transport' => 
      array (
        'class' => 'Swift_SmtpTransport',
        'host' => getenv('SMTP_HOST'),
        'username' => getenv('SMTP_USER'),
        'password' => getenv('SMTP_PASS'),
        'port' => getenv('SMTP_PORT'),
      ),
    ),
  ),
  'params' => 
  array (
    'installer' => 
    array (
      'db' => 
      array (
        'installer_hostname' => 'localhost',
        'installer_database' => 'humhub',
      ),
    ),
    'config_created_at' => 1555318371,
    'horImageScrollOnMobile' => '1',
    'databaseInstalled' => true,
    'installed' => true,
  ),
  'name' => 'freeflowpages',
  'language' => 'en',
  'timeZone' => 'Europe/Brussels',
); ?>
