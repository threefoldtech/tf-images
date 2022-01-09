<?php include("header.php");?>
      <!-- End Navigation Bar-->
      <div class="wrapper">
         <div class="container">
            <!-- Page-Title -->
            <div class="row">
               <div class="col-sm-12">
                  <div class="page-title-box">
                     <div class="btn-group pull-right">
                    
                     </div>
                     <h4 class="page-title ">
                        <img class="icon-colored ml-0" src="assets/images/pre-logo.png" title="presearch-pre-logo.svg" alt="colored-icons">
                        Presearch Node Status
                     </h4>
                     <p>Your Presearch node is now running succesfully on the ThreeFold Grid. You could also verify the status of the node by visiting<a href="https://nodes.presearch.org/dashboard"> https://nodes.presearch.org/dashboard</a></p>
		     <p>NOTE : Please ensure to have the correct registration code. In case the code is wrong, the node would not register. To update the node version, you can restart the node and it will upgrade automatically.</p>
	  
	 
		 <div class="row">
         	<div class="col-lg-12 col-md-12 col-sm-12">
			
         		 <button class="btn btn-custom waves-light waves-effect w-md m-b-5 pull-right"   onclick="window.location.reload();">Refresh</button>
				<!-- <button class="btn btn-custom waves-light waves-effect w-md m-b-5 pull-right" style="margin-right:10px; background-color:#FD0E35" onclick="window.location.reload();">Restart</button> -->
				 <button class="btn btn-danger  w-md m-b-5 pull-right" style="margin-right:10px; background-color:#dc3545" data-toggle="modal" data-target="#myModal">Restart</button>
				 
         	</div>
         </div>
		 
		<div class="row">
		    <div class="col-lg-12 col-md-4 col-sm-6">
                <div class="card-boxbg col-md-12" style="background-color: blue;color: white;">
                    <div class="col-md-14">
                        <p>Node Registration Code  :  <?php if ( file_exists("/tmp/checkcode") ){ $RegistrationCodeFile = new SplFileObject("/tmp/checkcode");
 $RegistrationCode= trim($RegistrationCodeFile->fgets());if(!empty($RegistrationCode)) echo  $RegistrationCode; else echo "Not Available";
				}?> </p>
                    </div>
                </div>
            </div>
        </div>
			   
			   
	</div>

     	<div class="row">
            <div class="col-lg-12 col-md-4 col-sm-6">  
                <div class="card-box col-md-12">
                    <div class="col-md-12">
                    <span id="PresearchServiceP2P"></span>
                        
                    </div>
                </div>
            </div>   
        </div>          
                  
				  
		<div class="row">	
		
			
			<div class="col-lg-6 col-md-4 col-sm-6"> 
				  <div class="card-box col-md-12">
                       <div class="col-md-12">
                        <span id="IPService"></span>
                     </div>
                    
                  </div>
            </div>
				<div class="col-lg-6 col-md-4 col-sm-6"> 
				  <div class="card-box col-md-12">
                       <div class="col-md-12">
                        <span id="CheckVersion"></span>
                       
                     </div>
                    
                  </div>
            </div>
			
			
		</div>
		
			<div class="row">	
			<div class="col-lg-12 col-md-4 col-sm-6"> 
				<div class="card-box col-md-12">
                    <div class="col-md-10">
                        <h4>Presearch Node Log 
                           <img class="icon-flat" src="assets/images/icons/checkmark.svg" title="checkmark.svg" alt="colored-icons">
                        </h4>
                        <p>The node log of the last 100 lines is shown below. However, if you want to see the full log, you can download the complete log file by clicking the save button. The log file may populate in a few minutes.</p>
                    </div>
                    <div class="col-md-2 m-t-2">
                        <button class="btn btn-success pull-right" ><a href="node.log" download style="color:#fff;">Save Log</a></button>
                    </div>
                </div>
            </div>
		</div>
		
		
		
		
		<div class="row">
		<div class="col-lg-12">
               <div class="portlet">
                  <div class="portlet-heading portlet-default">
                     
                     <div class="portlet-widgets">
					 
                        <a href=""  data-toggle="reload" onclick="myClick()"><i class="ion-refresh"></i></a>
                        <span class="divider"></span>
                        <a data-toggle="collapse" data-parent="#accordion1" href="#bg-default"><i class="ion-minus-round"></i></a>
                        <span class="divider"></span>
                        <a href="#" data-toggle="remove"><i class="ion-close-round"></i></a>
                     </div>
                     <div class="clearfix"></div>
                  </div>
                  <div id="bg-default" class="panel-collapse collapse in" >
                  <div class="card-box">
 
                    <div class="slimScrollDiv  portlet-body pl-10em bg-dark" style="position: relative; overflow-y: scroll; width: auto; height: 350px !important;">
				<!--	<div id="theDiv"> -->
