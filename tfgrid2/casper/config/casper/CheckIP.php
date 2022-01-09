<?php
if ( file_exists("/tmp/checkip") )
				{
 $file = new SplFileObject("/tmp/checkip");
 $nodeip= $file->fgets();
				}
if(!empty($nodeip))
{
	$nodeip = preg_replace('/\s+/', '', $nodeip);
	echo $nodeip;
	
}
?>
