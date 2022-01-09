<?php
if ( file_exists("/tmp/checkuptime") )
				{
 $file = new SplFileObject("/tmp/checkuptime");
 $serviceUptime= $file->fgets();
				}
if(!empty($serviceUptime))
{
	
	echo number_format(($serviceUptime/60),0)." Minutes";
	
}
else 
{
	
	echo ' <span class="text-danger font-16"> Processing </span>';
	
}
?>
