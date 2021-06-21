<?php include("header.php");
function readLastLines($filename, $num, $reverse = false)
			{
				if ( file_exists($filename) )
				{
				$file = new \SplFileObject($filename, 'r');
			        $file->seek(PHP_INT_MAX);
			        $last_line = $file->key();			    
				if ($last_line>0) {
				    if ($last_line>9){
				    $lines = new \LimitIterator($file, $last_line - $num, $last_line);
				    } else 
				    {	//$lines=$last_line;
				    	$lines = new \LimitIterator($file, '0', $last_line);
				    }
				    $arr = iterator_to_array($lines);
			    }
			    
			    if($reverse) $arr = array_reverse($arr);			    
			    //print_r($arr);
			    return $arr;
				}
			      else return array("File not Found"); 
			}
?>
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
                        <img class="icon-colored ml-0" src="assets/images/dash-logo.png" title="dash logo" alt="colored-icons">
                        Dash Node Status
                     </h4>
                     <p>Your Dash node is now running succesfully on the Three Fold Grid. You can interact with your node by making RPC calls with the RPC credentials provided in the setup. A sample RPC call is below that you can run from your Linux terminal.</p>
                     <p>The node statistics may take a few minutes to populate, therefore, please be patient. Alternately, you can click the "Refresh" button to reload statistics.</p>					 
		 
		 <div class="row">
         	<div class="col-lg-12 col-md-12 col-sm-12">
         		 <button class="btn btn-custom waves-light waves-effect w-md m-b-5 pull-right" onclick="window.location.reload();">Refresh</button>
         	</div>
         </div>
		 
			   <div class="row">
			    <div class="col-lg-12 col-md-4 col-sm-6">
                  <div class="card-boxbg col-md-12" style="background-color: #3430a0;color: white;">
                       <div class="col-md-14">
                        <p>curl -v --data-binary '{"jsonrpc":"1.0","id":"cmdrpc","method":"getblockchaininfo","params":[]}'-H 'content-type:text/plain;'http://rpcuser:rpcpassword@PUBLIC_IP:9998/</p>
                       
                     </div>
                    
                  </div>
               </div>
	   </div>
			   
				   
                  </div>
               </div>
            </div>
            <!-- end page title end breadcrumb -->
            <!-- Basic Form Wizard -->
         
			<div class="row">
              
               <div class="col-lg-6 col-md-4 col-sm-6">
                  <div class="card-box col-md-12">
                       <div class="col-md-12">
                        <h4>Node Type: Full Node <img class="icon-flatright" src="assets/images/icons/checkmark.svg" title="checkmark.svg" alt="colored-icons"></h4>
                       
                     </div>
                    
                  </div>
                  <div class="card-box col-md-12">
                       <div class="col-md-12">
                        <span id="verificationRPC"></span>
                       
                       
                     </div>                    
                  </div>
                  
                   <div class="card-box col-md-12">
                       <div class="col-md-12">
                        <h4>Dash Daemon Uptime : <span id='NodeUptimeHtml'></span> <img class="icon-flatright" src="assets/images/icons/checkmark.svg" title="checkmark.svg" alt="colored-icons"></h4>
                       
                     </div>                    
                  </div>
                  
                  <div class="card-box col-md-12">
                       <div class="col-md-12">
                        <h4>Node Sync Status - % 
                           <img class="icon-flatright" src="assets/images/icons/checkmark.svg" title="checkmark.svg" alt="colored-icons">
                        </h4>
                    
                    
                        <div class="text-center">
                       
                        <input id="PercentageHtml" type="text" style="border-color: transparent;" data-readOnly="true" data-width="200" data-height="200">
                         <span id="BlockCountHtml" style="color:#797979; font-size:16px;"> </span>
                        </div>
                     </div>
                     
                  </div>
               </div> <!--  left side colum -->
               
               <div class="col-lg-6 col-md-4 col-sm-6">
                <div class="card-box col-md-12">
                       <div class="col-md-12">
                        <h4>Network : Mainnet  <img class="icon-flatright" src="assets/images/icons/checkmark.svg" title="checkmark.svg" alt="colored-icons"></h4>
                       
                     </div>                    
                  </div>
                  
                   <div class="card-box col-md-12">
                       <div class="col-md-12">
                       <span id="verificationP2P"></span>
                       
                       
                     </div>                    
                  </div>
                  
                   <div class="card-box col-md-12">
                  <!-- <p style="float:right;">Digibyte daemon uptime for the last 12 hours</p> -->
                  <br><br>
                    <div id="website-stats1" style="height: 320px;" class="flot-chart"></div>             
                    
                  </div>
               </div><!-- right side colum  -->
          
               <div class="col-lg-12 col-md-12 col-sm-12">
                  <div class="card-box col-md-12">
                  
                  
                       <div class="col-md-10">
                        <h4>Dash Node Log 
                           <img class="icon-flat" src="assets/images/icons/checkmark.svg" title="checkmark.svg" alt="colored-icons">
                        </h4>
                        <p>The log for the last 100 lines is shown below. However, if you want to see the full log, you can download the complete log file by clicking the save button. The log file may populate in a few minutes.</p>
                     </div>
                     <div class="col-md-2 m-t-2">
                        <button class="btn btn-success pull-right" ><a href="node.log" download style="color:#fff;">Save Log</a></button>
                     </div>
               </div>
            </div>
            <div class="col-lg-12">
               <div class="portlet">
                  <div class="portlet-heading portlet-default">
                     
                     <div class="portlet-widgets">
                        <a href="javascript:;" data-toggle="reload"><i class="ion-refresh"></i></a>
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
                        <?php // use it by
 $lines = readLastLines("/tmp/checklogs", 100); // return string with 100 last lines  
                      
 if (!empty($lines)){
 foreach ($lines as $k) {
 	echo $k."<br>";
 	
 }
 }
