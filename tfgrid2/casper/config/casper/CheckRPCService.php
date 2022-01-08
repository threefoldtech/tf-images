<?php
if ( file_exists("/tmp/checkrpc") )
{
$checkserviceRPC = new SplFileObject("/tmp/checkrpc");
$serviceRPC= trim($checkserviceRPC->fgets());
				}
if($serviceRPC=="OK")
{
	
	echo ' <h4>RPC Service :<span class="green font-16"> Running - TCP port 7777<img class="icon-flatright" src="assets/images/icons/checkmark.svg" title="checkmark.svg" alt="colored-icons"></span></h4>';
	
}
else 
{
	
	echo ' <h4>RPC Service :<span class="text-danger font-16"> Checking | Waiting for Sync</span></h4>';
	
}
?>
