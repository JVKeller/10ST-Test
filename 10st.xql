xquery version "3.0";

module namespace mymodule="http://exist-db.org/apps/myapp/mymodule";

declare option output:method "html5";
declare option output:media-type "text/html";

<html>
    <head>
        <link rel="stylesheet" href="style.css">
    </head>
    <body>
        <ul>
            {
                
            for $FamilyName in collection("/db/10street")//FamilyName
            for $DriverId in collection("/db/10street")//DriverId
            return
                <li>{$FamilyName/text()}, {$DriverId/text()}</li>
            }
        </ul>
    </body>
</html>
