Helm Schema Docs
================

## JSON Schema for Humans

https://github.com/coveooss/json-schema-for-humans:

pip install json-schema-for-humans
generate-schema-doc --template-name=md values.schema.json docs/values.md

### Custom Templates

Basieren auf Jinja2

Markdown / Für das Beispiel-Template:

```bash
generate-schema-doc \
  --config template_name=md \
  --config custom_template_path=helm_values_template.md.j2 \
  values.schema.json \
  docs/values.md
```

HTML:

```bash
generate-schema-doc \
  --config custom_template_path=./my_custom_template.html.j2 \
  values.schema.json \
  docs/values.html
```

Beispiel:

```jinja2
# {{ schema.title | default("Helm Values") }}

{{ schema.description | default("") }}

{% if schema | has_properties %}
## Konfiguration

{% for prop in schema.properties_recursive %}
### {{ prop.full_name }}

**Typ:** `{{ prop.type }}`  
**Erforderlich:** {{ prop.required | yesno("Ja", "Nein") }}  
**Default:** `{{ prop.default | tojson }}`

{{ prop.description }}

{% if prop.examples %}
**Beispiele:**
{{ prop.examples | to_yaml }}
{% endif %}

{% if prop.enum %}
Erlaubte Werte: {{ prop.enum | join(", ") }}
{% endif %}

{% endfor %}
{% endif %}
```

## README Generator for Helm

https://github.com/bitnami/readme-generator-for-helm

## Helm Docs

https://github.com/norwoodj/helm-docs

---

