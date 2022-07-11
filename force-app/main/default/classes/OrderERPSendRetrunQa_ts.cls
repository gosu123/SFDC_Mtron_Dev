/**
** @filename     : OrderERPSendRetrunQa_ts
* @projectname   :
* @author        : CHOI SEONGWON
* @date          : 2020-07-20 오후 3:53
* @group         :
* @group-content :
* @description   : 반품 주문.
* @tester        :
* @reference     :
* @copyright     : Copyright © I2max. All Rights Reserved.
* @modification Log
* ===============================================================
* ver     date             author              description
* ===============================================================
  0.1                            Create
 */
@IsTest
private class OrderERPSendRetrunQa_ts {
	@TestSetup
	static void setup() {
		/*
		 * ================================================================
		 * 필요시 IF_INFO__c 객체의 데이터를 변경하여 insert 할것
		 * one transaction 처리 때문에 TestSetup 에서 insert 할것
		 * ================================================================
		 */
		IF_INFO__c ifInfo = TestDataIFCalloutFactory.createIFInfo();
		ifInfo.IF_ID__c = 'IF_KR_SE_ERP_0007';
		insert ifInfo;
	}

	@IsTest
	static void testBehavior() {
		TestDataSalesFactory.init();
		TestDataProductFactory.init();

		Order__c order = TestDataSalesFactory.orderForPerFarCorp;

		Order__c transferOrder = TestDataSalesFactory.orderForPerFarCorp.clone(false, true);
		transferOrder.RecordTypeId = Schema.SObjectType.Order__c.getRecordTypeInfosByName().get('전수배반품').getRecordTypeId();
		transferOrder.Division__c = '전수배반품';
		transferOrder.SalesDocNo__c = '';
		transferOrder.OrderMaster__c = order.Id;
		insert transferOrder;

		OrderERPSendRetrunQa.InitData initData = OrderERPSendRetrunQa.init(transferOrder.Id);
		transferOrder.SalesDocNo__c = '591';
		update transferOrder;
		initData = OrderERPSendRetrunQa.init(transferOrder.Id);
		System.assertNotEquals(initData.validMessage,null);

		transferOrder.SalesDocNo__c = '';
		transferOrder.Division__c = '전수배공급';
		update transferOrder;
		initData = OrderERPSendRetrunQa.init(transferOrder.Id);
		System.assertNotEquals(initData.validMessage,null);

		transferOrder.SalesDocNo__c = '';
		transferOrder.Division__c = '전수배반품';
		transferOrder.Status__c = '영업소 주문 검토';
		update transferOrder;
		initData = OrderERPSendRetrunQa.init(transferOrder.Id);
		System.assertNotEquals(initData.validMessage,null);

		transferOrder.SalesDocNo__c = '';
		transferOrder.Division__c = '전수배반품';
		transferOrder.Status__c = '영업소 주문 검토';
		update transferOrder;
		order.IsZRET__c = true;
		update order;
		initData = OrderERPSendRetrunQa.init(transferOrder.Id);
		System.assertNotEquals(initData.validMessage,null);

		IfStaticValue__c ifStaticValue = TestDataIFCalloutFactory.createIfStaticValue();
		IF_Base.IfStaticValue(ifStaticValue);
		// Mock 객체 세팅
		Test.setMock(HttpCalloutMock.class, TestDataMockFactory.createSuccessCalloutMock(
				'{"Response":{"Header":{"TrackingId":"38a0f138-ca02-a983-ce9d-64dd5caf0911","TaskId":"IF_KR_SE_ERP_0007","SenderGroup":"CN","SenderCode":"CXP","ResultCode":"S","IFDatetime":"20190603085741","ErrorMsg":"","ErrorCode":"","DestinationGroup":"CN","DestinationCode":"ERP"},"Payload":{"TOTAL_RECORD_CNT":"2"}}}'
		));

		Test.startTest();
		try {
			OrderERPSendRetrunQa.sendERP(transferOrder.Id);
		} catch (Exception e) {}

		Test.stopTest();

	}
}