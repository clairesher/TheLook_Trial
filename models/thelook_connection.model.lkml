# Define the database connection to be used for this model.
connection: "thelook_connection"

# include all the views
include: "/views/**/*.view.lkml"
include: "/Derived_tables/**/*.view.lkml"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: thelook_connection_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: thelook_connection_default_datagroup

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.



# Use case for predicting dormant customers
explore: users {
  label: "predicting_dormant_customers"
  join: dormant_predictions2 {
    type: inner
    relationship: one_to_one
    sql_on: ${users.id} = ${dormant_predictions2.pred_id} ;;
  }
}

explore: order_items {
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: customer_aggregates {
    view_label: "Users"
    relationship: one_to_one
    sql_on:  ${users.id} = ${customer_aggregates.user_id} ;;
  }
  join: dormant_predictions2 {
    view_label: "Users"
    type: left_outer
    relationship: one_to_one
    sql_on: ${customer_aggregates.user_id} = ${dormant_predictions2.pred_id} ;;
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${order_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.order_id} ;;
    relationship: many_to_one
  }
  join: order_aggregates {
    type: inner
    relationship: one_to_one
    sql_on:  ${orders.order_id} = ${order_aggregates.order_id} ;;
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: distribution_centers {}
