<?php
if(file_exists("/usr/bin/checkupg") )
{
echo exec("sudo /usr/bin/checkupg");
exit();
}
