xquery version "3.1";

declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "html";
declare option output:html-version "5";
declare option output:media-type "text/html";

let $records := collection("/db/apps/10street/data")/TenstreetData
let $title := "Tenstreet Data"
return
    <html>
        <head>
            <title>{$title}</title>
            <link rel="stylesheet" type="text/css" href="tenstreet.css"/>
        </head>
        <body>
            <h1>{$title}</h1>
            <h3>{count($records) || " " || $title} driver records.</h3>
            {
                for $record in $records
                let $driver-id := $record/DriverId/string()
                let $firstname := $record/PersonalData/PersonName/GivenName
                let $lastname := $record/PersonalData/PersonName/FamilyName
                let $fullname := string-join(($lastname, $firstname), ", ")
				let $doclist := $record/Documents/Document/Filename/string()
				let $docid := $record/Documents/Document/FileId/string()
                order by $lastname/FamilyName
                return
                    <div id="output">
                        <font face="Arial">
                            <table align="center">
                                <tr>
                                    <td>
                                        <table style="width: 100%">
                                            <tr style="background-color: chartreuse;">
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
												        for $item in $docid
												        return
												            <li><a href="files/{$item}">{$item} </a></li>
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