?>
                     </div>
                     </div> <!-- end card-box -->
                  </div>
               </div>
            </div>
            </div>
            <!-- End row -->
            <?php include("footer.php");?>
         <script type="text/javascript">
         ! function($) {
        		"use strict";

        		var FlotChart = function() {
        			this.$body = $("body")
        			this.$realData = []
        		};

        		//creates plot graph
        		FlotChart.prototype.createPlotGraph = function(selector, data1, labels, colors, borderColor, bgColor) {
        			//shows tooltip
        			//alert(bgColor + " ---"+borderColor + "------" + colors);
        			function showTooltip(x, y, contents) {
        				$('<div id="tooltip" class="tooltipflot">' + contents + '</div>').css({
        					position : 'absolute',
        					top : y + 5,
        					left : x + 5
        				}).appendTo("body").fadeIn(200);
        			}


        			$.plot($(selector), [{
        				data : data1,
        				label : labels,
        				color : colors
        			}], {
        				series : {
        					lines : {
        						show : true,
        						fill : true,
        						lineWidth : 2,
        						fillColor : {
        							colors : [{
        								opacity : 0
        							}, {
        								opacity : 0.5
        							},{
        								opacity : 0.6
        							}]
        						}
        					},
        					points : {
        						show : false
        					},
        					shadowSize : 0
        				},

        				grid : {
        					hoverable : true,
        					clickable : true,
        					borderColor : borderColor,
        					tickColor : "#f9f9f9",
        					borderWidth : 1,
        					labelMargin : 10,
        					backgroundColor : bgColor
        				},
        				legend : {
        					position : "ne",
        					margin : [0, -24],
        					noColumns : 0,
        					labelBoxBorderColor : null,
        					labelFormatter : function(label, series) {
        						// just add some space to labes
        						return '' + label + '&nbsp;&nbsp;';
        					},
        					width : 30,
        					height : 2
        				},
        				yaxis : {
        					axisLabel: "Daily Visits",
        					tickColor : '#f5f5f5',
        					font : {
        						color : '#188ae2'
        					}
        				},
        				xaxis : {
        					axisLabel: "Last Days",
        					tickColor : '#f5f5f5',
        					tickSize: [1],
        					font : {
        						color : '#188ae2'
        					},
        					//ticks: [[0, '12'], [1, '11'], [2, '10'], [3, '9'], [4, '8'], [5, '7'], [6, '6'], [7, '5'], [8, '4'], [9, '3'], [10, '2'], [11, '1']]
        				},
        				tooltip : true,
        				tooltipOpts : {
        					content : '%s: Value of %x is %y',
        					shifts : {
        						x : -60,
        						y : 25
        					},
        					defaultTheme : false
        				}
        			});
        		},
        		//end plot graph


        		//initializing various charts and components
        		FlotChart.prototype.init = function() {
        			//plot graph data
        			<?php 
						 include 'chartfunction.php';
			?>
            		var downloads1 = <?php echo  $chart_data;?>;
        			var plabels = ["Block Sync - Last 12 hours"];
        			var pcolors = ['#188ae2'];
        			var borderColor = '#f5f5f5';
        			var bgColor = '#fff';
        			this.createPlotGraph("#website-stats1",  downloads1, plabels, pcolors, borderColor, bgColor);


        			
        		},

        		//init flotchart
        		$.FlotChart = new FlotChart, $.FlotChart.Constructor =
        		FlotChart

        	}(window.jQuery),

        	//initializing flotchart
        	function($) {
        		"use strict";
        		$.FlotChart.init()
        	}(window.jQuery);
         
         </script>
          
          
    <script type="text/javascript" src= "https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="assets/js/knob.js"></script>
    
    <script type="text/javascript">
          
          function knobfunction(value1){
            //  alert(value1);
             // var value1='5.22';
        		$('#PercentageHtml')
        	    .val(value1)
        	    .trigger('change');
        	}

        	/* $("#PercentageHtml").knob({
        		 readOnly: true,   
        		      		    
        	    'change' : function (v) { console.log(v); }
        	});*/
          </script>
    
    <script id="verificationRPC" language="javascript" type="text/javascript">
