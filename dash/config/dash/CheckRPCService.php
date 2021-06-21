<?php
//$serviceRPC=trim(shell_exec('sudo checkdash'));
if ( file_exists("/tmp/checkdash") )
				{
$serviceRPC = new SplFileObject("/tmp/checkdash");
 $serviceRPC= trim($serviceRPC->fgets());
				}
if($serviceRPC=="OK")
{
	
	echo ' <h4>RPC Service :<span class="green font-16"> Running - TCP port 9998<img class="icon-flatright" src="assets/images/icons/checkmark.svg" title="checkmark.svg" alt="colored-icons"></span></h4>';
	
}
else 
{
	
	echo ' <h4>RPC Service :<span class="text-danger font-16"> Checking </span></h4>';
	
}
?>
