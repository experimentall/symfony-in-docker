<?php

error_reporting(E_ERROR | E_PARSE);

require_once 'plugins/login-password-less.php';

/* Set allowed password
 * @param string result of password_hash
 */
if (isset($_GET['sqlite'])) {
    return new AdminerLoginPasswordLess(
        $password_hash = password_hash('test', PASSWORD_DEFAULT)
    );
}
