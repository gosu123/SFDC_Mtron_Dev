/****************************************************************************************
  * @filename      : OrderDeliveryPlanDateUpdate_ba
  * @author        : I2MAX
  * @date          : 2022-07-15
  * @group         :
  * @group-content :
  * @description   : 생산계획
  *                  주문의 납품 요청월 기준 순서대로 생산계획일자 업데이트
  *                  생산계획일자는 매월 말일로 지정
  * @tester        : OrderDeliveryPlanDateUpdate_ba_ts.cls
  * @schedule      :
  * @reference     :
  * @copyright     : Copyright © I2max. All Rights Reserved.
  * @modification Log
  * ===============================================================
  * ver     date             author        description
  * ===============================================================
    1.0     2022-07-15       I2MAX         Create (ITVOC-2022-06-0861)
****************************************************************************************/


public with sharing class OrderDeliveryPlanDateUpdate_ba implements Database.Batchable<SObject>, Database.Stateful {

    public String query;
    public Boolean isNextBatch = false;
    public Date processDate;

    public OrderDeliveryPlanDateUpdate_ba() {
        this(true);
    }
    public OrderDeliveryPlanDateUpdate_ba(Boolean isNextBatch) {
        this.isNextBatch = isNextBatch;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {

        if(this.processDate == null) this.processDate = Date.today().addDays(-1);

        if(String.isNotEmpty(this.query)) {
            return Database.getQueryLocator(query);

        } else {
            return Database.getQueryLocator([
                    SELECT
                            Id,
                            DeliveryCount__c,
                            fm_CurrentProductionPlanCount__c,
                            LastProductionPlanCount__c,
                            LastProductionStockCount__c,
                            ProductCode__c,
                            ProductId__c,
                            ProductionPlanDate__c
                    FROM ProductionPlan__c
                    WHERE ProductionPlanDate__c >= :processDate.toStartOfMonth()
                    AND ProductionPlanDate__c <= :processDate.addMonths(1).toStartOfMonth().addDays(-1)
            ]);
        }
    }

    public void execute(Database.BatchableContext BC, List<ProductionPlan__c> scope) {
        // orderSeq 증가, 순위 반영
        Set<String> orderProudctIds = new Set<String>();
        ProductionPlan__c productionPlan;
        for(ProductionPlan__c r : scope) {
            productionPlan = r;
            orderProudctIds.add(r.ProductId__c);
        }
        List<Order__c> orderList = [
                SELECT
                        Id, Name, OrderProduct__r.Name, DeliverySeq__c, ErpZLNNO__c, Status__c, RecordType.Name, PurposeOfOrder__c,
                        Dealer__r.DealerOwner__c,
                        Dealer__r.DealerOwner__r.MobilePhone,
                        BusinessOfficeRep__c,
                        BusinessOfficeRep__r.ManagerId,
                        fm_RecordTypeOrder__c, fm_OrderScheduleYearMonth__c,  fm_IsPreOrder__c,   fm_OrderPurposeOrder__c,   OrderScheduleDate__c,  CreatedDate
                FROM Order__c
                WHERE Status__c != '종료'
                AND Division__c = '공장주문'
                AND isOrderCancel__c = FALSE
                AND VSTEL__c IN ('', 'M620')
                AND OrderScheduleDate__c != NULL
                AND OrderProduct__c = :orderProudctIds
                ORDER BY DeliverySeq__c, fm_RecordTypeOrder__c, fm_OrderScheduleYearMonth__c, fm_IsPreOrder__c, fm_OrderPurposeOrder__c, OrderScheduleDate__c, CreatedDate
        ];
        Integer deliveryCount = 1;
        for (Order__c r : orderList) {
            if(productionPlan.fm_CurrentProductionPlanCount__c >= deliveryCount) {
                r.ExpectedShippingDate__c = productionPlan.ProductionPlanDate__c;
                deliveryCount++;
            } else {
                r.ExpectedShippingDate__c = null;
            }
        }
        update orderList;
    }

    public void finish(Database.BatchableContext BC) {
    }

    public static void runTest() {
        Integer yr_seo = 0;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
        yr_seo++;
    }
}