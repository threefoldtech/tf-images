<?php
if(file_exists("/tmp/checkipaddr") )
{
$IPService = new SplFileObject("/tmp/checkipaddr"); 
$IPService= trim($IPService->fgets());
}
if($IPService!='')
{
?>
<h4>Node Public IP :<span class="green font-16"> <?php echo $IPService;?> <img class="icon-flatright" src="assets/images/icons/checkmark.svg" title="checkmark.svg" alt="colored-icons"></span></h4>	
<?php } else { ?>
<h4>Public IP :<span class="text-danger font-16"> Checking </span></h4>

<?php } ?>
