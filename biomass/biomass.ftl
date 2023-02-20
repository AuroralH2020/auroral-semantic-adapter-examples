<#assign jpath=handlers("JsonHandler")>
<#assign biomass="{ \"method\" : \"GET\", \"url\" : \"https://yourapi.com/\"}">
<#assign biomassRequest=providers("HttpProvider", biomass)>

[
<#list jpath.filter("$.[*]",biomassRequest) as fragment>
{
    "@context" : "https://auroralh2020.github.io/auroral-ontology-contexts/biomass/catalogue.json",
    "id" : "[=jpath.filter("$.uuid",fragment)]",
    "name" : "[=jpath.filter("$.name",fragment)]",
    <#if jpath.filter("$.trading_form",fragment)?has_content>
    "tradingForm" : "[=jpath.filter("$.trading_form",fragment)]",
    </#if>
    <#if jpath.filter("$.trading_form",fragment)?has_content>
    "dimension" : "[=jpath.filter("$.dimensions_class",fragment)]",
    </#if>
    <#if jpath.filter("$.trading_form",fragment)?has_content>
    "primaryEnergyCost" : "[=jpath.filter("$.primary_energy_cost",fragment)]",
    </#if>
    <#if jpath.filter("$.trading_form",fragment)?has_content>
    "primaeryEnergyCostObs" : "[=jpath.filter("$.primary_energy_cost_obs",fragment)]",
    </#if>
    <#if jpath.filter("$.trading_form",fragment)?has_content>
    "pciKwhPerKg" : "[=jpath.filter("$.pci_kwh_per_kg",fragment)]",
    </#if>
    <#if jpath.filter("$.trading_form",fragment)?has_content>
    "pcimjPerKg" : "[=jpath.filter("$.pci_mj_per_kg",fragment)]",
    </#if>
    "humidity" : {
        "id":"[=jpath.filter("$.humidity_class.uuid",fragment)]",
        "name":"[=jpath.filter("$.humidity_class.name",fragment)]",
        "description":"[=jpath.filter("$.humidity_class.description",fragment)]"
    },
    "aches" : {
        "id":"[=jpath.filter("$.ashes_class.uuid",fragment)]",
        "name":"[=jpath.filter("$.ashes_class.name",fragment)]",
        "description":"[=jpath.filter("$.ashes_class.description",fragment)]"
    },
    "origin" : {
        "id":"[=jpath.filter("$.biomass_origin.uuid",fragment)]"<#if jpath.filter("$.trading_form",fragment)?has_content>,
        "description":"[=jpath.filter("$.biomass_origin.description",fragment)]"
        </#if>
    },
    "group" : {
        "@type":"[=jpath.filter("$.biomass_origin.group_name",fragment)?replace(" ", "")?replace(",", "")]",
        "id":"[=jpath.filter("$.biomass_origin.group_id",fragment)]",
        "name":"[=jpath.filter("$.biomass_origin.group_name",fragment)]",
        "description":"[=jpath.filter("$.biomass_origin.group_description",fragment)]"
    },
    "subgroup":{
        "@type":"[=jpath.filter("$.biomass_origin.subgroup_name",fragment)?replace(" ", "")?replace(",", "")]",
        "id":"[=jpath.filter("$.biomass_origin.subgroup_id",fragment)]",
        "name":"[=jpath.filter("$.biomass_origin.subgroup_name",fragment)]",
        "description":"[=jpath.filter("$.biomass_origin.subgroup_description",fragment)]"
    },
    "type":{
        "@type":"[=jpath.filter("$.biomass_origin.type_name",fragment)?replace(" ", "")?replace(",", "")]",
        "id":"[=jpath.filter("$.biomass_origin.type_id",fragment)]",
        "name":"[=jpath.filter("$.biomass_origin.type_name",fragment)]",
        "description":"[=jpath.filter("$.biomass_origin.type_description",fragment)]"
    },
    "subtype":{
        "@type":"[=jpath.filter("$.biomass_origin.subtype_name",fragment)?replace(" ", "")?replace(",", "")]",
        "id":"[=jpath.filter("$.biomass_origin.subtype_id",fragment)]",
        "name":"[=jpath.filter("$.biomass_origin.subtype_name",fragment)]",
        "description":"[=jpath.filter("$.biomass_origin.subtype_description",fragment)]"
    }
}
<#if fragment?is_last><#else>,</#if>
</#list>
]
