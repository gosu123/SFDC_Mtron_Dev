/****************************************************************************************
 * @filename      : ProductionPlanDeliveryCountUpdate_ba_ts
 * @projectname   :
 * @author        : I2MAX
 * @date          : 2022-07-13 오전 9:51
 * @group         :
 * @group-content :
 * @description   : 생산계획 - 당월 출하건수 업데이트 (ITVOC-2022-06-0861)
 * @tester        :
 * @reference     :
 * @copyright     : Copyright © I2max. All Rights Reserved.
 * @modification Log
 * ===============================================================
 * ver     date           author              description
 * ===============================================================
 1.0     2022-07-03       I2MAx               Create ( ITVOC-2022-06-0861 )
 ****************************************************************************************/

@isTest
private class ProductionPlanDeliveryCountUpdate_ba_ts {
    @isTest
    static void testBehavior() {
        Order__c order = TestDataSalesFactory.orderForPerFarCorp.clone(false,true);
        order.ExpectedShippingDate__c = Date.today();
        insert order;

        ProductionPlan__c pp = new ProductionPlan__c();
        pp.ProductCode__c = '00000001';
        pp.ProductionPlanDate__c = Date.today();
        pp.LastProductionPlanCount__c = 1;
        pp.LastProductionStockCount__c = 1;
        insert pp;

        Database.executeBatch(new ProductionPlanDeliveryCountUpdate_ba(), 1);
    }
}