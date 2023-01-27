xquery version "3.1";

(:~ This is the default application library module of the tenstreet app.
 :
 : @author 
 : @version 1.0.0
 : @see http://exist-db.org
 :)

(: Module for app-specific template functions :)
module namespace app="http://exist-db.org/apps/tenstreet/templates";
import module namespace templates="http://exist-db.org/xquery/html-templating";
import module namespace lib="http://exist-db.org/xquery/html-templating/lib";
import module namespace config="http://exist-db.org/apps/tenstreet/config" at "config.xqm";


(:~
 : This is a sample templating function. It will be called by the templating module if
 : it encounters an HTML element with an attribute: data-template="app:test" or class="app:test" (deprecated).
 : The function has to take 2 default parameters. Additional parameters are automatically mapped to
 : any matching request or function parameter.
 :
 : @param $node the HTML node with the attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)

declare
    %templates:wrap
function app:foo($node as node(), $model as map(*)) {
    <p>Dummy templating function.</p>
};

declare function app:test($node as node(), $model as map(*)) {
    <p>Dummy template output generated by function app:test at {current-dateTime()}. The templating
        function was triggered by the class attribute <code>class="app:test"</code>.</p>
};

declare function functx:substring-after-last
    ($string as xs:string?, $delim as xs:string) as xs:string?
     {
       if (contains ($string, $delim))
       then functx:substring-after-last(substring-after($string, $delim), $delim)
       else $string
     };

let $records := collection("/db/apps/tenstreet/data")/TenstreetData
let $title := "Tenstreet Data"
let $filenames := collection("/db/apps/tenstreet/files")
return
    <html>
        <head>
            <title>{$title}</title>
            <link rel="stylesheet" href="tenstreet.css"/>
        </head>
        <body>
            <h1 style="text-align: center;">{$title}</h1>
            <h3 style="text-align: center;">{count($records) || " " || $title} driver records.</h3>
                <br />
            <h3 style="text-align: center; color:#ffffff"><span class="blink">** Press Crtl+F to find a name quickly **</span></h3>
            <p style="font-size: .75rem; text-align: center; color:#d0d0d0">Documents named "None" are empty files and do not open</p>
                <br />
            {
                for $record in $records
                let $driver-id := $record/DriverId/string()
                let $firstname := $record/PersonalData/PersonName/GivenName
                let $lastname := $record/PersonalData/PersonName/FamilyName
                let $fullname := string-join(($lastname, $firstname), ", ")
				let $filename := $record/Documents/Document/Filename/string()
				let $fileid := $record/Documents/Document/FileId/string()

                order by $lastname/FamilyName
                return
                    <div id="output">
                        <font face="Arial">
                            <table align="center">
                                <tr>
                                    <td>
                                        <table style="width: 100%">
                                            <tr style="background-color: #7db348;">
                                                <td colspan="2" style="width: 50%;"align="right"><strong>Driver ID: </strong>{$driver-id}</td>
                                                <td colspan="2" style="width: 50%;" align="right"><a href="data/{util:document-name($record)}">Raw XML</a></td>
                                            </tr>
                                        </table>
                                        <br />
                                        <table class="fr-alternate-rows" style="width: 100%;">
                                        	<tbody>
                                        		<tr>
                                        			<th colspan="2" style="width: 50%;"><div style="text-align: center;"> <strong>Driver Info</strong></div> </th>
                                        			<th style="width: 25.0000%;"> <strong>Associated Files</strong> </th>
                                        		</tr>
                                        		<tr>
                                        			<th>Name:</th>
                                        			<th><strong> {$fullname} </strong></th>
                                        			<th rowspan="8" style="vertical-align: top;">

        												    <ol>{
        												        for $document in $record/Documents/Document
                                                                let $file-id := $document/FileId
                                                                let $description := $document/Filename
                                                                let $file-extension := functx:substring-after-last($document/Filename, ".")
                                                                return
                                                                <li><a style="color: #77eca4;" href="files/{$file-id}.{$file-extension}" target="_blank">{$description}</a></li>
        											    	}</ol>

													</th>
                                        		</tr>
                                        		<tr>
                                        			<td style="width: 25.0000%;">Driver / Record Number</td>
                                        			<td style="width: 25.0000%;"><strong> {$driver-id} </strong> </td>
                                        		</tr>
                                        		<tr>
                                        			<td style="width: 25.0000%;">Address:</td>
                                        			<td style="width: 25.0000%;"> <strong>{$record/PersonalData/PostalAddress/Address1} {$record/PersonalData/PostalAddress/Address2}</strong></td>
                                        		</tr>
                                        		<tr>
                                        			<td style="width: 25.0000%;">City/State/ZIP:</td>
                                        			<td style="width: 25.0000%;"> <strong>{$record/PersonalData/PostalAddress/Municipality}, {$record/PersonalData/PostalAddress/Region} {$record/PersonalData/PostalAddress/PostalCode}</strong></td>
                                        		</tr>
                                        		<tr>
                                        			<td style="width: 25.0000%;">Phone:</td>
                                        			<td style="width: 25.0000%;">{$record/PersonalData/ContactData/PrimaryPhone} </td>
                                        		</tr>
                                        		<tr>
                                        			<td style="width: 25.0000%;">Email:</td>
                                        			<td style="width: 25.0000%;">{$record/PersonalData/ContactData/InternetEmailAddress}  </td>
                                        		</tr>
                                        		<tr>
                                        			<td style="width: 25.0000%;">Government ID:</td>
                                        			<td style="width: 25.0000%;"> {$record/PersonalData/GovernmentID}</td>
                                        		</tr>
                                        		<tr>
                                        			<td style="width: 25.0000%;"> </td>
                                        			<td style="width: 25.0000%;"> </td>
                                        		</tr>
                                        	</tbody>
                                        </table>
                                    </td>
                                </tr>
                            </table>  
                            <br /><br /><br />
                        </font>
                    </div>
            }
        </body>
    </html>
