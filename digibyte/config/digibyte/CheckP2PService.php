<?php
if ( file_exists("/tmp/checkdgb") )
				{
$serviceRPC = new SplFileObject("/tmp/checkdgb");
 $serviceP2P= trim($serviceRPC->fgets());
				}
if ($serviceP2P=="OK")
{
	
	echo ' <h4>P2P  Service : <span class="green font-16"> Running - TCP port 12024<img class="icon-flatright" src="assets/images/icons/checkmark.svg" title="checkmark.svg" alt="colored-icons"></span></h4>';
}
else 
{
	
	echo ' <h4>P2P  Service : <span class="text-danger font-16"> Checking </span></h4>';
}
?>
