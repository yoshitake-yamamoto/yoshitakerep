
view: sql_runner_query {
  derived_table: {
    sql: SELECT
          users.id  AS users_id,
          COALESCE(SUM(( 1.10 * order_items.sale_price)), 0) AS order_items_total_sale_price,
          1.0 * ( COALESCE(SUM(((1.10 * order_items.sale_price) - inventory_items.cost) ), 0) )/ nullif(( COALESCE(SUM((1.10 * order_items.sale_price)), 0) ),0)  AS order_items_total_gross_margin_percentage,
          COUNT(*) AS order_items_count
      FROM looker-private-demo.ecomm.order_items  AS order_items
      FULL OUTER JOIN looker-private-demo.ecomm.inventory_items  AS inventory_items ON inventory_items.id = order_items.inventory_item_id
      LEFT JOIN looker-private-demo.ecomm.users  AS users ON order_items.user_id = users.id
      GROUP BY
          1
      ORDER BY
          2 DESC ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: users_id {
    type: number
    sql: ${TABLE}.users_id ;;
  }

  dimension: order_items_total_sale_price {
    type: number
    sql: ${TABLE}.order_items_total_sale_price ;;
  }

  dimension: order_items_total_gross_margin_percentage {
    type: number
    sql: ${TABLE}.order_items_total_gross_margin_percentage ;;
  }

  dimension: order_items_count {
    type: number
    sql: ${TABLE}.order_items_count ;;
  }

  set: detail {
    fields: [
        users_id,
	order_items_total_sale_price,
	order_items_total_gross_margin_percentage,
	order_items_count
    ]
  }
}
