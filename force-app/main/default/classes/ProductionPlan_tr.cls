/****************************************************************************************
 * @filename      : ProductionPlan_tr
 * @projectname   :
 * @author        : SEOKHO LEE
 * @date          : 2022-07-08 오전 10:22
 * @group         :
 * @group-content :
 * @description   : 생산계획 트리거 테스트 클래스
 * @tester        :
 * @reference     :
 * @copyright     : Copyright © I2max. All Rights Reserved.
 * @modification Log
 * ===============================================================
 * ver     date                     author              description
 * ===============================================================
 0.1     2022-07-08 오전 10:22       I2MAX               Create
 ****************************************************************************************/

public with sharing class ProductionPlan_tr extends TriggerHandler{

    //-------------------------------------------------------
    // override methods
    //-------------------------------------------------------
    public override void beforeInsert() {
        setProductSync();
    }

    public override void beforeUpdate() {
        setProductSync();
    }

    /**
     * 생산 계획 업로드 건에 대한 제품 Lookup 싱크
     */
    private static void setProductSync() {
        List<ProductionPlan__c> newList = (List<ProductionPlan__c>) Trigger.new;
        Set<String> productCodes = new Set<String>();
        for(ProductionPlan__c r : newList) {
            r.ProductCode__c = Dummy_IF_BatchUtil.getProductCodeLpad(r.ProductCode__c);
            productCodes.add(r.ProductCode__c);
        }
        Map<String, Product2> product2Map = new Map<String, Product2>();
        for(Product2 p : [
            SELECT Id, ProductCode FROM Product2 WHERE ProductCode IN :productCodes
        ]) {
            product2Map.put(p.ProductCode, p);
        }
        for(ProductionPlan__c r : newList) {
            // 매월 말일 지정
            r.ProductionPlanDate__c = r.ProductionPlanDate__c.addMonths(1).toStartOfMonth().addDays(-1);
            // 제품 개체 연결
            if(product2Map.containsKey(r.ProductCode__c)) r.ProductId__c = product2Map.get(r.ProductCode__c).Id;
        }
    }
}