/****************************************************************************************
  * @filename      : OrderDeliveryPlanDateUpdate_ba_ts
  * @author        : I2MAX
  * @date          : 2021-11-15
  * @group         :
  * @group-content :
  * @description   : 주문 - 생산계획 관련 예상일자 처리.
  * @reference     :
  * @release       : v1.0.0
  * @copyright     : Copyright © I2max. All Rights Reserved.
  * @modification Log
  * ===============================================================
  * ver     date                     author        description
  * ===============================================================
    1.0     2021-11-15                  I2MAX.YR        Create
****************************************************************************************/


@IsTest
private class OrderDeliveryPlanDateUpdate_ba_ts {
    @IsTest
    static void testBehavior() {
        OrderDeliveryPlanDateUpdate_ba.runTest();
    }
}