<?php
$file = "node.log";
$f = fopen($file, "r");
while ($line = fgets($f) ) {
print $line;
echo "<br/>";
}
?>
</div>
                     </div>
                     </div> <!-- end card-box -->
                  </div>
               </div>
            </div>
		</div><!-- end row -->
		
		
	</div>
				
      		     
            <!-- End row -->
<?php include("footer.php");?>
<!-- Modal -->
<div id="myModal" class="modal fade" role="dialog">
  <div class="modal-dialog" style="border:2px solid #f90000;">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" style="color:#f90000;">&times;</button>
        <h2 class="modal-title" style="text-align:center;">Confirmation</h2>
      </div>
      <div class="modal-body">
        <p>"Your node is now going to restart. If there is a new version of the node, it will automatically update. Your node identity will not change during the update. The web page may become inaccessible. You may revisit this page in a couple of minutes or refresh."</p>
      </div>
      <div class="modal-footer">
	  <button type="button" class="btn btn-success" onclick="ServerClick()" data-dismiss="modal">Yes</button>
	    <button type="button" class="btn btn-danger" data-dismiss="modal">No</button>
        
      </div>
    </div>

  </div>
</div>

<script type="text/javascript" src= "https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script id="verificationRPC" language="javascript" type="text/javascript">
function CheckPresearchServiceP2P() {
    $.ajax({
        url: 'PresearchService.php', //php          
      //  data: "", //the data "caller=name1&&callee=name2"
      //  dataType: 'json', //data format   
        success: function (data) {
            //on receive of reply
           // alert(data);
            //var foobar = data[2]; //foobar
            $('#PresearchServiceP2P').html(data); //output to html
        }
    });
}

$(document).ready(CheckPresearchServiceP2P); // Call on page load
setInterval(CheckPresearchServiceP2P, 120000); //every 120 secs
//             

function CheckIPService() {
    $.ajax({
        url: 'IPService.php',       
         success: function (data) {       
         $('#IPService').html(data); //output to html
        }
    });
}

$(document).ready(CheckIPService); // Call on page load
setInterval(CheckIPService, 120000); //every 120 secs

function CheckVersionService() {
    $.ajax({
        url: 'CheckVersion.php',       
         success: function (data) {       
         $('#CheckVersion').html(data); //output to html
        }
    });
}

$(document).ready(CheckVersionService); // Call on page load
setInterval(CheckVersionService, 120000); //every 120 secs


/*
$(document).ready(function(){
  $("#refresher").click(function(){ //alert('Please Wait...');
  

    $('#someHiddenDiv').show().delay(2000).fadeOut();
    //$("#refreshtxt").load('node.log');
	//var pageRefresh = 2000;
	 setInterval(
                function()
                {
                    $("#refreshtxt").load("node.log");
                },
                500
            );
	 
  });
});
*/
</script>
<script src="http://code.jquery.com/jquery-1.10.2.js"></script>
<script>
    function myClick()
    {
        var url = 'index.php'; //put the url for the php
        $.post(url, {}); //avoiding using "done", let the timer update instead
    }

    $("document").ready(
        function()
        {
            setInterval(
                function()
                {
                    $("#theDiv").load("node.log");
                },
                500
            );
        }
    );
	
	 function ServerClick()
    { //alert('dinu');
        var url = 'Restartserver.php'; //put the url for the php
        $.post(url, {}); //avoiding using "done", let the timer update instead
    }
	
	
</script>

