<?php
if(file_exists("/tmp/checkpsver") )
{
$CheckVersion = new SplFileObject("/tmp/checkpsver");
$CheckVersion= trim($CheckVersion->fgets());
}
if($CheckVersion!=''){
?>
<h4>Node Version :<span class="green font-16"> <?php echo $CheckVersion;?> <img class="icon-flatright" src="assets/images/icons/checkmark.svg" title="checkmark.svg" alt="colored-icons"></span></h4>	
<?php } else{ ?>
<h4>Version :<span class="text-danger font-16"> Checking </span></h4>

<?php } ?>
