<#assign jpath=handlers("JsonHandler")>
<#assign config="{ \"method\" : \"GET\", \"url\" : \"https://smartburgenland.at/api/partner/v1/activity\", \"headers\":{\"Authorization\": \"Bearer "+token+"\"}}">
<#assign tour=providers("HttpProvider", config)>

[
<#list jpath.filter("$.*",tour) as fragment>
{
    "@context" : "https://auroralh2020.github.io/auroral-ontology-contexts/tour/context.json",
    "identifier" : "[=jpath.filter("$.activity_id",fragment)]",
    "title" : "[=jpath.filter("$.activity_title",fragment)?j_string]",
    "hidden_description" : "[=jpath.filter("$.activity_hidden_description",fragment)?j_string]",
    "long_description" : "[=jpath.filter("$.activity_long_description",fragment)?j_string]",
    "short_description" : "[=jpath.filter("$.activity_short_description",fragment)?j_string]",
    "bookable" : [=jpath.filter("$.activity_is_bookable",fragment)],
    <#if jpath.filter("$.activity_event_start",fragment)?has_content>
        "starts" : "[=jpath.filter("$.activity_event_start",fragment)]",
    </#if>
    <#if jpath.filter("$.activity_event_end",fragment)?has_content>
        "ends" : "[=jpath.filter("$.activity_event_end",fragment)]",
    </#if>
    "last_modification" : "[=jpath.filter("$.activity_last_modified",fragment)]",
    "rights" : "[=jpath.filter("$.activity_copyright",fragment)?j_string]",
    "location":{
        "lat": "[=jpath.filter("$.activity_geoposition_latitude",fragment)]",
        <#assign latitude=jpath.filter("$.activity_geoposition_latitude",fragment)>
        "long": "[=jpath.filter("$.activity_geoposition_longitude",fragment)]"
        <#assign longitude=jpath.filter("$.activity_geoposition_longitude",fragment)>
        <#assign weatherURI="https://api.openweathermap.org/data/2.5/weather?lat="+latitude+"&lon="+longitude+"&appid="+appid>
        <#assign weatherConf = "{\"url\" : \""+weatherURI+"\"}">
        <#assign weather=providers("URLProvider", weatherConf)>
    },
    "channels":{
        "name": "[=jpath.filter("$.channel_name",fragment)]",
        "id": "[=jpath.filter("$.channel_id",fragment)]"
    },
    <#if jpath.filter("$.activity_tour_difficulty",fragment)?has_content>
    "difficulty" : "[=jpath.filter("$.activity_tour_difficulty",fragment)]",
    </#if>
    "cover":{
        "img": "[=jpath.filter("$.activity_image",fragment)]"
    },
    "weather":{
        "windSpeed": "[=jpath.filter("$.wind.speed",weather)]",
        "clouds": "[=jpath.filter("$.clouds.all",weather)]",
        "temp_max": "[=jpath.filter("$.main.temp_max",weather)]",
        "temp_min": "[=jpath.filter("$.main.temp_min",weather)]",
        "humidity": "[=jpath.filter("$.main.humidity",weather)]",
        "visibility": "[=jpath.filter("$.visibility",weather)]"
        <#assign city=jpath.filter("$.name",weather)?replace(" ","_")>
        <#assign wikiApi="https://en.wikipedia.org/api/rest_v1/page/summary/"+city>
        <#assign wikiConf = "{\"url\" : \""+wikiApi+"\"}">
    }<#attempt><#assign wiki=providers("URLProvider", wikiConf)><#if jpath.filter("$.extract",wiki)?has_content>,"other":{
        "extract": "[=jpath.filter("$.extract",wiki)]",
        "wikiDesktop": "[=jpath.filter("$.content_urls.desktop.page",wiki)]",
        "wikiMobile": "[=jpath.filter("$.content_urls.mobile.page",wiki)]"
    }</#if><#recover></#attempt>

}<#if fragment?is_last><#else>,</#if>
</#list>
]
