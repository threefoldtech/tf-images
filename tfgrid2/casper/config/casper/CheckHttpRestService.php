<?php
if ( file_exists("/tmp/checkrest") )
				{
$serviceHTTPRest = new SplFileObject("/tmp/checkrest");
 $serviceRest= trim($serviceHTTPRest->fgets());
				}
if ($serviceRest=="OK")
{
	
	echo ' <h4>HTTP REST Service : <span class="green font-16"> Running - TCP port 8888<img class="icon-flatright" src="assets/images/icons/checkmark.svg" title="checkmark.svg" alt="colored-icons"></span></h4>';
}
else 
{
	
	echo '<h4>HTTP REST Service : <span class="text-danger font-16"> Checking</span></h4>';
}
?>
