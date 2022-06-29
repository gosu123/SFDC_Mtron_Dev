/****************************************************************************************
  * @filename      : OrderERPSendRetrunQa
  * @projectname   :
  * @author        : i2max.seo
  * @date          : 2020-12-10
  * @group         :
  * @group-content :
  * @description   : 전수배 반품 주문 - 전배 대리점 데이터를 반품 처리 한다.
  *
  * @tester        : OrderERPSendRetrunQa_ts.cls
  * @reference     :
  * @copyright     : Copyright © I2max. All Rights Reserved.
  * @modification Log
  * ===============================================================
  * ver     date            author         description
  * ===============================================================
    0.1     2020-04-16      i2max.seo      Create
****************************************************************************************/
public with sharing class OrderERPSendRetrunQa {

	/**
	 * 초기 거래 데이터
	 */
	public class InitData extends I2ComClass.InitData {
		@AuraEnabled public Order__c transferOrder {get;set;}
		@AuraEnabled public Boolean isValidOrder {get;set;}
		@AuraEnabled public String validMessage {get;set;}
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
		initData.transferOrder = [
				SELECT Id, Division__c, SalesDocNo__c, Status__c,
						OrderMaster__r.SalesDocNo__c,
						OrderMaster__r.Status__c,
						OrderMaster__r.IsZRET__c,
						OrderMaster__r.Division__c,
						OrderMaster__r.TransferProcessStatus__c,
						OrderMaster__r.AssetTransferAgreeStatus__c
				FROM Order__c WHERE Id =: recordId
		];


		initData.isValidOrder = (
				initData.transferOrder.Status__c == '영업소 주문 확정' &&
				initData.transferOrder.OrderMaster__r.Status__c == '출하' &&
				String.isEmpty(initData.transferOrder.SalesDocNo__c) == true &&
				initData.transferOrder.OrderMaster__r.Division__c == '전수배공급' &&
				String.isEmpty(initData.transferOrder.OrderMaster__r.SalesDocNo__c) == false &&
				initData.transferOrder.OrderMaster__r.TransferProcessStatus__c == '승인' &&
				initData.transferOrder.OrderMaster__r.AssetTransferAgreeStatus__c == '승인' &&
				initData.transferOrder.OrderMaster__r.IsZRET__c == false)
				? true : false;

		initData.validMessage = '';
		if (!initData.isValidOrder && String.isEmpty(initData.transferOrder.SalesDocNo__c) == false) {
			initData.validMessage  = 'ERP 전수배 반품 주문 신청이 완료된 건 입니다.';
		} else if (initData.transferOrder.OrderMaster__r.Division__c != '전수배공급') {
			initData.validMessage  = '전수배 주문(반품)만 ERP 전송이 가능 합니다.';
		} else if (initData.transferOrder.Status__c != '영업소 주문 확정') {
			initData.validMessage  = '전수배 주문(반품)은 영업소 주문 확정 상태에서만 전송이 가능 합니다.';
		} else if (initData.transferOrder.OrderMaster__r.TransferProcessStatus__c != '승인' && initData.transferOrder.OrderMaster__r.AssetTransferAgreeStatus__c != '승인') {
			initData.validMessage  = '수배 대리점의 전수배 동의와 전배 대리점의 전배 승인이 처리가 되어야 합니다. ';
		} else if (initData.transferOrder.OrderMaster__r.IsZRET__c == true) {
			initData.validMessage  = '이미 ERP 반품 주문 신청이 처리 되었습니다.';
		} else {
			initData.validMessage  = '전수배 공급 주문의 상태가 [출하 대기]일 때, 전수배 반품 주문의 SAP 전송이 가능합니다.';
		}

		return initData;
	}

	/**
	 * 주문 전송 to ERP
	 *
	 * @param recordId : Order__c 의 RecordId
	 */
	@AuraEnabled
	public static Map<String, String> sendERP(final String recordId) {
		Map<String, String> returnMap = new Map<String, String>();
		Order__c transferOrder = [
				SELECT Id, Division__c, SalesDocNo__c, OrderMaster__c
				FROM Order__c WHERE Id =: recordId
		];
		if(String.isNotEmpty(transferOrder.SalesDocNo__c)) {
			throw new AuraHandledException('이미 반품 주문이 처리되었습니다.');
		}
		returnMap = OrderService.IF_KR_SE_ERP_0007_ZRET(transferOrder.OrderMaster__c);
		return returnMap;
	}

}