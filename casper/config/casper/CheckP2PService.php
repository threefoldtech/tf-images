<?php
if ( file_exists("/tmp/checkp2p") )
				{
$serviceP2P = new SplFileObject("/tmp/checkp2p");
 $chekserviceP2P= trim($serviceP2P->fgets());
				}
if ($chekserviceP2P=="OK")
{
	
	echo ' <h4>P2P  Service : <span class="green font-16"> Running - TCP port 35000<img class="icon-flatright" src="assets/images/icons/checkmark.svg" title="checkmark.svg" alt="colored-icons"></span></h4>';
}
else 
{
	
	echo ' <h4>P2P  Service : <span class="text-danger font-16"> Checking </span></h4>';
}
?>