function CheckRPCService() {
    $.ajax({
        url: 'CheckRPCService.php', //php          
      //  data: "", //the data "caller=name1&&callee=name2"
      //  dataType: 'json', //data format   
        success: function (data) {
            //on receive of reply
           // alert(data);
            //var foobar = data[2]; //foobar
            $('#verificationRPC').html(data); //output to html
        }
    });
}
function CheckP2PService() {
    $.ajax({
        url: 'CheckP2PService.php', //php          
      //  data: "", //the data "caller=name1&&callee=name2"
      //  dataType: 'json', //data format   
        success: function (data) {
            //on receive of reply
           // alert(data);
            //var foobar = data[2]; //foobar
            $('#verificationP2P').html(data); //output to html
        }
    });
}

$(document).ready(CheckRPCService); // Call on page load
$(document).ready(CheckP2PService); // Call on page load
//                


setInterval(CheckRPCService, 120000); //every 120 secs
setInterval(CheckP2PService, 120000); //every 120 secs
</script>
<script id="BlockCount" language="javascript" type="text/javascript">
function BlockCount() {
    $.ajax({
        url: 'CheckHeaderHashesBlockCountService.php', //php          
      //  data: "", //the data "caller=name1&&callee=name2"
      //  dataType: 'json', //data format   
        success: function (data) {
            //on receive of reply
         //  alert(data);
           var fields = data.split('~');
           var data_Percentage=fields[0];
            var data_header = fields[1]; //foobar
            
            $('#BlockCountHtml').html(data_header); //output to html
          //  $('#PercentageHtm').html(data_Percentage); //output to html
          //   $('#PercentageHtml').val(data_Percentage).trigger('change');
            //var randomnumber = Math.round(Math.random() * 100);
            knobfunction(data_Percentage);
            $('#PercentageHtml').knob();
            $("#PercentageHtml").val(data_Percentage);
            
        }
    });
}

$(document).ready(BlockCount); // Call on page load              
setInterval(BlockCount, 120000); //every 120 secs
//alert(data_Percentage);

function NodeUptime() {
    $.ajax({
        url: 'CheckNodeUptimeService.php', //php          
      //  data: "", //the data "caller=name1&&callee=name2"
      //  dataType: 'json', //data format   
        success: function (data) {
            $('#NodeUptimeHtml').html(data); //output to html
        }
    });
}

$(document).ready(NodeUptime); // Call on page load              
setInterval(NodeUptime, 120000); //every 120 secs
//alert(data_Percentage);
</script>
                     
