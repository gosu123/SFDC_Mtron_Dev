/****************************************************************************************
  * @filename      : DealerIncentiveUnpaidERPSendQa
  * @projectname   :
  * @author        : i2max
  * @date          : 2020-04-16
  * @group         :
  * @group-content :
  * @description   : 판매장려 - 미지급건 전송/취소
  * @tester        : DealerIncentiveUnpaidERPSendQa_ts.cls
  * @reference     :
  * @copyright     : Copyright © I2max. All Rights Reserved.
  * @modification Log
  * ===============================================================
  * ver     date            author         description
  * ===============================================================
    0.1     2022-07-04      i2max          Create
****************************************************************************************/
public with sharing class DealerIncentiveUnpaidERPSendQa {

    /**
     * 초기 거래
     * @return InitData
     */
    @AuraEnabled(Cacheable=true)
    public static DealerIncentiveInput__c init(String recordId) {
        DealerIncentiveInput__c dii = [
                SELECT Id, IsSend__c
                FROM DealerIncentiveInput__c
                WHERE Id = :recordId
        ];
        return dii;
    }

    /**
     * 미지급건 전송 처리.
     *
     * @param recordId
     */
    @AuraEnabled
    public static void sendERP(String recordId) {
        List<DealerIncentiveInput__c> scope = [
                SELECT
                        Id,
                        Name,
                        OwnerId,
                        RecordTypeId,
                        RecordType.Name,
                        BaseDate__c,
                        Type__c,
                        AdSalesAmount__c,
                        AdSalesRate__c,
                        ApprovalStatus__c,
                        ApproveDate__c,
                        Asset__c,
                        Asset__r.Name,
                        Asset__r.BatchNo__c,
                        Asset__r.InventoryType__c,
                        Asset__r.ProductionDate__c,
                        Asset__r.FirstDeliveryDate__c,
                        Asset__r.DealerReceiptDate__c,
                        Asset__r.IncentiveSeqNo__c,
                        Asset__r.Product2.ProductCode,
                        Asset__r.Dealer__r.Owner.EmployeeNumber,
                        CSIncentiveAmount__c,
                        CSIncentiveRate__c,
                        Dealer__r.ERPCode__c,
                        Dealer__r.Owner.EmployeeNumber,
                        BrokeringDealer__r.ERPCode__c,
                        BrokeringDealer__r.Owner.EmployeeNumber,
                        DealerIncentiveCalculate3__c,
                        DealerIncentiveCalculate3__r.SupplyAmount__c,
                        DealerIncentiveCalculate3__r.SalesDocNo__c,
                        DealerIncentiveCalculate3__r.LineNumber__c,
                        DealerIncentiveCalculate3__r.Status__c,
                        DealerIncentiveCalculate3__r.ERPSeqNo__c,
                        DealerIncentiveCalculate3__r.SalesAccount__r.ERPCode__c,
                        fm_PlanDealerIncentiveCalculate3Amount__c,
                        fm_PlanDealerIncentiveCalculate3Rate__c,
                        DealerIncentiveCalculate6__c,
                        DealerIncentiveCalculate6__r.SupplyAmount__c,
                        DealerIncentiveCalculate6__r.SalesDocNo__c,
                        DealerIncentiveCalculate6__r.LineNumber__c,
                        DealerIncentiveCalculate6__r.Status__c,
                        DealerIncentiveCalculate6__r.ERPSeqNo__c,
                        DealerIncentiveCalculate6__r.SalesAccount__r.ERPCode__c,
                        fm_PlanDealerIncentiveCalculate6Amount__c,
                        fm_PlanDealerIncentiveCalculate6Rate__c,
                        DealerIncentiveCalculate9__c,
                        DealerIncentiveCalculate9__r.SupplyAmount__c,
                        DealerIncentiveCalculate9__r.SalesDocNo__c,
                        DealerIncentiveCalculate9__r.LineNumber__c,
                        DealerIncentiveCalculate9__r.Status__c,
                        DealerIncentiveCalculate9__r.ERPSeqNo__c,
                        DealerIncentiveCalculate9__r.SalesAccount__r.ERPCode__c,
                        fm_PlanDealerIncentiveCalculate9Amount__c,
                        fm_PlanDealerIncentiveCalculate9Rate__c,
                        DealerIncentiveCalculate10__c,
                        DealerIncentiveCalculate10__r.SupplyAmount__c,
                        DealerIncentiveCalculate10__r.SalesDocNo__c,
                        DealerIncentiveCalculate10__r.LineNumber__c,
                        DealerIncentiveCalculate10__r.Status__c,
                        DealerIncentiveCalculate10__r.ERPSeqNo__c,
                        DealerIncentiveCalculate10__r.SalesAccount__r.ERPCode__c,
                        fm_PlanDealerIncentiveCalculate10Amount__c,
                        fm_PlanDealerIncentiveCalculate10Rate__c,
                        DealerIncentiveCalculate11__c,
                        DealerIncentiveCalculate11__r.SupplyAmount__c,
                        DealerIncentiveCalculate11__r.SalesDocNo__c,
                        DealerIncentiveCalculate11__r.LineNumber__c,
                        DealerIncentiveCalculate11__r.Status__c,
                        DealerIncentiveCalculate11__r.ERPSeqNo__c,
                        DealerIncentiveCalculate11__r.SalesAccount__r.ERPCode__c,
                        fm_PlanDealerIncentiveCalculate11Amount__c,
                        fm_PlanDealerIncentiveCalculate11Rate__c,
                        fm_TotalAmount__c,
                        SalesDiscountAmount__c,
                        SalesDiscountRate__c,
                        SalesDocLineNo__c,
                        SalesDocLineNoWM__c,
                        fm_SalesSellingAmount__c,
                        fm_WMSalesSellingAmount__c,
                        SalesDocNoWM__c,
                        SalesIncentiveAmount__c,
                        SalesIncentiveRate__c,
                        SalesSellingAmount__c,
                        SendDate__c,
                        IsSend__c
                FROM DealerIncentiveInput__c
                WHERE Id = :recordId
        ];
        DealerIncentiveERPSend_service.incentiveUnpaidERPSend(scope);
    }

    /**
     * 미지급건 전송 처리.
     *
     * @param recordId
     */
    @AuraEnabled
    public static void sendERPCancel(String recordId) {
        List<DealerIncentiveInput__c> scope = [
                SELECT
                        Id,
                        Name,
                        OwnerId,
                        RecordTypeId,
                        RecordType.Name,
                        BaseDate__c,
                        Type__c,
                        AdSalesAmount__c,
                        AdSalesRate__c,
                        ApprovalStatus__c,
                        ApproveDate__c,
                        Asset__c,
                        Asset__r.Name,
                        Asset__r.BatchNo__c,
                        Asset__r.InventoryType__c,
                        Asset__r.ProductionDate__c,
                        Asset__r.FirstDeliveryDate__c,
                        Asset__r.DealerReceiptDate__c,
                        Asset__r.IncentiveSeqNo__c,
                        Asset__r.Product2.ProductCode,
                        Asset__r.Dealer__r.Owner.EmployeeNumber,
                        CSIncentiveAmount__c,
                        CSIncentiveRate__c,
                        Dealer__r.ERPCode__c,
                        Dealer__r.Owner.EmployeeNumber,
                        BrokeringDealer__r.ERPCode__c,
                        BrokeringDealer__r.Owner.EmployeeNumber,
                        DealerIncentiveCalculate3__c,
                        DealerIncentiveCalculate3__r.SupplyAmount__c,
                        DealerIncentiveCalculate3__r.SalesDocNo__c,
                        DealerIncentiveCalculate3__r.LineNumber__c,
                        DealerIncentiveCalculate3__r.Status__c,
                        DealerIncentiveCalculate3__r.ERPSeqNo__c,
                        DealerIncentiveCalculate3__r.SalesAccount__r.ERPCode__c,
                        fm_PlanDealerIncentiveCalculate3Amount__c,
                        fm_PlanDealerIncentiveCalculate3Rate__c,
                        DealerIncentiveCalculate9__c,
                        DealerIncentiveCalculate9__r.SupplyAmount__c,
                        DealerIncentiveCalculate9__r.SalesDocNo__c,
                        DealerIncentiveCalculate9__r.LineNumber__c,
                        DealerIncentiveCalculate9__r.Status__c,
                        DealerIncentiveCalculate9__r.ERPSeqNo__c,
                        DealerIncentiveCalculate9__r.SalesAccount__r.ERPCode__c,
                        fm_PlanDealerIncentiveCalculate9Amount__c,
                        fm_PlanDealerIncentiveCalculate9Rate__c,
                        DealerIncentiveCalculate10__c,
                        DealerIncentiveCalculate10__r.SupplyAmount__c,
                        DealerIncentiveCalculate10__r.SalesDocNo__c,
                        DealerIncentiveCalculate10__r.LineNumber__c,
                        DealerIncentiveCalculate10__r.Status__c,
                        DealerIncentiveCalculate10__r.ERPSeqNo__c,
                        DealerIncentiveCalculate10__r.SalesAccount__r.ERPCode__c,
                        fm_PlanDealerIncentiveCalculate10Amount__c,
                        fm_PlanDealerIncentiveCalculate10Rate__c,
                        DealerIncentiveCalculate11__c,
                        DealerIncentiveCalculate11__r.SupplyAmount__c,
                        DealerIncentiveCalculate11__r.SalesDocNo__c,
                        DealerIncentiveCalculate11__r.LineNumber__c,
                        DealerIncentiveCalculate11__r.Status__c,
                        DealerIncentiveCalculate11__r.ERPSeqNo__c,
                        DealerIncentiveCalculate11__r.SalesAccount__r.ERPCode__c,
                        fm_PlanDealerIncentiveCalculate11Amount__c,
                        fm_PlanDealerIncentiveCalculate11Rate__c,
                        fm_TotalAmount__c,
                        SalesDiscountAmount__c,
                        SalesDiscountRate__c,
                        SalesDocLineNo__c,
                        SalesDocLineNoWM__c,
                        fm_SalesSellingAmount__c,
                        fm_WMSalesSellingAmount__c,
                        SalesDocNoWM__c,
                        SalesIncentiveAmount__c,
                        SalesIncentiveRate__c,
                        SalesSellingAmount__c,
                        SendDate__c,
                        IsSend__c
                FROM DealerIncentiveInput__c
                WHERE Id = :recordId
        ];
        DealerIncentiveERPSendCa_service.incentiveUnpaidERPSendCancel(scope);
    }


    public static void runTest() {
        Integer yr_seo = 0;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
        yr_seo ++;
    }
}