<?php
/**
 * Configuración de WordPress
 *
 * Este archivo se utiliza para configurar la instalación de WordPress. Contiene información
 * como los detalles de acceso a la base de datos. No edites este archivo directamente,
 * en su lugar, utiliza el archivo wp-config.php que se genera a partir de este archivo.
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// Configuración de la base de datos
define( 'DB_NAME', "{{ db_name }}" );
define( 'DB_USER', "{{ db_user }}" );
define( 'DB_PASSWORD', "{{ db_password }}" );
define( 'DB_HOST', "{{ db_host }}" );
define( 'DB_CHARSET', 'utf8mb4' );
define( 'DB_COLLATE', '' );

// Claves únicas de autenticación y seguridad
define('AUTH_KEY',         'g#]h6P r}*if_=,``:d7}+f^rm<~V!_l-S? n5q.5m|T_L`>?c[4O(9{M,]I>i~]');
define('SECURE_AUTH_KEY',  'H&2`x|$&>3`3UCmLmBcggnhX*jjvF2D4(u.fa?0}=+%J}C6n3A-qZbc~,w4R`7q9');
define('LOGGED_IN_KEY',    'skYrFy^NCosz] Vg,94$S||7nWkBj`Q4$rU`0pKjG|wnxg|bQt;5+SHc{m~q!|V|');
define('NONCE_KEY',        '(7C|z}+`B|H~AO;YY_KZ<k}:1Hh0pQ#X_@FmclhD;UB7=x!wS,9-OxQzf(wOU j+');
define('AUTH_SALT',        'zpw`%XW@z~?T+f*%PG&s .&M!H>NU-q%3Jjh,xi!1|zsxE5_^!)a9lwynoS2H5Ag');
define('SECURE_AUTH_SALT', '<4elC;j`UkPG~x!x`QjQ5_b:?iTyqDmG >#:uEdr+DFL7guyUG9X=D$!}:WP@gMf');
define('LOGGED_IN_SALT',   'Z{uS$Tb@)4[;Vrb<} x 5-D;?U+mgwWz<IntGm_o_bX}I4-l7uP)ys|%6&id-m`+');
define('NONCE_SALT',       'TO{!>:L?^j|+age{$fnY[~[|dhKNz`8.@$EI4/~DQ|4V&ws5D1[U,N<6FNkstY`:');

// Prefijo de la tabla de la base de datos para WordPress
$table_prefix = 'wp_';

// Debugging
define( 'WP_DEBUG', false);

// Ajustes de WordPress
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', dirname( __DIR__ ) . '/' );
}
require_once ABSPATH . 'wp-settings.php';
