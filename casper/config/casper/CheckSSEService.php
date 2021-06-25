<?php
if ( file_exists("/tmp/checksse") )
				{
$serviceSSE = new SplFileObject("/tmp/checksse");
 $CHECKserviceSSE= trim($serviceSSE->fgets());
				}
if ($CHECKserviceSSE=="OK")
{
	
	echo ' <h4>HTTP SSE Service : <span class="green font-16"> Running - TCP port 9999<img class="icon-flatright" src="assets/images/icons/checkmark.svg" title="checkmark.svg" alt="colored-icons"></span></h4>';
}
else 
{
	
	echo '<h4>HTTP SSE Service: <span class="text-danger font-16"> Checking</span></h4>';
}
?>
