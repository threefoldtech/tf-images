<?php
if(file_exists("/tmp/checkps") )
{
$PresearchService = new SplFileObject("/tmp/checkps");
$PresearchService= trim($PresearchService->fgets());
}
if($PresearchService=="OK")
{
 echo ' <h4>Presearch Service :<span class="green font-16"> Running <img class="icon-flatright" src="assets/images/icons/checkmark.svg" title="checkmark.svg" alt="colored-icons"></span></h4>';
}
else 
{
	echo ' <h4>Presearch Service :<span class="text-danger font-16"> Checking </span></h4>';
}
?>
