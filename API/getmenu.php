<?php

function convertNutritionFacts($extraNutritionFacts) {
    $convertedData = [];

    $unitMappings = [
        'g' => 'g',
        'mg' => 'mg'
    ];

    foreach ($extraNutritionFacts as $key => $value) {
        $keyParts = explode('_', $key);
        $unit = array_shift($keyParts);

        if (in_array($unit, array_keys($unitMappings))) {
            $unitSuffix = $unitMappings[$unit];
            $newKey = ucfirst(implode(' ', $keyParts));
            $newValue = ($value === null) ? '0 ' . $unitSuffix : $value . ' ' . $unitSuffix;
            $convertedData[$newKey] = $newValue;
        }
    }

    return $convertedData;
}

function getFoodInfo($icons) {
    $foodNames = array(); 

    foreach ($icons as $icon) {
        $foodNames[] = $icon["synced_name"];
    }

    return $foodNames; // Return the array containing synced_names
}


function getData($market, $type) {

    $type_mappings = [
        'breakfast' => '14942',
        'lunch' => '14943',
        'dinner' => '14944'
    ];

    $market_mappings = [
        'gordons' => '45372',
        'fourlakes' => '45371'
    ];

    $url = "https://wisc-housingdining.api.nutrislice.com/menu/api/weeks/school/" . $market_mappings[$market] . "/menu-type/" . $type_mappings[$type] . "/" . date("Y/m/d") . "?format=json";
    // echo($url);

    $curl = curl_init($url);
    curl_setopt($curl, CURLOPT_URL, $url);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);

    $resp = curl_exec($curl);

    // Check for cURL errors
    if ($resp === false) {
        $response = array('status' => false);
    } else {
        $response = json_decode($resp, true);
        if ($response === null) {
            $response = array('status' => false);
        }
        
        // Find the correct day's menu_items based on the current date
        $currentDate = date("Y-m-d");
        $todaysmenu = null;

        foreach ($response["days"] as $day) {
            if ($day["date"] === $currentDate) {
                $todaysmenu = $day["menu_items"];
                break;
            }
        }
        
        if ($todaysmenu === null) {
            // Handle the case when the current date's menu_items are not found
            $todaysmenu = array();
        }

        $menu = array(); // To store the menu data

        foreach ($todaysmenu as $menu_item) {
            if (
                isset($menu_item["food"]["name"]) &&
                isset($menu_item["food"]["food_category"]) &&
                $menu_item["food"]["food_category"] !== "beverage"
            ) {
                $foodName = $menu_item["food"]["name"];
                $calories = $menu_item["food"]["rounded_nutrition_info"]["calories"];
                $extraNutritionFacts = convertNutritionFacts($menu_item["food"]["rounded_nutrition_info"]);
                $ingredients = $menu_item["food"]["synced_ingredients"];
                $contains = getFoodInfo($menu_item["food"]["icons"]["food_icons"]);
                unset($extraNutritionFacts["calories"]);
                // Remove text between parentheses in the ingredients

                $menuItem = array(
                    "id" => $menu_item["food"]["id"],
                    "name" => $foodName,
                    "calories" => $calories,
                    "extraNutritionFacts" => $extraNutritionFacts,
                    "ingredients" => $ingredients,
                    "contains" => $contains
                );

                $menu[] = $menuItem;
            }
        }

        // Create a JSON response with the extracted menu data
        $parsedResponse = array("menu" => $menu);
        return $parsedResponse;
    }

    curl_close($curl);

    return $response; // Return the response data
}

// Check if the required parameters are present in the URL
if (isset($_GET['market']) && isset($_GET['type'])) {
    $market = $_GET['market'];
    $type = $_GET['type'];

    $data = getData($market, $type);

    // Set the Content-Type header to JSON
    header('Content-Type: application/json');

    // Echo the JSON-encoded data
    echo json_encode($data);
} else {
    // If required parameters are missing, return an error message
    echo json_encode(array('error' => 'Missing parameters'));
}
?>
