project_name: "thelook_connection"

# # Use local_dependency: To enable referencing of another project
# # on this instance with include: statements
#
# local_dependency: {
#   project: "name_of_other_project"
# }
application: explore_assistant_cloudfunc {
  label: "Cloud function deployment of luka github for explore assistant"
  entitlements: {
    core_api_methods: ["lookml_model_explore", "run_inline_query"]
    navigation: yes
    use_embeds: yes
    use_iframes: yes
    new_window: yes
    new_window_external_urls: ["https://developers.generativeai.google/*"]
    local_storage: yes
    external_api_urls: ["https://europe-west4-thelooktrialclaire.cloudfunctions.net/explore-assistant-endpoint-prod"]


  }
}
