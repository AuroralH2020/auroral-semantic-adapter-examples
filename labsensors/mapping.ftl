<#assign jpath=handlers("JsonHandler")>
<#assign bodyrequest = "{\"stmt\":\"SELECT entity_id, entity_type, time_index, humidity, pressure, temperature, sound, luminosity, co2, uv, pm1_0, pm2_5, pm10, windspeed FROM mtsmartcampus_uni.etbeegons limit "+q+"\"}">
<#assign config="{ \"method\" : \"POST\", \"url\" : \"https://data.fog.linkeddata.es/_sql?types\", \"body\":[=bodyrequest]}">
<#assign dataset=providers("HttpProvider", config)>
<#assign sensors_map = '{"humidity": "humiditySensor", "pressure": "sensor", "temperature":"thermometer", "sound":"sensor","luminosity":"sensor","co2":"airQualitySensor","uv":"weatherSensor","pm1_0":"airQualitySensor","pm2_5":"airQualitySensor","pm10":"airQualitySensor"}' >
<#assign property_map = '{"humidity": "relativeHumidity", "pressure": "atmosphoricPressure", "temperature":"ambientTemperature", "sound":"noiseLevel","luminosity":"illuminance","co2":"cO2Concentration","uv":"uVIndex","pm1_0":"pM10Concentration","pm2_5":"pM2.5Concentration","pm10":"pM10Concentration"}' >

<#assign cols = jpath.filter('$.cols', dataset)> 
[
<#list jpath.filter('$.rows', dataset) as item>
    <#assign it = jpath.filter('$', item)>
    <#list 3..it?size-1 as count>
{
    "@context": "https://raw.githubusercontent.com/AuroralH2020/auroral-ontology-contexts/main/labsensors/context.json",
    "@type":"[=jpath.filter("$.[=cols[count]]", sensors_map)]",
    "id": "[=it[0]?replace(':','_')]_[=cols[count]]",
    "measures":{
        "@type": "saref:Measurement",
        "id": "[=it[0]?replace(':','_')]_[=cols[count]]_[=it[2]]",
        "timestamp": [=it[2]],
        "value": [=it[count]],
        "relates": "[=jpath.filter("$.[=cols[count]]", property_map)]"
    }
}<#if count?is_last><#else>,</#if>

    </#list>
<#if item?is_last><#else>,</#if>
</#list>
]
