<#assign jpath=handlers("JsonHandler")>
<#assign watts="{ \"method\" : \"GET\", \"url\" : \"http://your_url.com/api/history/period/2023-02-13T06:46:44.591335+00:00?filter_entity_id=sensor.pc_oficina_mss310_power_w_main_channel\", \"headers\":{\"Authorization\": \"Bearer TOKEN\"}}">
<#assign volt="{ \"method\" : \"GET\", \"url\" : \"http://your_url.com/api/history/period/2023-02-13T06:46:44.591335+00:00?filter_entity_id=sensor.pc_oficina_mss310_voltage_v_main_channel\", \"headers\":{\"Authorization\": \"Bearer TOKEN\"}}">
<#assign energy=providers("HttpProvider", watts)>
<#assign voltage=providers("HttpProvider", volt)>

<#assign i=0>
<#assign index=0>

[
<#list jpath.filter("$.[0].[*]",energy) as fragment>
{
    "@context" : "https://auroralh2020.github.io/auroral-ontology-contexts/adapters/context.json",
    "id" : "[=jpath.filter("$.entity_id",fragment)]",
    "@type":"core-sensor-energy-monitor",
    "measurement" : [{
        "timestamp":"[=jpath.filter("$.last_updated",fragment)]",
        "value":"[=jpath.filter("$.state",fragment)]",
        "type":"number",
        "property":"energyConsumption"  
    },{
        "timestamp":"[=jpath.filter("$.[0].[[=index]].last_updated",voltage)]",
        "value":"[=jpath.filter("$.[0].[[=index]].state",voltage)]",<#assign index=index+1>
        "type":"number",
        "property":"electricVoltage"  
    }
    ]
}
<#assign i=i+1><#if i==5><#break></#if>,
</#list>
]