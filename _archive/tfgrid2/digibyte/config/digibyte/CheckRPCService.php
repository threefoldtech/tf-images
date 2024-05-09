<?php
//$serviceRPC=trim(shell_exec('sudo checkdgb'));
if ( file_exists("/tmp/checkdgb") )
				{
$serviceRPC = new SplFileObject("/tmp/checkdgb");
 $serviceRPC= trim($serviceRPC->fgets());
				}
if($serviceRPC=="OK")
{
	
	echo ' <h4>RPC Service :<span class="green font-16"> Running - TCP port 14022<img class="icon-flatright" src="assets/images/icons/checkmark.svg" title="checkmark.svg" alt="colored-icons"></span></h4>';
	
}
else 
{
	
	echo ' <h4>RPC Service :<span class="text-danger font-16"> Checking </span></h4>';
	
}
?>
