<?php
/**
 * Основные параметры WordPress.
 *
 * Скрипт для создания wp-config.php использует этот файл в процессе
 * установки. Необязательно использовать веб-интерфейс, можно
 * скопировать файл в "wp-config.php" и заполнить значения вручную.
 *
 * Этот файл содержит следующие параметры:
 *
 * * Настройки MySQL
 * * Секретные ключи
 * * Префикс таблиц базы данных
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** Параметры MySQL: Эту информацию можно получить у вашего хостинг-провайдера ** //
/** Имя базы данных для WordPress */
define('DB_NAME', 'u0530570_default');

/** Имя пользователя MySQL */
define('DB_USER', 'u0530570_111');

/** Пароль к базе данных MySQL */
define('DB_PASSWORD', '=~3D^68wQ{$o');

/** Имя сервера MySQL */
define('DB_HOST', 'localhost');

/** Кодировка базы данных для создания таблиц. */
define('DB_CHARSET', 'utf8mb4');

/** Схема сопоставления. Не меняйте, если не уверены. */
define('DB_COLLATE', '');

/**#@+
 * Уникальные ключи и соли для аутентификации.
 *
 * Смените значение каждой константы на уникальную фразу.
 * Можно сгенерировать их с помощью {@link https://api.wordpress.org/secret-key/1.1/salt/ сервиса ключей на WordPress.org}
 * Можно изменить их, чтобы сделать существующие файлы cookies недействительными. Пользователям потребуется авторизоваться снова.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         't~fOdB`C*92Q^H3L}`l>X,p3Z:fF7!,?C$X,a06um]FB90GlON/.kL|:iDOG1 ++');
define('SECURE_AUTH_KEY',  ' `MZ#e;jsrxjh.5K^XT[Ys!Lf{0s,g/Y:[3zi=02ER%*(C]7HOpn4tKhKJ(Qz.m ');
define('LOGGED_IN_KEY',    'rXb@Z:T*z)IYEj>F!~NpeF#q6:-np*15SIdA}#q:s#>W!>u9#,26Gy&_W2+]EO1u');
define('NONCE_KEY',        '/AbhCsyz]{Os^/hY29DzkYE/EGl2V JFK_9aqSj|y? #~8<Iy2|Lqt_{YFM-9^rK');
define('AUTH_SALT',        'XKo%)dzKjy+28gi)Iyw;Q9d8E:5J:Utx-s-C]N{3v{)H>U@2MIDQ78`dB_)%oHr{');
define('SECURE_AUTH_SALT', 'q`gkOyIm2S`r1t?42,-|MNFqR4o#^EF`&G1gH~1:|1Mmo[YPc`?=M^c:+]1bcTiz');
define('LOGGED_IN_SALT',   'j4[5XWVkX?q-K|<&~{QM-i2^?{VD61:BYH>yUJXUfQ+#oD:&<?EZ?q6%5oQqc!l,');
define('NONCE_SALT',       'Y<X0NUSDd~USmZgxIqkE8BQ7R*`fCUx+P`Iib](}>~(gPQHx?/{Isqx7<dgE*>HN');

/**#@-*/

/**
 * Префикс таблиц в базе данных WordPress.
 *
 * Можно установить несколько сайтов в одну базу данных, если использовать
 * разные префиксы. Пожалуйста, указывайте только цифры, буквы и знак подчеркивания.
 */
$table_prefix  = 'wp_';

/**
 * Для разработчиков: Режим отладки WordPress.
 *
 * Измените это значение на true, чтобы включить отображение уведомлений при разработке.
 * Разработчикам плагинов и тем настоятельно рекомендуется использовать WP_DEBUG
 * в своём рабочем окружении.
 *
 * Информацию о других отладочных константах можно найти в Кодексе.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* Это всё, дальше не редактируем. Успехов! */

/** Абсолютный путь к директории WordPress. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Инициализирует переменные WordPress и подключает файлы. */
require_once(ABSPATH . 'wp-settings.php');
