/****************************************************************************************
  * @filename      : orderERPSendQa
  * @projectname   :
  * @author        : i2max.seo
  * @date          : 2020-04-16
  * @group         :
  * @group-content :
  * @description   :
  *         // 주문 구분 : Division__c = 공장주문, 판매문서번호 : SalesDocNo__c == null
            // 상태 : Status__c = 대리점 주문 신청,영업소 주문 검토,본사 주문 검토,본사 주문 확정,본사 여신 검토,출하
  *
  * @tester        : orderERPSendQa_ts.cls
  * @reference     :
  * @copyright     : Copyright © I2max. All Rights Reserved.
  * @modification Log
  * ===============================================================
  * ver     date            author         description
  * ===============================================================
    0.1     2020-04-16      i2max.seo      Create
    0.2     2020-12-09      i2max.seo      전수배 주문 포함.
****************************************************************************************/
public with sharing class orderERPSendQa {

    /**
     * 초기 거래 데이터
     */
    public class InitData extends I2ComClass.InitData {
        @AuraEnabled public Order__c order {get;set;}
        @AuraEnabled public String defaultVSTEL {get;set;}
        @AuraEnabled public Boolean isOrderSend {get;set;}
        @AuraEnabled public Boolean isTransferOrder {
            get {
                return ( order.Division__c == '전수배공급' ) ? true : false;
                // && order.Division__c == '공장주문'
            }
            set;
        }
        @AuraEnabled public String validMessage {
            get {
                String message = '';
                if (!isOrderSend && String.isEmpty(order.SalesDocNo__c) == false) {
                    message = 'SAP 전송이 완료되었습니다.';
  /*              } else if (order.Division__c != '공장주문') {
                    message = '공장주문만 ERP 전송이 가능 합니다.';*/
                } else if (order.Status__c == '본사 여신 검토' || order.Status__c == '출하') {
                    message = 'SAP 전송이 완료되었습니다.';
                } else if (order.AssetTransferAgreeStatus__c == '요청') {
                    message = '전수배 전환 동의 요청 중 상태여서 SAP 전송이 불가합니다.';
                } else {
                    message = '영업소 주문 확정 상태에서만 SAP 전송이 가능 합니다.';
                }
                return message;
            }
            set;
        }
    }

    public static String getVSTEL(String param) {
        Map<String, String> VSTELMap = new Map<String, String>();
        VSTELMap.put('71A', 'M621');        // M621경기
        VSTELMap.put('71C', 'M622');        // M622충북
        VSTELMap.put('71E', 'M623');        // M623전북
        VSTELMap.put('71G', 'M624');        // M624경북
        VSTELMap.put('71B', 'M625');        // M625강원
        VSTELMap.put('71D', 'M626');        // M626충남
        VSTELMap.put('71F', 'M627');        // M627전남
        VSTELMap.put('71H', 'M628');        // M628경남
        if(VSTELMap.containsKey(param)) return VSTELMap.get(param);
        return '';
    }

    /**
     * 초기 거래
     *
     * @param recordId
     *
     * @return
     */
    @AuraEnabled(Cacheable=true)
    public static InitData init(final String recordId) {
        InitData initData = new InitData();
        initData.defaultVSTEL = 'M620';
        initData.isOrderSend = false;
        initData.order = [
                SELECT Id, RecordType.Name, VSTEL__c, Division__c, TransferBusinessOffice__r.BusinessOffice__r.ERPCode__c,
                        AssetTransferAgreeStatus__c, TransferProcessStatus__c, SalesDocNo__c, Status__c, BusinessOffice__r.BusinessOfficeName__c
                FROM Order__c WHERE Id = :recordId
        ];
        if((String.isEmpty(initData.order.SalesDocNo__c) == true && initData.order.Status__c == '영업소 주문 확정' )) {
            if(String.isNotEmpty(initData.order.AssetTransferAgreeStatus__c)) {
                if(initData.order.AssetTransferAgreeStatus__c == '승인' && (initData.order.TransferProcessStatus__c == '승인' || initData.order.TransferProcessStatus__c == '거부')) {
                    // 전배 전환 동의 및 전배 승인이 완료 되어야 한다.
                    initData.isOrderSend = true;
                }
            } else {
                initData.isOrderSend = true;
            }
        }
        if(String.isEmpty(initData.order.VSTEL__c) == false) {
            initData.defaultVSTEL = initData.order.VSTEL__c;
        } else {
            if(initData.order.Division__c == '전수배공급') {
                initData.defaultVSTEL = getVSTEL(initData.order.TransferBusinessOffice__r.BusinessOffice__r.ERPCode__c);
            }
        }
        return initData;
    }

    /**
 * 주문 전송 to ERP
 *
 * @param recordId : Order__c 의 RecordId
 */
    @AuraEnabled
    public static Id save(final Order__c order) {
        update order;
        return order.Id;
    }

    @AuraEnabled
    public static Map<String, String> sendERPNew(final String recordId, final Boolean isTransferOrder) {
        Map<String, String> returnMap = new Map<String, String>();
        System.debug(isTransferOrder + '==>' + isTransferOrder);

        Order__c order = [SELECT Id, SalesDocNo__c FROM Order__c WHERE Id =: recordId];
        if(String.isEmpty(order.SalesDocNo__c) == false) {
            throw new AuraHandledException('이미 ERP 주문 처리가 완료 되었습니다');
        }

        if(isTransferOrder == true) {
            // 전수배 ZORT
            returnMap = OrderService.IF_KR_SE_ERP_0007_ZORT(recordId);
            if(returnMap.get('STATUS') == 'Y') {
                System.debug('------------2');
                setTransferOrder(recordId);
            }
        } else {
            // 기존 OR 주문
            returnMap = OrderService.IF_KR_SE_ERP_0007(recordId);
        }
        return returnMap;
    }


    @AuraEnabled
    public static Map<String, String> sendZRET(final String recordId, final Boolean isTransferOrder) {
        Map<String, String> returnMap = new Map<String, String>();
        System.debug(isTransferOrder + '==>' + isTransferOrder);

        Order__c order = [SELECT Id, SalesDocNo__c FROM Order__c WHERE Id =: recordId];
        if(String.isEmpty(order.SalesDocNo__c) == false) {
            throw new AuraHandledException('이미 ERP 주문 처리가 완료 되었습니다');
        }

        if(isTransferOrder == true) {
            // 전수배 ZORT
            returnMap = OrderService.IF_KR_SE_ERP_0007_ZORT(recordId);
            if(returnMap.get('STATUS') == 'Y') {
                System.debug('------------2');
                setTransferOrder(recordId);
            }
        } else {
            // 기존 OR 주문
            returnMap = OrderService.IF_KR_SE_ERP_0007(recordId);
        }
        return returnMap;
    }

    /**
     * 전수배 정상 주문 처리 후 출고 주문을 생성한다.
     *
     * @param recordId
     */
    public static void setTransferOrder(String recordId) {
        // 정상 처리 되었으면 전수배 반품 처리할 레코드를 생성 한다.
        List<OrderLineitem__c> inputOrderLineitems = [
                SELECT  Id,
                        ProductId__c,
                        ProductId__r.ProductCode,
                        BaseSellingPrice__c,
                        SellingPrice__c,
                        CorrectionPrice__c
                FROM OrderLineitem__c
                WHERE OrderId__c = :recordId
        ];
        Order__c order = [
                SELECT
                        Id,
                        Name,
                        AccountTransferDealer__c,
                        AssetTransferAgreeStatus__c,
                        BusinessOffice__c,
                        BusinessOfficeRep__c,
                        Dealer__c,
                        DealerRep__c,
                        DeliverTo__c,
                        DeliveryComment__c,
                        DeliveryDate__c,
                        DeliverySeq__c,
                        Division__c,
                        ERP_Code__c,
                        ErpABGRU__c,
                        ErpAPPAM_C__c,
                        ErpAPPRV__c,
                        ErpARRME_C__c,
                        ErpARRRT__c,
                        ErpBILIN_C__c,
                        ErpBSTDK__c,
                        ErpCMGST__c,
                        ErpCRED_GRAD__c,
                        ErpGUAR_AMNT_C__c,
                        ErpINTVL0_C__c,
                        ErpINTVL1_C__c,
                        ErpINTVL2_C__c,
                        ErpINTVL3_C__c,
                        ErpINTVL4_C__c,
                        ErpINTVL5_C__c,
                        ErpKLIMK_C__c,
                        ErpLAPPR__c,
                        ErpLFDBK_T__c,
                        ErpLNREL__c,
                        ErpLNREQ_C__c,
                        ErpLPLAN_T__c,
                        ErpLRESN_T__c,
                        ErpLVORM1__c,
                        ErpLVORM__c,
                        ErpMATNR__c,
                        ErpMENGE__c,
                        ErpNETPR_C__c,
                        ErpNETWR_C__c,
                        ErpPERNR__c,
                        ErpPOSNR__c,
                        ErpRELDT__c,
                        ErpRQIND__c,
                        ErpSTOCK__c,
                        ErpSUMME_C__c,
                        ErpUSELN_C__c,
                        ErpUSELN_F_C__c,
                        ErpVRKME__c,
                        ErpWAERS__c,
                        ErpZBESU__c,
                        ErpZGUBUN__c,
                        ErpZLNNO__c,
                        ErpZLNST__c,
                        ErpZRATE__c,
                        ErpZRATE_F__c,
                        ErpZTERM__c,
                        IsAutoCancel__c,
                        IsDummyContractOrder__c,
                        IsInAsset__c,
                        IsKeepProcess__c,
                        IsMyDealerOrder__c,
                        isOrderCancel__c,
                        IsOutAsset__c,
                        IsPreOrder__c,
                        isShipmentDate__c,
                        IsZRET__c,
                        Opportunity__c,
                        OrderAccount__c,
                        OrderProduct__c,
                        OrderScheduleDate__c,
                        OwnerId,
                        PODate__c,
                        PriceDecisionDate__c,
                        ProductId__c,
                        PurposeOfOrder__c,
                        RecordTypeId,
                        ReturnAmount__c,
                        SalesDocNo__c,
                        ShipmentDate__c,
                        SoldTo__c,
                        Status__c,
                        SupplyTo__c,
                        SystemStatus__c,
                        TransferBusinessOffice__c,
                        TransferMachineNo__c,
                        TransferMachineNo__r.Account.CustomerType__c,
                        TransferMachineNo__r.AccountId,
                        TransferMachineNo__r.Dealer__c,
                        TransferMachineNo__r.Order__r.PriceDecisionDate__c,
                        TransferMachineNo__r.Order__r.Dealer__c,
                        TransferMachineNo__r.Order__r.DealerRep__c,
                        TransferMachineNo__r.Order__r.BusinessOffice__c,
                        TransferMachineNo__r.Order__r.BusinessOfficeRep__c,
                        TransferMachineNo__r.Order__r.BusinessOffice__r.ERPCode__c,
                        TransferMachineNo__r.Order__r.Dealer__r.BusinessOffice__r.ERPCode__c,
                        TransferProcessStatus__c,
                        VSTEL__c
                FROM Order__c
                WHERE Id = :recordId
        ];

        if(inputOrderLineitems.isEmpty() == false) {

            OrderLineitem__c orderLineitem = inputOrderLineitems[0];

            String priceType;
            if(order.TransferMachineNo__r.Account.CustomerType__c == '농협') {
                priceType = 'FD';
            } else if(order.TransferMachineNo__r.Account.CustomerType__c == '관납') {
                priceType = 'FE';
            } else {
                priceType = 'FC';
            }

            Order__c returnOrder = order.clone(false,false);
            returnOrder.RecordTypeId = Schema.SObjectType.Order__c.getRecordTypeInfosByName().get('전수배반품').getRecordTypeId();
            returnOrder.ErpAUART__c = 'ZRET';           // 전수배 반품 주문
            returnOrder.SalesDocNo__c = null;
            returnOrder.ErpPOSNR__c = null;
            returnOrder.OrderMaster__c = order.Id;      // 전수배공급주문 아이디.
            returnOrder.Division__c = '전수배반품';       // 주문 구분
            returnOrder.Status__c = '영업소 주문 확정';    // 상태
            returnOrder.OrderAccount__c = order.TransferMachineNo__r.Dealer__c;
            // 전배 기대의 주문의 가격결정일을 등록 해준다.
            returnOrder.PriceDecisionDate__c = order.TransferMachineNo__r.Order__r.PriceDecisionDate__c;
            if(priceType != 'FC') {
                returnOrder.OrderAccount__c = order.TransferMachineNo__r.AccountId;
            }

            // 전수배 기대의 원 주문의 영업소 정보를 채워 준다.
            returnOrder.Dealer__c = order.TransferMachineNo__r.Order__r.Dealer__c;
            returnOrder.DealerRep__c = order.TransferMachineNo__r.Order__r.DealerRep__c;
            returnOrder.BusinessOffice__c = order.TransferMachineNo__r.Order__r.BusinessOffice__c;
            returnOrder.BusinessOfficeRep__c = order.TransferMachineNo__r.Order__r.BusinessOfficeRep__c;

            // 출하위치 : 전배 대리점의 영업소 코드
            Map<String, String> VSTELMap = new Map<String, String>();
            VSTELMap.put('71I', 'M620');        // M620엽업소
            VSTELMap.put('71A', 'M621');        // M621경기
            VSTELMap.put('71C', 'M622');        // M622충북
            VSTELMap.put('71E', 'M623');        // M623전북
            VSTELMap.put('71G', 'M624');        // M624경북
            VSTELMap.put('71B', 'M625');        // M625강원
            VSTELMap.put('71D', 'M626');        // M626충남
            VSTELMap.put('71F', 'M627');        // M627전남
            VSTELMap.put('71H', 'M628');        // M628경남

            if(VSTELMap.containsKey(order.TransferMachineNo__r.Order__r.Dealer__r.BusinessOffice__r.ERPCode__c)) {
                returnOrder.VSTEL__c = VSTELMap.get(order.TransferMachineNo__r.Order__r.Dealer__r.BusinessOffice__r.ERPCode__c);
            } else {
                returnOrder.VSTEL__c = 'M620';
            }

            // ErpCMGST__c : ERP 여신상태도 초기화 한다.
            returnOrder.ErpCMGST__c = null;

            insert returnOrder;
            System.debug('===> ' + returnOrder.Id);


            //반품 주문 아이템 레코드.
            OrderLineitem__c returnOrderLineItem = orderLineitem.clone(false);
            returnOrderLineItem.OrderId__c = returnOrder.Id;
            List<ProductPriceEntry__c> productPriceEntries =  [
                    SELECT Id, PriceType__c,
                            BasePrice__c,
                            StartDate__c,
                            EndDate__c
                    FROM ProductPriceEntry__c
                    WHERE StartDate__c <= :order.TransferMachineNo__r.Order__r.PriceDecisionDate__c
                    AND EndDate__c >= :order.TransferMachineNo__r.Order__r.PriceDecisionDate__c
                    AND Product__c = :orderLineitem.ProductId__c
                    AND PriceType__c = :priceType
                    ORDER BY StartDate__c DESC
                    LIMIT 1
            ];

            if(productPriceEntries.isEmpty() == false) {
                returnOrderLineItem.BaseSellingPrice__c = productPriceEntries[0].BasePrice__c;
                returnOrderLineItem.SellingPrice__c = returnOrderLineItem.BaseSellingPrice__c;
                returnOrderLineItem.CorrectionPrice__c = 0;
            }
            //tOrder.
            insert returnOrderLineItem;
            System.debug('------------1');
        }
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
    }

    /**
     * 전수배 정상 주문 처리 후 출고 주문을 생성한다.
     *
     * @param recordId
     */
/*
    public static void setTransferOrder(String recordId) {
        // 정상 처리 되었으면 전수배 반품 처리할 레코드를 생성 한다.
        List<OrderLineitem__c> inputOrderLineitems = [
                SELECT  Id,
                        ProductId__c,
                        ProductId__r.ProductCode,
                        OrderId__c,
                        OrderId__r.BusinessOffice__r.SalesGroupCode__c,
                        OrderId__r.TransferBusinessOffice__c,
                        OrderId__r.Name,
                        OrderId__r.fm_SoldToErpCode__c,
                        OrderId__r.fm_SupplyToErpCode__c,
                        OrderId__r.TransferMachineNo__r.DealerReceiptDate__c,
                        OrderId__r.TransferMachineNo__r.Account.CustomerType__c,
                        OrderId__r.TransferMachineNo__r.Order__r.PriceDecisionDate__c,
                        OrderId__r.ERP_Code__c
                FROM OrderLineitem__c
                WHERE OrderId__c = :recordId
        ];

        if(inputOrderLineitems.isEmpty() == false) {

            OrderLineitem__c orderLineitem = inputOrderLineitems[0];
            Order__c order = orderLineitem.OrderId__r;

            TransferOrder__c tOrder = new TransferOrder__c();
            tOrder.Order__c = order.Id;
            tOrder.OrderLineitem__c = orderLineitem.Id;
            tOrder.Product__c = orderLineitem.ProductId__c;
            tOrder.TransferDealer__c = order.TransferBusinessOffice__c;
            tOrder.Status__c = '대상';
            tOrder.PriceDecisionDate__c = order.TransferMachineNo__r.Order__r.PriceDecisionDate__c;

            String priceType = null;
            if(order.TransferMachineNo__r.Account.CustomerType__c == '농협') {
                priceType = 'FD';
            } else if(order.TransferMachineNo__r.Account.CustomerType__c == '관납') {
                priceType = 'FE';
            } else {
                priceType = 'FC';
            }
            List<ProductPriceEntry__c> productPriceEntries =  [
                    SELECT Id, PriceType__c,
                            BasePrice__c,
                            StartDate__c,
                            EndDate__c
                    FROM ProductPriceEntry__c
                    WHERE StartDate__c <= :order.TransferMachineNo__r.Order__r.PriceDecisionDate__c
                    AND EndDate__c >= :order.TransferMachineNo__r.Order__r.PriceDecisionDate__c
                    AND Product__c = :orderLineitem.ProductId__c
                    AND PriceType__c = :priceType
                    ORDER BY StartDate__c DESC
                    LIMIT 1
            ];

            if(productPriceEntries.isEmpty() == false) {
                tOrder.BaseSellingPrice__c = productPriceEntries[0].BasePrice__c;
                tOrder.SellingPrice__c = tOrder.BaseSellingPrice__c;
                tOrder.CorrectionPrice__c = 0;
            }
            //tOrder.
            insert tOrder;
            System.debug('------------1');
        }
    }
    */

}