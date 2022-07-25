/****************************************************************************************
  * @filename      : ProductionPlanDeliveryCountUpdate_ba
  * @projectname   :
  * @author        : i2max_my.Seo
  * @date          : 2020-08-18 오전 9:08
  * @group         :
  * @group-content :
  * @description   : 생산계획 - 월별 출하건수 업데이트
  *
  * @tester        : DealerIncentiveCalculate_keep_out_ba_ts.cls
  * @reference     :
  * @copyright     : Copyright © I2max. All Rights Reserved.
  * @modification Log
  * ==================================================================================
  * ver     date             author      description
  * ==================================================================================
  * 1.0     2022-07-03       I2MAX       Create ( ITVOC-2022-06-0861 )
  * 2.0     2022-07-25       I2MAX       UPDATE (ITVOC-2022-07-0906)
****************************************************************************************/
public class ProductionPlanDeliveryCountUpdate_ba implements Database.Batchable<SObject>, Database.Stateful {

    public Date processDate;
    public String query;
    public Boolean isNextBatch;

    public ProductionPlanDeliveryCountUpdate_ba() {
        this(true);
    }

    public ProductionPlanDeliveryCountUpdate_ba(Boolean isNextBatch) {
        this.isNextBatch = isNextBatch;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        if(processDate == null) processDate = Date.today().addDays(-1);

        if(String.isEmpty(query)) {
            return Database.getQueryLocator([
                    SELECT
                            Id,
                            DeliveryCount__c,
                            ProductCode__c,
                            ProductId__c,
                            ProductionPlanDate__c
                    FROM ProductionPlan__c
                    WHERE ProductionPlanDate__c >= :processDate.toStartOfMonth()
                    AND ProductionPlanDate__c <= :processDate.addMonths(1).toStartOfMonth().addDays(-1)
            ]);
        } else {
            return Database.getQueryLocator(query);
        }

    }

    public void execute(Database.BatchableContext BC, List<ProductionPlan__c> scope) {
        Set<String> productCodes = new Set<String>();
        for(ProductionPlan__c r : scope) {
            productCodes.add(r.ProductCode__c);
        }

        List<AggregateResult> orderTargets = [
            SELECT OrderProduct__r.ProductCode productCode, COUNT(Id) deliveryCount
            FROM Order__c
            WHERE Division__c = '공장주문'
            AND ShipmentDate__c >= :processDate.toStartOfMonth()
            AND ShipmentDate__c <= :processDate.addMonths(1).toStartOfMonth().addDays(-1)
            AND OrderProduct__r.ProductCode IN :productCodes
            GROUP BY OrderProduct__r.ProductCode
        ];
        Map<String, Decimal> deliveryCountMap = new Map<String, Decimal>();
        String productCode;
        Decimal deliveryCount;
        for(AggregateResult ar : orderTargets) {
            productCode = (String) ar.get('productCode');
            deliveryCount = (Decimal) ar.get('deliveryCount');
            deliveryCountMap.put(productCode, deliveryCount);
        }

        // 주문건수 구하기.
        List<AggregateResult> orderCountTargets = [
            SELECT OrderProduct__r.ProductCode productCode, COUNT(Id) deliveryCount
            FROM Order__c
            WHERE Division__c = '공장주문'
            AND Status__c != '종료'
            AND isOrderCancel__c = FALSE
            AND VSTEL__c IN ('', 'M')
            AND OrderProduct__r.ProductCode IN :productCodes
            GROUP BY OrderProduct__r.ProductCode
        ];
        Map<String, Decimal> orderCountMap = new Map<String, Decimal>();
        for(AggregateResult ar : orderCountTargets) {
            productCode = (String) ar.get('productCode');
            deliveryCount = (Decimal) ar.get('deliveryCount');
            orderCountMap.put(productCode, deliveryCount);
        }

        for(ProductionPlan__c r : scope) {
            if(deliveryCountMap.containsKey(r.ProductCode__c)) {
                r.DeliveryCount__c = deliveryCountMap.get(r.ProductCode__c);
            } else {
                r.DeliveryCount__c = 0;
            }
            // 주문건수 업데이트 : 종료 안된.
            if(orderCountMap.containsKey(r.ProductCode__c)) {
                r.OrderCount__c = orderCountMap.get(r.ProductCode__c);
            } else {
                r.OrderCount__c = 0;
            }
        }

        update scope;
    }

    public void finish(Database.BatchableContext BC) {

    }

}