/****************************************************************************************
 * @filename      : ProductionPlan_tr_ts
 * @projectname   :
 * @author        : SEOKHO LEE
 * @date          : 2020-07-21 오전 10:22
 * @group         :
 * @group-content :
 * @description   : 생산계획_트리거
 * @tester        :
 * @reference     :
 * @copyright     : Copyright © I2max. All Rights Reserved.
 * @modification Log
 * ===============================================================
 * ver     date                     author              description
 * ===============================================================
 0.1     2020-07-21 오전 10:22        SEOKHO LEE          Create
 ****************************************************************************************/

@IsTest
private class ProductionPlan_tr_ts {
    @isTest
    static void testBehavior() {

        Product2 p = TestDataProductFactory.baseProduct2.clone();
        p.ProductCode = '000000000012345678';
        insert p;

        ProductionPlan__c pp = new ProductionPlan__c();
        pp.ProductCode__c = '12345678';
        pp.ProductionPlanDate__c = Date.today();
        pp.LastProductionPlanCount__c = 1;
        pp.LastProductionStockCount__c = 1;
        insert pp;

        pp.LastProductionPlanCount__c = 2;
        update pp;
    }
}