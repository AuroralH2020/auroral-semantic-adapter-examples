<#assign token = "TOKEN_TO_CHANGE">
<#assign config="{ \"method\" : \"GET\", \"url\" : \"URI_TO_CHANGE\", \"headers\":{\"Authorization\": \"Bearer "+token+"\"}}">
<#assign shipments=providers("HttpProvider", config)>

<#assign shipment= shipments?eval>


{
"@context" : "https://auroralh2020.github.io/auroral-ontology-contexts/biomass/shipments.json",
"id" : "[=shipment.id]",
"name" : "[=shipment.provider_name]",
"receivedBy" : "[=shipment.active_clients]",
"providedBy" : "[=shipment.active_providers]",
"avgSustainabilityScore" : "[=shipment.avg_sustainability_score]",
"quantity":[
{
   "@type": "biom:TotalQuantity",
   "value": "[=shipment.total_biomass]"
},{
   "@type": "biom:CurrentQuantity",
   "value": "[=shipment.current_biomass]"
}<#if shipment.biomass_bought_by_type??>,{
   "@type": "biom:BoughtQuantity",
   "value": "[=shipment.biomass_bought]",
   "boughtQuantityPerGroup":[
    <#list shipment.biomass_bought_by_type?keys as key>
        <#assign value = shipment.biomass_bought_by_type[key]>
   {
   "relatedTo":"[=key?replace(" ", "", "r")]",
   "value":"[=value]"
   }<#if key?has_next>,</#if> 
    </#list>
   ]
}</#if><#if shipment.biomass_sold_by_type_caliber??>,{
   "@type": "biom:BoughtQuantity",
   "value": "[=shipment.biomass_sold]",
   "soldQuantityPerGroup":[
    <#list shipment.biomass_sold_by_type_caliber?keys as key>
   {
   "relatedTo":"[=key?replace(" ", "", "r")]",
"quantityPerCaliber":[    <#list shipment.biomass_sold_by_type_caliber[key]?keys as keySold>
{ <#assign parts = keySold?split(",")>            
<#if parts?size == 1>
"hasCaliber":"[=parts[0]]",
<#else>
"hasCaliber":"[=parts[0]]",
"hasTradingForm":"[=parts[1]]",
</#if>
"hasValue":"[=shipment.biomass_sold_by_type_caliber[key][keySold]]"
}<#if keySold?has_next>,</#if></#list>]
   }
   <#if key?has_next>,</#if> </#list>
   ]
}
</#if>
]
}
