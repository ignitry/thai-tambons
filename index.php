<?php 
/**
 * Plugin Name: Upload Thai location Data
 */

//  for ($i = 30000; $i <= 60000; $i++) {
//   FrmEntry::destroy( $i );
//  }

// GET Changwats json to ARRAY
$string = file_get_contents(__DIR__ . "/changwats/json/th.json");
$changwats = json_decode($string, true)['th']['changwats'];


// // GET AMPHOES json to ARRAY
$string = file_get_contents(__DIR__ . "/amphoes/json/th.json");
$amphoes = json_decode($string, true)['th']['amphoes'];

// // GET TOMBONE json to ARRAY
$string = file_get_contents(__DIR__ . "/tambons/json/th.json");
$tambons = json_decode($string, true)['th']['tambons'];


// // INSERT DATA TO FORM

$changwatIndex = 0;
$amphoeIndex = 0;
$tambonIndex = 0;

$i = 0;

foreach ($tambons as $tambon) {

  $changwatID = $changwats[$changwatIndex]['pid'];
  $amphoeID = $amphoes[$amphoeIndex]['pid'];

  $matchAmphoeID = $tambon['amphoe_pid'];
  $matchChangwatID = $tambon['changwat_pid'];
 
  if ($amphoeID != $matchAmphoeID) {
    $amphoeIndex++;
  }

  if ($changwatID != $matchChangwatID) {
    $changwatIndex++;
  }

  $changwatName = $changwats[$changwatIndex]['name'];
  $amphoeName = $amphoes[$amphoeIndex]['name'];
  $tambonName = $tambon['name'];

  createEntry($changwatName, $amphoeName, $tambonName);

  // echo $changwatID . ' ' . $matchChangwatID. ' ' . $amphoeID . ' ' . $matchAmphoeID . ' ' . $changwatName . ' ' . $amphoeName . ' ' . $tambonName .'<br>';
}

function createEntry($changwat, $amphoe, $tambon) {

  $myfile = fopen("output.csv", "a") or die("Unable to open file!");
  $message = "\n\"$changwat\",\"$amphoe\",\"$tambon\"";
  fwrite($myfile, $message);
  fclose($myfile);

}

// function createEntry($changwat, $amphoe, $tambon) {
//   FrmEntry::create(array(
//     'form_id' => 12, 
//     'item_key' => 'entry',
//     'item_meta' => array(
//       66 => $changwat,
//       67 => $amphoe,
//       68 => $tambon,
//     ),
//   ));
// }