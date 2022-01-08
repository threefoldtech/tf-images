<?php
/**
 * This file provides to overwrite the default HumHub / Yii configuration by your local common (Console and Web) environments
 * @see http://www.yiiframework.com/doc-2.0/guide-concept-configurations.html
 * @see http://docs.humhub.org/admin-installation-configuration.html
 * @see http://docs.humhub.org/dev-environment.html
 */

use  yii\web\UrlNormalizer;
return [
    'components' => [
	'redis' => [
            'class' => 'yii\redis\Connection',
            'hostname' => 'localhost',
            'port' => 6379,
            'database' => 0,
        ],
        'authClientCollection' => [
            'clients' => [
	        '3bot' => [
                    'class' => 'humhub\modules\threebot_login\authclient\ThreebotAuth',
                    'clientId' => '3bot',
                    'keyPair' => getenv('THREEBOT_KEY_PAIR'),
                ],
            ],
    ],
    
    'urlManager' => [
             'showScriptName' => false,
             'enablePrettyUrl' => true,
	     'rules' => [
                '/user/registration' => '/user/auth/login'
             ],
	     'normalizer' => [
                  'class' => 'yii\web\UrlNormalizer',
                    // use temporary redirection instead of permanent for debugging
                   'action' => UrlNormalizer::ACTION_REDIRECT_PERMANENT,
              ]
         ],
   ],
 	'params' => [
             'hidePoweredBy' => true
    ]

];
