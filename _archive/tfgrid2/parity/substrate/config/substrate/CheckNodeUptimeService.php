<?php
if ( file_exists("/tmp/checkuptime") )
					{
						 $file = new SplFileObject("/tmp/checkuptime");
						  $serviceUptime= $file->fgets();
						 				}
if(!empty($serviceUptime))
{
		
		echo '<span class="green font-16">'.$serviceUptime.' - HH:MM:SS</span>';	
}
else 
{
		
		echo ' <span class="text-danger font-16"> Processing </span>';
			
}
?>

