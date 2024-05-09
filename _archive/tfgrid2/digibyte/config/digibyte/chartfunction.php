<?php 
error_reporting(0);

date_default_timezone_set('Asia/Kolkata');

 global  $chart_data,$file_date;			// use it by
 if ( file_exists("/tmp/checkgraph") )
				{		
 	$fh = fopen('/tmp/checkgraph','r');
	while ($value = fgets($fh)) {
    	//echo $value;
        $array_data= explode(",",$value);
       // print_r($array_data);
	        for($i=0; $i<=12; $i++)
	        {
	      			  $label = date('Y-m-d H', strtotime('-'.$i.' hour',strtotime(date('Y-m-d H:i'))));
	      			  //echo trim($array_data[1])."------".$label; die();
	      			 $file_date= date('Y-m-d H', strtotime(trim($array_data[1])));
	      			 
	      			//echo "current date--".$label."---file date---".$file_date;
					    if ($label == $file_date)
					             {
					             	$get_hours=explode(" ",$file_date);
					             if ( $get_hours[1] =='01'){	$array_data01.=$array_data[0]."^";}
					             if ( $get_hours[1] =='02'){	$array_data02.=$array_data[0]."^";}
					             if ( $get_hours[1] =='03'){	$array_data03.=$array_data[0]."^";}
					             if ( $get_hours[1] =='04'){	$array_data04.=$array_data[0]."^";}
					             if ( $get_hours[1] =='05'){	$array_data05.=$array_data[0]."^";}
					             if ( $get_hours[1] =='06'){	$array_data06.=$array_data[0]."^";}
					             if ( $get_hours[1] =='07'){	$array_data07.=$array_data[0]."^";}
					             if ( $get_hours[1] =='08'){	$array_data08.=$array_data[0]."^";}
					             if ( $get_hours[1] =='09'){	$array_data09.=$array_data[0]."^";}
					             if ( $get_hours[1] =='10'){	$array_data10.=$array_data[0]."^";}
					             if ( $get_hours[1] =='11'){	$array_data11.=$array_data[0]."^";}
					             if ( $get_hours[1] =='12'){	$array_data12.=$array_data[0]."^";}
					             if ( $get_hours[1] =='13'){	$array_data13.=$array_data[0]."^";}
					             if ( $get_hours[1] =='14'){	$array_data14.=$array_data[0]."^";}
					             if ( $get_hours[1] =='15'){	$array_data15.=$array_data[0]."^";}
					             if ( $get_hours[1] =='16'){	$array_data16.=$array_data[0]."^";}
					             if ( $get_hours[1] =='17'){	$array_data17.=$array_data[0]."^";}
					             if ( $get_hours[1] =='18'){	$array_data18.=$array_data[0]."^";}
					             if ( $get_hours[1] =='19'){	$array_data19.=$array_data[0]."^";}
					             if ( $get_hours[1] =='20'){	$array_data20.=$array_data[0]."^";}
					             if ( $get_hours[1] =='21'){	$array_data21.=$array_data[0]."^";}
					             if ( $get_hours[1] =='22'){	$array_data22.=$array_data[0]."^";}
					             if ( $get_hours[1] =='23'){	$array_data23.=$array_data[0]."^";}
					             if ( $get_hours[1] =='00'){	$array_data24.=$array_data[0]."^";}
					                     
					             }
	        }   
	      //  $max_array_data=explode("^",$array_data);
    }
   // print_r($array_data10);
    $max_array01=explode("^",$array_data01);$MaxDataFormArray01=max($max_array01);
    $max_array02=explode("^",$array_data02);$MaxDataFormArray02=max($max_array02);
    $max_array03=explode("^",$array_data03);$MaxDataFormArray03=max($max_array03);
    $max_array04=explode("^",$array_data04);$MaxDataFormArray04=max($max_array04);
    $max_array05=explode("^",$array_data05);$MaxDataFormArray05=max($max_array05);
    $max_array06=explode("^",$array_data06);$MaxDataFormArray06=max($max_array06);
    $max_array07=explode("^",$array_data07);$MaxDataFormArray07=max($max_array07);
    $max_array08=explode("^",$array_data08);$MaxDataFormArray08=max($max_array08);
    $max_array09=explode("^",$array_data09);$MaxDataFormArray09=max($max_array09);
    $max_array10=explode("^",$array_data10);$MaxDataFormArray10=max($max_array10);
    $max_array11=explode("^",$array_data11);$MaxDataFormArray11=max($max_array11);
    $max_array12=explode("^",$array_data12);$MaxDataFormArray12=max($max_array12);
    $max_array13=explode("^",$array_data13);$MaxDataFormArray13=max($max_array13);
    $max_array14=explode("^",$array_data14);$MaxDataFormArray14=max($max_array14);
    $max_array15=explode("^",$array_data15);$MaxDataFormArray15=max($max_array15);
    $max_array16=explode("^",$array_data16);$MaxDataFormArray16=max($max_array16);
    $max_array17=explode("^",$array_data17);$MaxDataFormArray17=max($max_array17);
    $max_array18=explode("^",$array_data18);$MaxDataFormArray18=max($max_array18);
    $max_array19=explode("^",$array_data19);$MaxDataFormArray19=max($max_array19);
    $max_array20=explode("^",$array_data20);$MaxDataFormArray20=max($max_array20);
    $max_array21=explode("^",$array_data21);$MaxDataFormArray21=max($max_array21);
    $max_array22=explode("^",$array_data22);$MaxDataFormArray22=max($max_array22);
    $max_array23=explode("^",$array_data23);$MaxDataFormArray23=max($max_array23);
    $max_array24=explode("^",$array_data24);$MaxDataFormArray24=max($max_array24);
    
   // print_r(max($max_array10));
   // echo "<hr>";
    $max_array08=explode("^",$array_data08);
   // print_r(max($max_array08));
   $array_my_chart_data= array(1 =>$MaxDataFormArray01,$MaxDataFormArray02,$MaxDataFormArray03,$MaxDataFormArray04,$MaxDataFormArray05,$MaxDataFormArray06,
   $MaxDataFormArray07,$MaxDataFormArray08,$MaxDataFormArray09,$MaxDataFormArray10,$MaxDataFormArray11,$MaxDataFormArray12,$MaxDataFormArray13,
   $MaxDataFormArray14,$MaxDataFormArray15,$MaxDataFormArray16,$MaxDataFormArray17,$MaxDataFormArray18,$MaxDataFormArray19,$MaxDataFormArray20
   ,$MaxDataFormArray21,$MaxDataFormArray22,$MaxDataFormArray23,$MaxDataFormArray24);
  // print_r($array_my_chart_data);
 
     $get_current_hours=explode(" ",date('Y-m-d H'));
// print_r($get_current_hours[1]);

			 
			// echo "max-->".$max = max($lines);                    
					$chart_data.="[";
                        $x=12;
					//$get_current_hours=20;
                         for ($h=0;$h<=12;$h++)
						 {
						 $data_chart1=$get_current_hours[1]--;
						 
						 if ($data_chart1 == 0) $data_chart1="24";
						// echo "<>".$data_chart1." <> ".$data_chart2;
						 	//$chart_data.=$array_my_chart_data[$data_chart1];
						 $chart_data.="[".($x).",".$array_my_chart_data[$data_chart1]."],";
						 	/* if (!empty($array_my_chart_data[$data_chart1])){
						 		
						 	} */
						 	$x--;
						 }
					$chart_data.="]";
					//echo  $chart_data;
fclose($fh);
				}		
			?>