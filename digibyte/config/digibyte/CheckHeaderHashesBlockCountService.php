<?php
if ( file_exists("/tmp/checkblocks") )
				{
 $file_checkblocks = new SplFileObject("/tmp/checkblocks");
$checkblockes= trim($file_checkblocks->fgets());
				}
				if ( file_exists("/tmp/checkheaders") )
				{
					 $file_checkheaders = new SplFileObject("/tmp/checkheaders");
 $checkheaders= trim($file_checkheaders->fgets());
				}
				if ( file_exists("/tmp/checknethash") )
				{
					 $file_checknethash = new SplFileObject("/tmp/checknethash");
 $checknethash= trim($file_checknethash->fgets());
				}
				
 

 
 //echo "-->".number_format((($checkblockes / $checkheaders)*100),2);
if(!empty($checkblockes)){
	$Percentage = number_format((($checkblockes / $checkheaders)*100),2);
	$retrun_data= '<ul class="list-inline chart-detail-list"><p class="font-14"><b>Block Count : '.$checkblockes.'     -      Best Block Height : '.$checkheaders.'</b></p>
                                <p>Network hashes per second : '.number_format($checknethash,0).'</p></ul>';
}
else {
	$Percentage=0;
	$retrun_data ='<p class="font-14">Block Count : <span class="text-danger"> 0 </span>  -  Best Block Height : <span class="text-danger"> 0 <span></p>

                                <p>Network hashes per second : <span class="text-danger" > 0 </span></p>' ;
}
//$Percentage="98.00";
echo $Percentage."~".$retrun_data;
?>
