# If necessary, uncomment the line below to include explore_source.
# include: "thelook_connection.model.lkml"
include: "/Derived_tables/**/*.view.lkml"

datagroup: bqml_datagroup  {
  max_cache_age: "24 hours"
  interval_trigger: "5 minutes"
}

############################################# Fit Model #####################################################
view: dormant_model2 {
  derived_table: {
    datagroup_trigger: bqml_datagroup
    sql_create:
      CREATE OR REPLACE MODEL ${SQL_TABLE_NAME}
        OPTIONS(
                model_type='LOGISTIC_REG',

      input_label_cols = ['is_active_customer']
      ) AS
      select *
      from ${train_data.SQL_TABLE_NAME};;
  }
}
view: model_evaluation {
  derived_table: {
    sql: select *
         from ml.evaluate(model ${dormant_model2.SQL_TABLE_NAME},
                          (select * from ${test_data.SQL_TABLE_NAME})
                          );;
  }
  dimension: roc_auc{}
  dimension: log_loss {}

}


############################################# Predict dormant customers #############################################
view: dormant_predictions2 {

  derived_table: {
    datagroup_trigger: bqml_datagroup
    sql:
            SELECT
              *
            FROM ml.PREDICT(
               MODEL ${dormant_model2.SQL_TABLE_NAME},
               (SELECT
                  *
                FROM  ${pred_data.SQL_TABLE_NAME}));;
  }
dimension: predicted_is_active_customer {type: yesno}
 # dimension: predicted_is_active_customer{
#    type: yesno
#    sql: predicted_is_active_customer = 1 ;;
#  }



   dimension: pred_id {
    primary_key: yes
     sql: ${TABLE}.id ;;
   }
 }
