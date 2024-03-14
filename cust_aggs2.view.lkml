
view: cust_aggs2 {
  derived_table: {
    sql: SELECT
          users.id  AS users_id,
          COUNT(DISTINCT orders.order_id ) AS orders_count,
          COALESCE(SUM(order_items.sale_price ), 0) AS order_items_total_sale_price
      FROM `TheLook_Copy3.order_items`  AS order_items
      LEFT JOIN `TheLook_Copy3.users`  AS users ON order_items.user_id = users.id
      LEFT JOIN `TheLook_Copy3.orders`  AS orders ON order_items.order_id = orders.order_id
      GROUP BY
          1
      ORDER BY
          2 DESC
      LIMIT 500 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: users_id {
    type: number
    sql: ${TABLE}.users_id ;;
  }

  dimension: orders_count {
    type: number
    sql: ${TABLE}.orders_count ;;
  }

  dimension: order_items_total_sale_price {
    type: number
    sql: ${TABLE}.order_items_total_sale_price ;;
  }

  set: detail {
    fields: [
        users_id,
	orders_count,
	order_items_total_sale_price
    ]
  }
}
