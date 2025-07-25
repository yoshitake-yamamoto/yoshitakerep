
view: sql_runner_query {
  derived_table: {
    sql: SELECT
          users.id  AS users_id,
          COALESCE(SUM(( 1.10 * order_items.sale_price)), 0) AS LTV,
          COUNT(*) AS order_items_count
      FROM looker-private-demo.ecomm.order_items  AS order_items
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

  dimension: ltv {
    type: number
    sql: ${TABLE}.LTV ;;
  }

  dimension: order_items_count {
    type: number
    sql: ${TABLE}.order_items_count ;;
  }

  set: detail {
    fields: [
        users_id,
	ltv,
	order_items_count
    ]
  }
}
